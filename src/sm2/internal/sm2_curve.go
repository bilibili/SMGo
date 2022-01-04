// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package internal

import (
	"crypto/elliptic"
	"errors"
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

// ScalarMult Scalar multiplication, returns [scalar]P when no error.
// scalar is big endian and its integer value should lie in range of [1, n-1]
// ***secure implementation***, this could be used for ECDH
func ScalarMult(P *SM2Point, scalar *[]byte) (*SM2Point, error) {
	//out := NewSM2Point()
	//return out, nil
	return scalarMult_Unsafe_DaA(P, scalar)
}

// ScalarBaseMult scalar base multiplication, return [k]G when no error
// k is big endian and its integer value should lie in range of [1, n-1]
// ***secure implementation***, this could be used for
// sign or key generation, all sensitive operations
func ScalarBaseMult(k *[]byte) (*SM2Point, error) {
	return scalarBaseMult_Precomputed_DaA(*k)
}

// ScalarMixedMult_Unsafe mixed scalar multiplication, returns [gScalar]G + [scalar]P when no error
// gScalar and scalar are big endian and their integer values should lie in range of [1, n-1]
// usually used for signature verification and not sensitive
// This is an internal function. Do NOT use it out of this library. Use sm. functions.
func ScalarMixedMult_Unsafe(gScalar *[]byte, P *SM2Point, scalar *[]byte) (*SM2Point, error) {
	// slow calculation below, should adopt mixed method and use some NAF optimization etc. TODO
	S, es := ScalarBaseMult(gScalar)
	if es != nil {
		return nil, es
	}

	T, et := ScalarMult(P, scalar)
	if et != nil {
		return nil, et
	}

	sGtP := NewSM2Point().Add(S, T)
	return sGtP, nil
}

var sm2SkipBitExtration [][]*SM2Point
// scalarBaseMult_SkipBitExtraction uses pre-computed table of multiples
// of base point to calculate base-mult. Not sure about the algorithm name,
// similar algorithm is seen from BoringSSL, with 4-bit x 2 and costs
// 31 DOUBLE + 62 ADD. See BoringSSL/crypto/fipsmodule/ec/make_tables.go
// We use 6 bit x 4 and cost 10 DOUBLE + 37 ADD. Name it SkipBitExtration
// based on the pattern of the bit access from the algorithm.
func scalarBaseMult_BitExtraction(k *[]byte) (*SM2Point, error) {
	return nil, nil
}

var sm2PrecomputedForDaA [256]*SM2Point
// scalarBaseMult_Precomputed_DaA
// k should have 32 bytes. If k's actual value is smaller, it should
// be zero-padded from left
func scalarBaseMult_Precomputed_DaA(k []byte) (*SM2Point, error) {
	if len(k) != 32 {
		return nil, errors.New("k not in 32 bytes")
	}

	out := NewSM2Point()
	for i, b := range k {
		for bitNum := 0; bitNum < 8; bitNum++ {
			if b&0x80 == 0x80 {
				out.Add(out, sm2PrecomputedForDaA[i*8 + bitNum]) // not secure here, should call select TODO
			}
			b <<= 1
		}
	}

	return out, nil
}

// slow and UNSAFE version first: let's run double and add
// not meant for external use, serves as baseline for correctness
// 注意，GM/T 0003.1-2012第四节所规定的数据类型转换，要求使用big endian（即自然序，最左边的权重最大，例如123表示100+20+3）
func scalarMult_Unsafe_DaA(q *SM2Point, scalar *[]byte) (*SM2Point, error) {
	out := NewSM2Point()
	for _, b := range *scalar {
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

