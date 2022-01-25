// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2022。作者：郭伟基 guoweiji@bilibili.com

package utils

import (
	"math/big"
	"math/bits"
)

// ConstantTimeCmp returns 1 if a > b, 0 if a == b, -1 otherwise
// a or b must not be nil and treated as unsigned big endian, should both in length l
func ConstantTimeCmp(a, b []byte, l int) int {
	if a == nil || b == nil {
		panic("nil parameter")
	}

	var borrow, diff, d uint32
	for i := l - 1; i >= 0; i-- {
		A := uint32(a[i])
		B := uint32(b[i])
		d, borrow = bits.Sub32(A, B, borrow)
		diff |= d
	}

	if borrow == 0 {
		//a >= b
		if diff != 0 {
			return 1
		} else {
			return 0
		}
	}

	return -1
}

// DecomposeNAF decomposes n-bit big endian integer s into w-NAF in LE
// See Algorithm 1 of https://www.iacr.org/archive/ches2014/87310103/87310103.pdf
// by Naomi Benger, Joop van de Pol, Nigel P. Smart, and Yuval Yarom
func DecomposeNAF(out []int, s *[]byte, n, w int) {
	if out == nil || s == nil {
		panic("nil parameters")
	}

	// TODO with big integer it is easier to implement, but slow
	windowSize := big.NewInt(1 << (w+1))
	halfWindow := 1 << w
	sInt := new(big.Int).SetBytes(*s)
	for i:=0; i<n; i++ {
		if sInt.Bit(0) == 1 {
			d := new(big.Int).Mod(sInt, windowSize)
			if int(d.Int64()) >= halfWindow {
				d.Sub(d, windowSize)
			}
			out[i] = int(d.Int64())
			sInt.Sub(sInt, d)
		}
		sInt.Rsh(sInt, 1)
	}
}