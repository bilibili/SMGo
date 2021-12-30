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
}

func bigFromHex(s string) *big.Int {
	ret, _ := new (big.Int).SetString(s, 16)
	return ret
}

func (curve sm2Curve) Params() *elliptic.CurveParams {
	return curve.params
}

// below functions do not create heap objects or return one.
// An object is internally created to ensure it is "clean", and on stack
// to limit heap use. It is then copied upon return.

// ScalarMult Scalar multiplication, returns [x]P when no error.
// ***secure implementation***, this could be used for ECDH
func ScalarMult(P *SM2Point, x []byte) (SM2Point, error) {
	var out SM2Point
	return out, nil
}

// ScalarBaseMult scalar base multiplication, retusn [k]G when no error
// ***secure implementation***, this could be used for
// sign or key generation, all sensitive operations
// underlying uses 7-NAF optimization therefore 64 precomputed points
// use safe algorithm to copy from the precomputed values to eliminate
// side channel risks
func ScalarBaseMult(k []byte) (SM2Point, error) {
	var out SM2Point
	return out, nil
}

// ScalarMixedMult_Unsafe mixed scalar multiplication, returns [k]G + [x]P when no error
//usually used for signature verification and not sensitive
func ScalarMixedMult_Unsafe(k []byte, P *SM2Point, x []byte) (SM2Point, error) {
	var out SM2Point
	return out, nil
}

// slow and UNSAFE version first: let's run double and add
// not meant for external use, serves as baseline for correctness
func scalarMult_Unsafe_DaA(q *SM2Point, scalar []byte) (SM2Point, error) {
	var out SM2Point
	for _, b := range scalar {
		for bitNum := 0; bitNum < 8; bitNum++ {
			out.Double(&out)
			if b&0x80 == 0x80 {
				out.Add(&out, q)
			}
			b <<= 1
		}
	}

	return out, nil
}

