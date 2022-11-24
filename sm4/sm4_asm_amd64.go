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
func fillCounterX1(J0 *byte)

//go:noescape
func fillCounterX4(J0 *byte)

//go:noescape
func concatenateY(Y1 *byte, Y2 *byte)

//go:noescape
func concatenateX(X1 *byte, X2 *byte, X3 *byte, X4 *byte)

//go:noescape
func broadcastJ0(j0 *byte)

//go:noescape
func clearRight(dst *byte, len int)

//go:noescape
func makeCounterNew(src *byte, dst *byte)

//go:noescape
func rev1()

//go:noescape
func rev2()
