// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package fiat

import "crypto/subtle"

func (v* SM2Element) MultiSelect(precomputed *[]*[4]uint64, width int, bits byte, fallback *SM2Element, fallbackCond int) {
	var out sm2UntypedFieldElement
	var pre *sm2UntypedFieldElement
	fb := (*sm2UntypedFieldElement)(&(fallback.x))

	fbCond := ^((uint64)(fallbackCond) * 0xffffffffffffffff)
	out[0] = fb[0] & fbCond
	out[1] = fb[1] & fbCond
	out[2] = fb[2] & fbCond
	out[3] = fb[3] & fbCond

	for i:=0; i<width; i++ {
		cond := (uint64)(subtle.ConstantTimeByteEq(byte(i), bits - 1)) * 0xffffffffffffffff
		pre = (*precomputed)[i]
		out[0] |= pre[0] & cond
		out[1] |= pre[1] & cond
		out[2] |= pre[2] & cond
		out[3] |= pre[3] & cond
	}

	v.x[0] = out[0]
	v.x[1] = out[1]
	v.x[2] = out[2]
	v.x[3] = out[3]
}


