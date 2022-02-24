// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2022。作者：郭伟基 guoweiji@bilibili.com

package utils

import (
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
// This function should run very quickly therefore very hard to measure its timing or cache use.
// out must contain all zero or be newly created
func DecomposeNAF(out []int, s []byte, n, w int) {
	if out == nil || s == nil || w <=0 || w > 7 {
		panic("nil or invalid parameters")
	}

	windowSize := 1 << (w+1)
	halfWindow := 1 << w

	carry := false
	for outIdx:=0; outIdx<n-1; outIdx++ {
		bitIdx := n - outIdx - 1
		oldCarry := carry
		var bit int
		bit, carry = getBit(s, bitIdx-1, carry) // minus 1 to adjust to boundary
		if bit == 1 {
			d := getBits(s, bitIdx-1, w)
			if d&1 == 0 && oldCarry {
				d += 1
			}
			if d >= halfWindow {
				d -= windowSize
				carry = true
			}
			out[outIdx] = d
			outIdx += w
		}
	}

	if carry {
		out[n-1] = 1
	}
}

func getBit(s []byte, idx int, carry bool) (bit int, outCarry bool) {
	byteIdx := idx >> 3
	bitIdx := 7 - idx & 7
	bit = int((s[byteIdx] >> bitIdx) & 1)
	if !carry {
		return bit, false
	} else if bit == 0 {
		return 1, false
	} else {
		return 0, true
	}
}

// extracts w + 1 bits from s
func getBits(s []byte, idx, w int) int {
	byteIdx := idx >> 3
	bitIdx := 7 - idx&7

	mask := 1<<(w+1) - 1
	byteLo := int(s[byteIdx] >> bitIdx) & mask

	if bitIdx + w + 1 > 7 && byteIdx > 0 {
		// cross byte
		bitsHi := bitIdx + w + 1 - 8
		byteHi := int(s[byteIdx - 1] & (1<<bitsHi - 1))
		byteLo |= byteHi << (w + 1 - bitsHi)
	}

	return byteLo
}
