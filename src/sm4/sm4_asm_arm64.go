// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build arm64

package sm4

func cryptoBlockAsmX16(rk *uint32, dst, src *byte) {
	//safe to reuse dst for tmp: 256 byte array
	cryptoBlockAsmX16Internal(rk, dst, src, dst)
}

//go:noescape
// tmp should be pointer to 256-byte array
func cryptoBlockAsmX16Internal(rk *uint32, dst, src, tmp *byte)
