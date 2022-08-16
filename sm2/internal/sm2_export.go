// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

//go:build tablegen

package internal

import "smgo/sm2/internal/fiat"

func (p *SM2Point) ToMontgomeryAffineX() *fiat.SM2Element {
	if p.z.IsZero() == 1 {
		return new(fiat.SM2Element)
	}

	zinv := new(fiat.SM2Element).Invert(p.z) // safe inversion although it does not matter here
	xx := new(fiat.SM2Element).Mul(p.x, zinv)
	return xx
}

func (p *SM2Point) ToMontgomeryAffineY() *fiat.SM2Element {
	if p.z.IsZero() == 1 {
		return new(fiat.SM2Element)
	}

	zinv := new(fiat.SM2Element).Invert(p.z) // safe inversion although it does not matter here
	yy := new(fiat.SM2Element).Mul(p.y, zinv)
	return yy
}

var (
	ScalarMult_Unsafe_DaA = scalarMult_Unsafe_DaA
)
