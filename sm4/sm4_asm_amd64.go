// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64

package sm4

//go:noescape
func copyAsm(dst *byte, src *byte, len int)

//go:noescape
func transpose4x4(dst *uint32, src *uint32)

//go:noescape
func transpose1x4(dst *uint32, src *uint32)

//go:noescape
func concatenateY(Y1 *byte, Y2 *byte)

//go:noescape
func concatenateX(X1 *byte, X2 *byte, X3 *byte, X4 *byte)

//go:noescape
func cryptoBlockAsmX16(rk *uint32, dst, src *byte)
