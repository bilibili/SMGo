// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2022。作者：郭伟基 guoweiji@bilibili.com

package utils

import "math/bits"

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
