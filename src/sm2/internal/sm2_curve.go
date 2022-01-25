// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package internal

import (
	"crypto/elliptic"
	"errors"
	"fmt"
	"math"
	"math/big"
	"smgo/utils"
)

type sm2Curve struct {
	params *elliptic.CurveParams
}

var sm2 sm2Curve
func getCurve() sm2Curve {
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
}

func bigFromHex(s string) *big.Int {
	ret, _ := new (big.Int).SetString(s, 16)
	return ret
}

func GetN() *big.Int {
	return new(big.Int).Set(getCurve().Params().N)
}

func (curve sm2Curve) Params() *elliptic.CurveParams {
	return curve.params
}

// ScalarMult Scalar multiplication, returns [scalar]P when no error.
// scalar is big endian and its integer value should lie in range of [1, n-1]
// ***secure implementation***, this could be used for ECDH
func ScalarMult(P *SM2Point, scalar *[]byte) (*SM2Point, error) {
	const nafWindowWidth = 4
	const nafPrecomputes = 1 << (nafWindowWidth -1) // 8

	// P, 3P, 5P, ... [2i+1]P, ... 15P
	var pPrecomputes [nafPrecomputes]*SM2Point
	pPrecomputes[0] = P
	var p2 = NewSM2Point().Double(P)
	for i:=1; i<len(pPrecomputes); i++ {
		pPrecomputes[i] = NewSM2Point().Add(pPrecomputes[i-1], p2)
	}

	var singed4Naf [257]int
	utils.DecomposeNAF(singed4Naf[:], scalar, 257, nafWindowWidth)
	skip := true
	ret := NewSM2Point()

	for i:=256; i>=0; i-- {
		if !skip {
			ret.Double(ret)
		}

		naf := singed4Naf[i]
		if naf == 0 {
			continue
		}

		tmpPoint := NewSM2Point()
		if naf > 0 {
			idx := (naf - 1) >> 1
			tmpPoint = pPrecomputes[idx]
		} else if naf < 0 {
			idx := (-naf - 1) >> 1
			tmpPoint.Negate(pPrecomputes[idx])
		}

		if skip {
			ret.Set(tmpPoint)
			skip = false
		} else {
			ret.Add(ret, tmpPoint)
		}
	}

	return ret, nil
}

// ScalarBaseMult scalar base multiplication, return [k]G when no error
// k is big endian and its integer value should lie in range of [1, n-1]
// ***secure implementation***, this could be used for
// sign or key generation, all sensitive operations
func ScalarBaseMult(k *[]byte) (*SM2Point, error) {
	//return scalarBaseMult_SkipBitExtraction_4_2_32(k)
	//return scalarBaseMult_SkipBitExtraction_5_3_17(k)
	return scalarBaseMult_SkipBitExtraction_6_3_14(k)
	//return scalarBaseMult_SkipBitExtraction_7_3_12(k)
}

// ScalarMixedMult_Unsafe mixed scalar multiplication, returns [gScalar]G + [scalar]P when no error
// gScalar and scalar are big endian and their integer values should lie in range of [1, n-1]
// usually used for signature verification and not sensitive
// This is an internal function. Do NOT use it out of this library. Use sm. functions.
func ScalarMixedMult_Unsafe(gScalar *[]byte, P *SM2Point, scalar *[]byte) (*SM2Point, error) {
	const nafWindowWidth = 4
	const nafPrecomputes = 1 << (nafWindowWidth -1) // 8

	// P, 3P, 5P, ... [2i+1]P, ... 15P
	var pPrecomputes [nafPrecomputes]*SM2Point
	pPrecomputes[0] = P
	var p2 = NewSM2Point().Double(P)
	for i:=1; i<len(pPrecomputes); i++ {
		pPrecomputes[i] = NewSM2Point().Add(pPrecomputes[i-1], p2)
	}

	var singed4Naf [257]int
	utils.DecomposeNAF(singed4Naf[:], scalar, 257, nafWindowWidth)
	skip := true
	ret := NewSM2Point()

	const window = 6
	const subTableCount = 3
	const iterations = 14
	const remainder = 4

	for i:=256; i>=0; i-- {
		if !skip {
			ret.Double(ret)
		}

		if i<iterations {
			// iterate through the sub-tables for 6-3-14 scheme
			for j:=0; j<subTableCount; j++ {
				bits := extractHigherBits(gScalar, i + j*iterations + remainder, window, subTableCount * iterations)
				if bits > 0 {
					x, y := sm2Precomputed_6_3_14[j][0][bits - 1], sm2Precomputed_6_3_14[j][1][bits - 1]
					tmpPoint := NewFromXY(x, y)
					ret.Add(ret, tmpPoint)
					skip = false
				}
			}
		}

		naf := singed4Naf[i]
		if naf == 0 {
			continue
		}

		tmpPoint := NewSM2Point()
		if naf > 0 {
			idx := (naf - 1) >> 1
			tmpPoint = pPrecomputes[idx]
		} else if naf < 0 {
			idx := (-naf - 1) >> 1
			tmpPoint.Negate(pPrecomputes[idx])
		}

		if skip {
			ret.Set(tmpPoint)
			skip = false
		} else {
			ret.Add(ret, tmpPoint)
		}
	}

	bits := extractLowerBits(gScalar, remainder)
	if bits > 0 {
		x, y := sm2Precomputed_6_3_14_Remainder[0][bits-1], sm2Precomputed_6_3_14_Remainder[1][bits-1]
		tmpPoint := NewFromXY(x, y)
		ret.Add(ret, tmpPoint)
	}

	return ret, nil
}

// scalarBaseMult_SkipBitExtraction_6_3_14 uses pre-computed table of multiples
// of base point to calculate base-mult.
// k should have 32 bytes. If k's actual value is smaller, it should
// be zero-padded from left
//
// Not sure about the algorithm name and nothing found from searching.
// Similar algorithm is seen from BoringSSL, with 4-bit x 2 and costs
// 31 DOUBLE + 62 ADD. See BoringSSL/crypto/fipsmodule/ec/make_tables.go
//
// We use 6 bit x 3 x 14 to cover 252 bits and 15 pre-computed points to cover
// the remaining 4 bits. The runtime cost is 13 DOUBLE + 40 ADD.
// Note: 1 DOUBLE costs about 0.9 ADD.
//
// Name it SkipBitExtration based on the pattern of the bit access of
// the algorithm. We need to pre-compute 204 points, which is less than
// 13 KB static data. This should fit into the L1 cache of most modern
// processors, at least those 64 bit ones.
func scalarBaseMult_SkipBitExtraction_6_3_14(k *[]byte) (*SM2Point, error) {
	return scalarBaseMult_SkipBitExtration(k, &sm2Precomputed_6_3_14, &sm2Precomputed_6_3_14_Remainder, 6, 3, 14, 4)
}

// scalarBaseMult_SkipBitExtraction_5_3_17 is similar to scalarBaseMult_SkipBitExtraction_6_3_14
// 5 bit x 3 x 17 to cover 255 bits, and conditionally add G (in constant time
// and no branching)
// The runtime cost is 16 DOUBLE + 49 ADD, plus, about half caching of static data
// as compared to 6-3-14 scheme.
func scalarBaseMult_SkipBitExtraction_5_3_17(k *[]byte) (*SM2Point, error) {
	return scalarBaseMult_SkipBitExtration(k, &sm2Precomputed_5_3_17, &sm2Precomputed_5_3_17_Remainder,5, 3, 17, 1)
}

func scalarBaseMult_SkipBitExtraction_4_2_32(k *[]byte) (*SM2Point, error) {
	return scalarBaseMult_SkipBitExtration(k, &sm2Precomputed_4_2_32, nil,4, 2, 32, 0)
}

func scalarBaseMult_SkipBitExtraction_7_3_12(k *[]byte) (*SM2Point, error) {
	return scalarBaseMult_SkipBitExtration(k, &sm2Precomputed_7_3_12, &sm2Precomputed_7_3_12_Remainder,7, 3, 12, 4)
}

func scalarBaseMult_SkipBitExtration(k *[]byte, first *[][][]*[4]uint64, second *[][]*[4]uint64,
	window, subTableCount, iterations, remainder int) (*SM2Point, error) {

	if window > 8 || remainder < 0 || remainder > 4 {
		panic("reconsider your choice")
	}

	if window * subTableCount * iterations + remainder != 256 {
		panic("invalid scheme")
	}

	windowWidth := int(math.Pow(2, float64(window)) - 1)
	if len((*first)[0][0]) != windowWidth {
		panic("invalid parameter")
	}

	// k should be in big endian and 32 bytes or this algorithm does not work
	if len(*k) != SM2ElementLength {
		return nil, errors.New(fmt.Sprintf("scalar length (%d) is not %d", len(*k), SM2ElementLength))
	}

	ret := NewSM2Point()

	// first pre-computed table
	skip := true
	for i:=iterations-1; i>=0; i-- {
		if !skip {
			ret.Double(ret)
		}

		// iterate through the sub-tables
		for j:=0; j<subTableCount; j++ {
			bits := extractHigherBits(k, i + j*iterations + remainder, window, subTableCount * iterations)

			tmpPoint := NewSM2Point()
			selectPoints(tmpPoint, &(*first)[j], windowWidth, bits)
			if !skip {
				ret.Add(ret, tmpPoint)
			} else {
				ret.Set(tmpPoint)
				skip = false
			}
		}
	}

	// second pre-computed table
	if remainder >= 1 {
		bits := extractLowerBits(k, remainder)

		var points [][]*[4]uint64
		points = *second

		tmpPoint := NewSM2Point()
		selectPoints(tmpPoint, &points, len(points[0]), bits)
		ret.Add(ret, tmpPoint)
	}

	return ret, nil
}

func extractHigherBits(k *[]byte, idx, window, stepSize int) byte {
	var bits = byte(0)

	for i:=0; i<window; i++ {
		bits |= extractBit(k, i*stepSize + idx) << i
	}

	return bits
}

// extractBit extracts the specified bit from byte array in constant time
func extractBit(k *[]byte, idx int) byte {
	// k is in big endian so higher index means more on the left
	byteIdx := SM2ElementLength -1 - idx>>3
	byteValue := (*k)[byteIdx]

	bitIdx := idx & 7
	bitValue := byteValue >> bitIdx

	return bitValue & 1
}

func extractLowerBits(k *[]byte, count int) byte {
	b := (*k)[SM2ElementLength - 1]
	return b & (1<<count - 1)
}

func selectPoints(out *SM2Point, precomputed *[][]*[4]uint64, width int, bits byte) *SM2Point {
	// security caution: no branching depending on the value of bits - timing leak
	// mask should be 0 or 1 depending on which one to be selected
	//xymasks := make([]int, width)
	//for i:=0; i<width; i++ {
	//	xymasks[i] = subtle.ConstantTimeByteEq(byte(i), bits - 1)
	//}
	//
	//zmask := 1 - subtle.ConstantTimeByteEq(bits, 0)

	out.MultiSelect(precomputed, width, bits)
	return out
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

