// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// Implementation: GFNI instruction set extension for S-Box. GFNI instructions can compute
// affine transformation directly (vgf2p8affineqb), as well as fused byte inverse then
// affine transformation (vgf2p8affineinvqb).

// However, GFNI field inversion is based on AES field (x^8 + x^4 + x^3 + x + 1),
// while SM4 field is x^8 + x^7 + x^6 + x^5 + x^4 + x^2 + 1. We need to find the transformation
// formulas.

// For GFNI availability, see https://en.wikipedia.org/wiki/AVX-512#CPUs_with_AVX-512
// When GFNI is available, AVX512F is also available. We use AVX512 for X16 parallel computing,
// AVX2 for X8 and AVX1 for X4.

// Latency could be found here https://www.agner.org/optimize/instruction_tables.pdf
// or from Intel Intrinsics Guide https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html
// GNFI instruction latency is 3, reciprocal throughput is 0.5-1 for IceLake.

#include "textflag.h"

DATA FK<>+0x00(SB)/4, $0xa3b1bac6
DATA FK<>+0x04(SB)/4, $0x56aa3350
DATA FK<>+0x08(SB)/4, $0x677d9197
DATA FK<>+0x0c(SB)/4, $0xb27022dc
GLOBL FK<>(SB), (NOPTR+RODATA), $16

DATA CK<>+0x00(SB)/4, $0x00070e15
DATA CK<>+0x04(SB)/4, $0x1c232a31
DATA CK<>+0x08(SB)/4, $0x383f464d
DATA CK<>+0x0c(SB)/4, $0x545b6269
DATA CK<>+0x10(SB)/4, $0x70777e85
DATA CK<>+0x14(SB)/4, $0x8c939aa1
DATA CK<>+0x18(SB)/4, $0xa8afb6bd
DATA CK<>+0x1c(SB)/4, $0xc4cbd2d9
DATA CK<>+0x20(SB)/4, $0xe0e7eef5
DATA CK<>+0x24(SB)/4, $0xfc030a11
DATA CK<>+0x28(SB)/4, $0x181f262d
DATA CK<>+0x2c(SB)/4, $0x343b4249
DATA CK<>+0x30(SB)/4, $0x50575e65
DATA CK<>+0x34(SB)/4, $0x6c737a81
DATA CK<>+0x38(SB)/4, $0x888f969d
DATA CK<>+0x3c(SB)/4, $0xa4abb2b9
DATA CK<>+0x40(SB)/4, $0xc0c7ced5
DATA CK<>+0x44(SB)/4, $0xdce3eaf1
DATA CK<>+0x48(SB)/4, $0xf8ff060d
DATA CK<>+0x4c(SB)/4, $0x141b2229
DATA CK<>+0x50(SB)/4, $0x30373e45
DATA CK<>+0x54(SB)/4, $0x4c535a61
DATA CK<>+0x58(SB)/4, $0x686f767d
DATA CK<>+0x5c(SB)/4, $0x848b9299
DATA CK<>+0x60(SB)/4, $0xa0a7aeb5
DATA CK<>+0x64(SB)/4, $0xbcc3cad1
DATA CK<>+0x68(SB)/4, $0xd8dfe6ed
DATA CK<>+0x6c(SB)/4, $0xf4fb0209
DATA CK<>+0x70(SB)/4, $0x10171e25
DATA CK<>+0x74(SB)/4, $0x2c333a41
DATA CK<>+0x78(SB)/4, $0x484f565d
DATA CK<>+0x7c(SB)/4, $0x646b7279
GLOBL CK<>(SB), (NOPTR+RODATA), $128

// Register allocation

// R8~15: general purpose drafts
// AX, BX, CX, DX: parameters



TEXT ·expandKeyAsm(SB),NOSPLIT,$0-24

    RET

//func cryptoBlockAsm(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsm(SB),NOSPLIT,$0-24
	MOVQ rk+0(FP), AX
	MOVQ dst+8(FP), BX
	MOVQ src+16(FP), CX

    RET

//func cryptoBlockAsmX4(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX4(SB),NOSPLIT,$0-24
	MOVQ rk+0(FP), AX
	MOVQ dst+8(FP), BX
	MOVQ src+16(FP), CX

    RET

//func cryptoBlockAsmX8(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX8(SB),NOSPLIT,$0-24
	MOVQ rk+0(FP), AX
	MOVQ dst+8(FP), BX
	MOVQ src+16(FP), CX

    RET

//func cryptoBlockAsmX16(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX16(SB),NOSPLIT,$0-24
	MOVQ rk+0(FP), AX
	MOVQ dst+8(FP), BX
	MOVQ src+16(FP), CX

    RET

