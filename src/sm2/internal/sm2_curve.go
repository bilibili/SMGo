// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package internal

import (
	"crypto/elliptic"
	"math/big"
)

type sm2Curve struct {
	params *elliptic.CurveParams
}

var sm2 sm2Curve
func Sm2() sm2Curve {
	return sm2
}

func init() {
	sm2.params = &elliptic.CurveParams{
		Name:    "SM2",
		BitSize: 256,
		P:  bigFromHex("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF"),
		N:  bigFromHex("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54123"),
		B:  bigFromHex("28E9FA9E9D9F5E344D5A9E4BCF6509A7F39789F515AB8F92DDBCBD414D940E93"),
		Gx: bigFromHex("32C4AE2C1F1981195F9904466A39C9948FE30BBFF2660BE1715A4589334C74C7"),
		Gy: bigFromHex("BC3736A2F4F6779C59BDCEE36B692153D0A9877CC62A474002DF32E52139F0A0"),
	}
	initPoints()

	//TODO remove later
	sm2PrecomputedForDaA[255] = NewSM2Generator()
	for i:=1; i<256; i++ {
		sm2PrecomputedForDaA[255 - i] = NewSM2Point().Double(sm2PrecomputedForDaA[256 - i])
	}
}

func bigFromHex(s string) *big.Int {
	ret, _ := new (big.Int).SetString(s, 16)
	return ret
}

func (curve sm2Curve) Params() *elliptic.CurveParams {
	return curve.params
}

// ScalarMult Scalar multiplication, returns [x]P when no error.
// x is big endian and its integer value should lie in range of [1, n-1]
// ***secure implementation***, this could be used for ECDH
func ScalarMult(P *SM2Point, x []byte) (*SM2Point, error) {
	out := NewSM2Point()
	return out, nil
}

// ScalarBaseMult scalar base multiplication, return [k]G when no error
// k is big endian and its integer value should lie in range of [1, n-1]
// ***secure implementation***, this could be used for
// sign or key generation, all sensitive operations
// underlying uses 7-NAF optimization therefore 64 precomputed points
// use safe algorithm to copy from the precomputed values to eliminate
// side channel risks
// w-NAF基本思想是将标量因子重写，使得结果的表示中0比较多，再加上通过对[x]G的预计算，完全节省Double操作，并且只需要 256/(w+1)的加法操作
// 从而大大加快计算速度。在这里，我们使用w = 7，因此只需要32次加法操作即可完成对基点的标量乘法计算
// 具体而言，我们预计算一个表格，其中依次存储如下数值：[1]G, [3]G, [5]G, ..., [63]G
// 然后，我们将k表示为 k = sigma (2^7i)ki, i = 0, 1, 2, ..., 31
func ScalarBaseMult(k []byte) (*SM2Point, error) {
	out := NewSM2Point()

	return out, nil
}

//func to7Naf(k [] byte) []int {
//	s := new(big.Int).SetBytes(k)
//	s.Mod(s, sm2.Params().N)
//
//	for s.Sign() > 0 {
//
//	}
//}

var sm2PrecomputedForDaA [256]*SM2Point
func ScalarBaseMult_Precomputed_DaA(k []byte) (*SM2Point, error) {
	out := NewSM2Point()
	for i, b := range k {
		for bitNum := 0; bitNum < 8; bitNum++ {
			//out.Double(out)
			if b&0x80 == 0x80 {
				out.Add(out, sm2PrecomputedForDaA[i*8 + bitNum]) // not secure here, should call select TODO
			}
			b <<= 1
		}
	}

	return out, nil
}

// ScalarMixedMult_Unsafe mixed scalar multiplication, returns [k]G + [x]P when no error
// k and x are big endian and their integer values should lie in range of [1, n-1]
// usually used for signature verification and not sensitive
func ScalarMixedMult_Unsafe(k []byte, P *SM2Point, x []byte) (*SM2Point, error) {
	out := NewSM2Point()
	return out, nil
}

// slow and UNSAFE version first: let's run double and add
// not meant for external use, serves as baseline for correctness
// 注意，GM/T 0003.1-2012第四节所规定的数据类型转换，要求使用big endian（即自然序，最左边的权重最大，例如123表示100+20+3）
func scalarMult_Unsafe_DaA(q *SM2Point, scalar []byte) (*SM2Point, error) {
	out := NewSM2Point()
	for _, b := range scalar {
		for bitNum := 0; bitNum < 8; bitNum++ {
			out.Double(out)
			if b&0x80 == 0x80 {
				out.Add(out, q)
			}
			b <<= 1
		}
	}

	return out, nil
}

