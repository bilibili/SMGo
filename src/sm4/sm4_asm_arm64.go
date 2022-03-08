// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build arm64

package sm4

func cryptoBlockAsmX16(rk *uint32, dst, src *byte) {
	var tmp [256]byte
	cryptoBlockAsmX16Internal(rk, dst, src, &tmp[0])
}

//go:noescape
func cryptoBlockAsmX16Internal(rk *uint32, dst, src, tmp *byte) // I know it looks ugly, but let's not wrestle with Go stack management logics


