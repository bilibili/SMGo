// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package sm2

import (
	"crypto/subtle"
	"errors"
	"fmt"
	"io"
	"math/big"
	"smgo/sm2/internal"
	"smgo/sm2/internal/fiat"
)

// GenerateKeyWithRand generate private key with provided random source
// note that private key will lie in range [1, n-2] as we need
// to calculate 1/(d + 1) for signature
// private key is used as stack variable and then copied out so that this
// function can securely destroy the key material instead of leaving it in
// heap after generation
func GenerateKeyWithRand(rand io.Reader) (priv []byte, x, y *[]byte, err error) {
	priv = make([]byte, 32)
	var tmp []byte
	return priv, &tmp, &tmp, nil
}

var one = big.NewInt(1)
var n = internal.Sm2().Params().N
var nminus1 = new(big.Int).Sub(n, one).Bytes()

// TestPrivateKey tests if the priv has at most 32 bytes, and if it is a valid private key
// for SM2 signature purpose. Returns the length difference if longer than 32, or -1 if
// priv == n - 1, or 0 if everything checks out
//
// TestPrivateKey is made public purposefully.
//
// 一个可以用来测试取值范围的简单事实：n 以 0xF开头，即n > 2^255，因此，对于256位整数而言，
// 满足 x = 1 mod n 的 x 只有一个可能:0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54122
// 即，将 x 的 hex 编码的最后一位减去1
func TestPrivateKey(priv *[]byte) int {
	l := len(*priv) - 32
	if l > 0 {
		return l
	}
	return -1 * subtle.ConstantTimeCompare(*priv, nminus1[:])
}

// SignHashed signs the data which have been hashed from message and public parameters.
//  rand: caller must supply a cryptographically secure random number generator
//  e: the value from hashing the message and public parameters according to the spec
//  priv: the private key has 32 big endian bytes and its encoded value shall not be n - 1
//  r, s: has 32 bytes each
//
// Standard demands that priv should lie in [1, n-2], SignHashed is rather permissive in that
// it handles if priv is larger than or equal to n, except for priv = -1 mod n, which is not
// a valid private key for SM2 signature purpose by definition (we need to calculate 1/(priv + 1)
// and we cannot divide by zero). Still, SignHashed only accepts private key not longer than 32 bytes.
// See doc of TestPrivateKey if you encounter an error message and you'd like to decode the reason code
func SignHashed(rand io.Reader, priv, e *[]byte) (r, s []byte, err error) {
	test := TestPrivateKey(priv)
	if  test != 0 {
		err = errors.New(fmt.Sprintf("invalid private key, reason code: %d.", test))
		return
	}

	for {
		// k 为敏感数据，应避免在堆上分配
		var K [32]byte
		_, err = io.ReadFull(rand, K[:])
		if err != nil {
			return
		}

		var k big.Int
		k.SetBytes(K[:])
		//k.Mod(k, n) // 注意，这个操作使得k并非在[1, n-1]之间均匀分布，而是偏向于 [1, 2^256 - n] 这个区间，所以我们最好重新抽取一次随机数
		if k.Cmp(n) >= 0 {
			continue
		}

		var kG *internal.SM2Point
		kG, err = internal.ScalarBaseMult_Precomputed_DaA(k.Bytes())
		if err != nil {
			return
		}

		var eInt, rInt, sInt, rkInt, dInt, d1Int, tmp big.Int
		var d1, d1Inv fiat.SM2ScalarElement

		x := kG.GetX() // 避免计算y坐标，可以节约计算量

		eInt.SetBytes(*e)
		rInt.Add(x, &eInt)
		rInt.Mod(&rInt, n)

		// 标准要求排除的第一种情形
		if rInt.Sign() == 0 {
			continue
		}

		rkInt.Add(&rInt, &k)
		// 标准要求排除的第二种情形
		if rkInt.Cmp(n) == 0 {
			continue
		}

		dInt.SetBytes(*priv)
		d1Int.Add(&dInt, one)

		//SM2ScalarElement.SetBytes要求长度为32，因此，如果私钥实际长度短于32字节（标准不排除此种情形），左边补零（标准规定使用大端字节序）
		d1Bytes := d1Int.Bytes()
		var buf [32]byte
		copy(buf[32-len(d1Bytes) : ], d1Int.Bytes())

		d1.SetBytes(buf[:]) // priv = n - 1 已经被排除，因此不会导致 d1 = 0
		d1Inv.Invert(&d1) // **常数时间**算法 constant time inversion here, about 10% performance hit

		// 标准要求计算  (k - r * priv) / (1 + priv)
		tmp.Mul(&rInt, &dInt)
		tmp.Sub(&k, &tmp)
		sInt.Mul(&tmp, d1Inv.ToBigInt())
		sInt.Mod(&sInt, n)

		if sInt.Sign() == 0 {
			continue
		}

		// 注意，标准要求使用大端字节序，因此，如果输出结果高位字节为0，big.Int.Bytes()将输出少于32字节
		return ensure32Bytes(&rInt), ensure32Bytes(&sInt), nil
	}
}

func ensure32Bytes(i *big.Int) []byte {
	bytes := i.Bytes()
	var buf [32]byte
	copy(buf[32 - len(bytes) : ], bytes)
	return buf[:]
}

// VerifyHashed verifies if a signature is valid or not.
// All parameters should be given in byte arrays big endian and in 32 bytes
func VerifyHashed(pubx, puby, e, r, s *[]byte) (bool, error) {

	if len(*pubx) != 32 || len(*puby) != 32 || len(*e) != 32 || len(*r) != 32 || len(*s) != 32 {
		return false, errors.New(fmt.Sprintf("parameter not in 32 bytes: %d, %d, %d, %d, %d\n",
			len(*pubx), len(*puby), len(*e), len(*r), len(*s)))
	}

	var rInt, sInt, eInt, t big.Int

	rInt.SetBytes(*r)
	sInt.SetBytes(*s)

	if rInt.Cmp(one) < 0 || sInt.Cmp(one) < 0 || rInt.Cmp(n) >= 0 || sInt.Cmp(n) >= 0 {
		return false, errors.New("r or s not in range [1, n-1]")
	}

	t.Add(&rInt, &sInt)
	t.Mod(&t, n)
	if t.Sign() == 0 {
		return false, errors.New("encountered r + s = n")
	}

	var pubBytes [65]byte
	buf := append(pubBytes[:0], 4)
	buf = append(buf, *pubx...)
	buf = append(buf, *puby...)

	pub, err := internal.NewSM2Point().SetBytes(pubBytes[:])
	if err != nil {
		return false, errors.New("not a valid public key")
	}

	// done sanity check
	// slow calculation below, should adopt mixed method and use some NAF optimization etc. TODO
	sG, es := internal.ScalarBaseMult_Precomputed_DaA(*s)
	if es != nil {
		return false, es
	}

	tP, et := internal.ScalarMult(pub, t.Bytes())
	if et != nil {
		return false, et
	}

	sGtP := internal.NewSM2Point().Add(sG, tP)
	R := sGtP.GetX()
	eInt.SetBytes(*e)
	R.Add(R, &eInt)
	R.Mod(R, n)

	return R.Cmp(&rInt) == 0, nil
}