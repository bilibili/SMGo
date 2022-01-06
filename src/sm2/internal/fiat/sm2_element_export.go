// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

//go:build tablegen

package fiat

func (e *SM2Element) GetRaw() [4]uint64 {
	var ret [4]uint64
	copy(ret[:], e.x[:])
	return ret
}

