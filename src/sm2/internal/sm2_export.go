// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

//go:build tablegen

package internal

import "smgo/sm2/internal/fiat"

// ToMontgomeryAffine extracts the X and Y in Montgomery domain.
// x, y: the affine coordinates in Montgomery domain.
// This is useful for generating the pre-computed table.
func (p *SM2Point) ToMontgomeryAffine() (x, y *fiat.SM2Element) {
	if p.z.IsZero() == 1 {
		return new(fiat.SM2Element), new(fiat.SM2Element)
	}

	zinv := new(fiat.SM2Element).Invert(p.z) // safe inversion although it does not matter here
	xx := new(fiat.SM2Element).Mul(p.x, zinv)
	yy := new(fiat.SM2Element).Mul(p.y, zinv)
	return xx, yy
}

var (
	ScalarMult_Unsafe_DaA = scalarMult_Unsafe_DaA
)
