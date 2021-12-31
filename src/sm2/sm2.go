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

// TestPrivateKey tests if the priv has 32 bytes, and if it is a valid private key
// for SM2 signature purpose. Returns twice of length difference if not zero, or -1 if
// priv == n - 1, or 0 if everything checks out
//
// TestPrivateKey is made public purposefully.
//
// 一个可以用来测试取值范围的简单事实：n 以 0xF开头，即n > 2^255，因此，对于256位整数而言，
// 满足 x = 1 mod n 的 x 只有一个可能:0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54122
// 即，将 x 的 hex 编码的最后一位减去1
func TestPrivateKey(priv *[]byte) int {
	l := len(*priv) - 32
	if l != 0 {
		return l*2
	}
	return -1 * subtle.ConstantTimeCompare(*priv, nminus1[:])
}

// SignHashed signs the data which have been hashed from message and public parameters
// Standard demands that priv should lie in [1, n-2], SignHashed is rather permissive in that
// it handles if priv is larger than or equal to n, except for priv = -1 mod n, which is not
// a valid private key for SM2 signature purpose by definition (we need to calculate 1/(priv + 1)
// and we cannot divide by zero). Still, SignHashed only accepts private key in 32 bytes.
// For longer one, please do mod n; for shorter one, please think about which end to zero-pad.
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

		var eInt, rInt, sInt, rkInt, dInt, d1Int big.Int
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

		// 标准要求计算  (k - r * priv) / (1 + priv)
		// 其等价于 （(k + r）/ (1  + priv)) - r，使用后者可以节省一次乘法，而且k + r上面已经计算过了(rk)
		// 注意，求逆的时候我们需要使用常数时间算法，虽然慢一点（10%），但可以保证安全性
		dInt.SetBytes(*priv)
		d1Int.Add(&dInt, one)

		// 后面的FromBigInt要求参数不能大于n
		if d1Int.Cmp(n) > 0 {
			d1Int.Sub(&d1Int, n)
		}

		d1.FromBigInt(&d1Int) // priv = n - 1 已经被排除，因此不会导致 d1 = 0
		d1Inv.Invert(&d1) // **常数时间**算法 constant time inversion here, about 10% performance hit

		sInt.Mul(&rkInt, d1Inv.ToBigInt())
		sInt.Sub(&sInt, &rInt) // 结果为正数
		sInt.Mod(&sInt, n) // 结果为非负

		if sInt.Sign() == 0 {
			continue
		}

		return rInt.Bytes(), sInt.Bytes(), nil
	}
}