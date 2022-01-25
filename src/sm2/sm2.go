// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package sm2

import (
	"errors"
	"fmt"
	"io"
	"math/big"
	"smgo/sm2/internal"
	"smgo/sm2/internal/fiat"
	"smgo/utils"
)

// GenerateKey generate private key with provided random source
// note that private key will lie in range [1, n-2] as we need
// to calculate 1/(d + 1) for signature
// rand: must NOT be nil. Must be a cryptographically secure random number generator, usually
// caller can simply use rand.Reader from crypto/rand, but alternatives could
// be used especially a hardware backed one, as long as it is cryptographically secure
// x, y: the X and Y coordination of the public key in 32 bytes. Leading bytes could be zero
// so be cautious converting between byte array and big integer.
//
// Security notes: private key is used as stack variable and then copied out so that this
// function can securely destroy the key material instead of leaving it in
// heap after generation
func GenerateKey(rand io.Reader) (priv, x, y []byte, err error) {
	if rand == nil {
		err = errors.New("rand is nil")
		return
	}

	priv = make([]byte, 32)

	for {
		io.ReadFull(rand, priv)
		if TestPrivateKey(&priv) == 0 {
			break
		}
	}

	var pub *internal.SM2Point
	pub, err = internal.ScalarBaseMult(&priv)
	if err != nil {
		return
	}

	var pubBytes []byte
	pubBytes = pub.Bytes_Unsafe()

	return priv, pubBytes[1:33], pubBytes[33:], nil
}

// CheckOnCurve checks if the point given in x and y coordinates, lies on the curve.
func CheckOnCurve(x, y *[]byte) bool {
	var xe, ye *fiat.SM2Element
	var err error
	xe, err = new(fiat.SM2Element).SetBytes(*x)
	if err != nil {
		return false
	}
	ye, err = new(fiat.SM2Element).SetBytes(*y)
	if err != nil {
		return false
	}
	return internal.Sm2CheckOnCurve(xe, ye) == nil
}

var one = big.NewInt(1)
var n = internal.GetN()
var nBytes = n.Bytes()
var nMinus1 = new(big.Int).Sub(n, one)
var nMinus1Bytes = nMinus1.Bytes()

// TestPrivateKey tests if the priv has at most 32 bytes, and if it is in range [1, n-2]
// Returns the length difference if longer than 32, or -1 if not in the range,
// or 0 if everything checks out
//
// TestPrivateKey runs in constant time.
func TestPrivateKey(priv *[]byte) int {
	l := len(*priv) - 32
	if l > 0 {
		return l
	}
	if l < 0 {
		return 0
	}

	cmp := utils.ConstantTimeCmp((*priv)[:], nMinus1Bytes[:], 32)
	if cmp == -1 {
		return 0
	}

	return -1
}

// SignHashed signs the data which have been hashed from message and public parameters.
//  rand: caller must supply a cryptographically secure random number generator
//  e: the value from hashing the message and public parameters according to the spec
//  priv: the private key has 32 big endian bytes and its encoded value shall not be n - 1
//  r, s: has 32 bytes each
//
// Standard demands that priv should lie in [1, n-2], SignHashed only accepts private key in that range.
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

		if utils.ConstantTimeCmp(K[:], nBytes[:], 32) >= 0 {
			continue
		}

		var kG *internal.SM2Point
		KK := K[:]
		kG, err = internal.ScalarBaseMult(&KK)
		if err != nil {
			return
		}

		var eInt, rInt, sInt, rkInt, dInt, d1Int big.Int
		var d1, d1Inv fiat.SM2ScalarElement

		x := kG.GetAffineX_Unsafe() // 避免计算y坐标，可以节约计算量。由于x不需要保密，可以使用快速版本，但z的数值会泄露信息吗？TODO

		eInt.SetBytes(*e)
		rInt.Add(x, &eInt)
		rInt.Mod(&rInt, n)

		// 标准要求排除的第一种情形
		if rInt.Sign() == 0 {
			continue
		}

		var k big.Int
		k.SetBytes(K[:])

		rkInt.Add(&rInt, &k)
		// 标准要求排除的第二种情形
		rkBytes := rkInt.Bytes()
		if len(rkBytes) == 32 && utils.ConstantTimeCmp(rkBytes[:], nBytes[:], 32) == 0 {
			continue
		}

		dInt.SetBytes(*priv)
		d1Int.Add(&dInt, one)

		//SM2ScalarElement.SetBytes要求长度为32，因此，如果私钥实际长度短于32字节（标准不排除此种情形），左边补零（标准规定使用大端字节序）
		d1Bytes := d1Int.Bytes()
		var buf [32]byte
		copy(buf[32-len(d1Bytes) : ], d1Bytes)

		d1.SetBytes(buf[:]) // priv = n - 1 已经被排除，因此不会导致 d1 = 0
		d1Inv.Invert(&d1) // **常数时间**算法 constant time inversion here, about 10% performance hit

		// 标准要求计算  (k - r * priv) / (1 + priv)
		// 这等价于 (k + r) / (1 + priv) - r
		// 后者可以节约一次乘法
		sInt.Mul(&rkInt, d1Inv.ToBigInt())
		sInt.Sub(&sInt, &rInt)
		sInt.Mod(&sInt, n)

		if sInt.Sign() == 0 {
			continue
		}

		// 注意，标准要求使用大端字节序，因此，如果输出结果高位字节为0，big.Int.Bytes_Unsafe()将输出少于32字节
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
	var err error
	var result, pub *internal.SM2Point

	buf := append(pubBytes[:0], 4)
	buf = append(buf, *pubx...)
	buf = append(buf, *puby...)

	pub, err = internal.NewSM2Point().SetBytes(pubBytes[:])
	if err != nil {
		return false, errors.New("not a valid public key")
	}

	// done sanity check
	var tBytes []byte
	tBytes = t.Bytes()

	result, err = internal.ScalarMixedMult_Unsafe(s, pub, &tBytes)
	if err != nil {
		return false, err
	}

	R := result.GetAffineX_Unsafe()
	eInt.SetBytes(*e)
	R.Add(R, &eInt)
	R.Mod(R, n)

	return R.Cmp(&rInt) == 0, nil
}