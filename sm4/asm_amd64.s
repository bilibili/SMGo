// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// Implementation: GFNI instruction set extension for S-Box. GFNI instructions can compute
// affine transformation directly (vgf2p8affineqb), as well as fused byte inverse then
// affine transformation (vgf2p8affineinvqb).

// However, GFNI field inversion is based on AES field (x^8 + x^4 + x^3 + x + 1),
// while SM4 field is x^8 + x^7 + x^6 + x^5 + x^4 + x^2 + 1. We need to find the transformation
// formulas, which are coded in pre- and post-inverse affine matrix and constant.

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

// pre- and post-inverse affine matrix
DATA PreAffineMatrix<>+0x00(SB)/8, $0x4c287db91a22505d
GLOBL PreAffineMatrix<>(SB), (NOPTR+RODATA), $8
DATA PostAffineMatrix<>+0x00(SB)/8, $0xf3ab34a974a6b589
GLOBL PostAffineMatrix<>(SB), (NOPTR+RODATA), $8

// pre- and post-inverse affine constant
#define PreAffineConstant 0b00111110
#define PostAffineConstant 0b11010011

// shuffle
DATA Shuffle<>+0x00(SB)/1, $0x03
DATA Shuffle<>+0x01(SB)/1, $0x02
DATA Shuffle<>+0x02(SB)/1, $0x01
DATA Shuffle<>+0x03(SB)/1, $0x00
DATA Shuffle<>+0x04(SB)/1, $0x07
DATA Shuffle<>+0x05(SB)/1, $0x06
DATA Shuffle<>+0x06(SB)/1, $0x05
DATA Shuffle<>+0x07(SB)/1, $0x04
DATA Shuffle<>+0x08(SB)/1, $0x0b
DATA Shuffle<>+0x09(SB)/1, $0x0a
DATA Shuffle<>+0x0A(SB)/1, $0x09
DATA Shuffle<>+0x0B(SB)/1, $0x08
DATA Shuffle<>+0x0C(SB)/1, $0x0f
DATA Shuffle<>+0x0D(SB)/1, $0x0e
DATA Shuffle<>+0x0E(SB)/1, $0x0d
DATA Shuffle<>+0x0F(SB)/1, $0x0c
GLOBL Shuffle<>(SB), (NOPTR+RODATA), $16

// Register allocation

// R8~15: general purpose drafts
// AX, BX, CX, DX: parameters

// the mask for saving round keys during key expansion
#define MASK K1

// X/Y/Z 0~5 draft registers
#define T0x X0
#define T1x X1
#define T2x X2
#define T3x X3
#define T4x X4
#define T5x X5

#define T0y Y0
#define T1y Y1
#define T2y Y2
#define T3y Y3
#define T4y Y4
#define T5y Y5

#define T0z Z0
#define T1z Z1
#define T2z Z2
#define T3z Z3
#define T4z Z4
#define T5z Z5

// X/Y/Z 16  pre-inverse affine matrix
#define VxPreMatrix X16
#define VyPreMatrix Y16
#define VzPreMatrix Z16

// X/Y/Z 17  post-inverse affine matrix
#define VxPostMatrix X17
#define VyPostMatrix Y17
#define VzPostMatrix Z17

// X/Y/Z 18~20 Src, Interim, Dst for affine instructions
#define VxSrc       X18
#define VxInterim   X19
#define VxDst       X20

#define VySrc       Y18
#define VyInterim   Y19
#define VyDst       Y20

#define VzSrc       Z18
#define VzInterim   Z19
#define VzDst       Z20

// X/Y/Z 21~24 for states
#define VxState1    X21
#define VxState2    X22
#define VxState3    X23
#define VxState4    X24

#define VyState1    Y21
#define VyState2    Y22
#define VyState3    Y23
#define VyState4    Y24

#define VzState1    Z21
#define VzState2    Z22
#define VzState3    Z23
#define VzState4    Z24

// X/Y/Z 25 for round key
#define VxRoundKey  X25
#define VyRoundKey  Y25
#define VzRoundKey  Z25

// X/Y/X 26 for byte order shuffle
#define VxShuffle   X26
#define VyShuffle   Y26
#define VzShuffle   Z26

// TODO double check requirements for every instructions

// for each 128-bit lane
//      suppose we begin with: {a0, a1, a2, a3}, {b0, b1, b2, b3}, {c0, c1, c2, c3}, {d0, d1, d2, d3}
//      we want to reach:      {a0, b0, c0, d0}, {a1, b1, c1, d1}, {a2, b2, c2, d2}, {a3, b3, c3, d3}
// we move by 32 bits first, then by 64 bits
#define transpose4x4(V1, V2, V3, V4, Tmp1, Tmp2) \
    VPUNPCKHDQ  V2, V1, Tmp1 \      // Tmp1: a2, b2, a3, b3                     //128: SSE2; 256: AVX2; 512: AVX512F
    VPUNPCKLDQ  V2, V1, V1 \        // V1: a0, b0, a1, b1                       //latency 1, CPI 1
    VPUNPCKHDQ  V4, V3, Tmp2 \      // Tmp2: c2, d2, c3, d3
    VPUNPCKLDQ  V4, V3, V3 \        // V3: c0, d0, c1, d1
    \
    VPUNPCKHQDQ V3, V1, V2 \        // V2: a1, b1, c1, d1
    VPUNPCKHQDQ Tmp2, Tmp1, V4 \    // V4: a3, b3, c3, d3
    VPUNPCKLQDQ V3, V1, V1 \        // V1: a0, b0, c0, d0
    VPUNPCKLQDQ Tmp2, Tmp1, V3 \    // V3: a2, b2, c2, d2

//func transpose4x4(dst *uint32, src *uint32)
TEXT ·transpose4x4(SB),NOSPLIT,$0-16

	MOVQ    dst+0(FP), AX
	MOVQ    src+8(FP), BX

    VMOVDQU32   (BX), X1
    VMOVDQU32   16(BX), X2
    VMOVDQU32   32(BX), X3
    VMOVDQU32   48(BX), X4

    transpose4x4(X1, X2, X3, X4, X5, X6)

    VMOVDQU32   X1, (AX)
    VMOVDQU32   X2, 16(AX)
    VMOVDQU32   X3, 32(AX)
    VMOVDQU32   X4, 48(AX)

    RET

// for 2 128-bit lanes
//      suppose we begin with: {a0, a1, a2, a3}, {b0, b1, b2, b3}, -, -
//      we want to reach:      {a0, b0--}, {a1, b1--}, {a2,b2--}, {a3,b3--}
#define transpose2x4(V1, V2, V3, V4, Tmp1, Tmp2) \
    VPUNPCKHDQ  V2, V1, V3 \      // V3: a2, b2, a3, b3                     //128: SSE2; 256: AVX2; 512: AVX512F
    VPUNPCKLDQ  V2, V1, V1 \        // V1: a0, b0, a1, b1                       //latency 1, CPI 1
    VPUNPCKHQDQ V1, V1, V2 \        // V2: a1, b1, -, -
    VPUNPCKHQDQ V1, V3, V4 \      // V4: a2, b2, -, -

//      suppose we begin with: {a0, b0--}, {a1, b1,--}, {a2, b2--}, {a3, b3--}
//      we want to reach:      {a0, a1, a2, a3}, {b0, b1, b2, b3}, -, -
#define transpose4x2(V1, V2, V3, V4, Tmp1, Tmp2) \
    VPUNPCKLDQ  V2, V1, Tmp1 \        // Tmp1: a0, a1, b0, b1
    VPUNPCKLDQ  V4, V3, Tmp2 \        // Tmp2: a2, a3, b2, b3
    VPUNPCKLQDQ Tmp2, Tmp1, V1 \      // V1: a0, a1, a2, a3
    VPUNPCKHQDQ Tmp2, Tmp1, V2 \      // V1: b0, b1, b2, b3

//func transpose1x4(dst *uint32, src *uint32)
TEXT ·transpose2x4(SB),NOSPLIT,$0-16

	MOVQ    dst+0(FP), AX
	MOVQ    src+8(FP), BX

    VMOVDQU32   (BX), X1
    VMOVDQU32   16(BX), X2
    VMOVDQU32   32(BX), X3
    VMOVDQU32   48(BX), X4

    transpose2x4(X1, X2, X3, X4, X5, X6)

    VMOVDQU32   X1, (AX)
    VMOVDQU32   X2, 16(AX)
    VMOVDQU32   X3, 32(AX)
    VMOVDQU32   X4, 48(AX)

    RET

// for ONE 128-bit lane
//      suppose we begin with: {a0, a1, a2, a3}, -, -, -
//      we want to reach:      {a0---}, {a1---}, {a2---}, {a3---}
#define transpose1x4(V1, V2, V3, V4, Tmp1, Tmp2) \
    VPUNPCKLDQ  V1, V1, Tmp1 \      // Tmp1: a0, a0, a1, a1                     //128: SSE2; 256: AVX2; 512: AVX512F
    VPUNPCKHDQ  V1, V1, V3 \      // V3: a2, a2, a3, a3                     //latency 1, CPI 1
    VPUNPCKHDQ  Tmp1, Tmp1, V2 \    // V2: a1 ---
    VPUNPCKHDQ  V3, V3, V4 \    // V4: a3 ---

//      suppose we begin with: {a0---}, {a1---}, {a2---}, {a3---}
//      we want to reach:      {a0, a1, a2, a3}, -, -, -
#define transpose4x1(V1, V2, V3, V4, Tmp1, Tmp2) \
    VPUNPCKLDQ  V2, V1, Tmp1 \        // Tmp1: a0, a1, -, -
    VPUNPCKLDQ  V4, V3, Tmp2 \        // Tmp2: a2, a3, -, -
    VPUNPCKLQDQ Tmp2, Tmp1, V1 \      // V1: a0, a1, a2, a3

//func transpose1x4(dst *uint32, src *uint32)
TEXT ·transpose1x4(SB),NOSPLIT,$0-16

	MOVQ    dst+0(FP), AX
	MOVQ    src+8(FP), BX

    VMOVDQU32   (BX), X1
    VMOVDQU32   16(BX), X2
    VMOVDQU32   32(BX), X3
    VMOVDQU32   48(BX), X4

    transpose1x4(X1, X2, X3, X4, X5, X6)

    VMOVDQU32   X1, (AX)
    VMOVDQU32   X2, 16(AX)
    VMOVDQU32   X3, 32(AX)
    VMOVDQU32   X4, 48(AX)

    RET

#define loadMatrix(Pre, Post) \
    MOVQ    $PreAffineMatrix<>(SB), R8 \
    MOVQ    $PostAffineMatrix<>(SB), R9 \
    VBROADCASTI32X2     (R8), Pre \ // latency is 3 for 256/512, 1 otherwise; CPI 1
    VBROADCASTI32X2     (R9), Post \ // 128/256: AVX512DQ+AVX512VL; 512: AVX512DQ

#define rev32(Const, R) \
    VPSHUFB     Const, R, R \ // AVX512F(512) or SSE2(128) or AVX2(256), latency 1, CPI 0.5(256)/1(128;512)

#define revStates(Const, S1, S2, S3, S4) \
    rev32(Const, S1) \
    rev32(Const, S2) \
    rev32(Const, S3) \
    rev32(Const, S4) \

#define loadRoundKey(R, RK) \
    MOVD    (R), X1 \
    ADDQ    $4, R \ //TODO replace by offsets to R
    VPBROADCASTD        X1, RK \ // latency is 3 for 256/512, 1 otherwise; CPI 1

#define getXor(B, C, D, Dst, T0, T1, RK) \
    VPXORD  B, C, T0 \ // AVX512F+AVX512VL, latency 1, CPI 0.33(128;256)/0.5(512)
    VPXORD  D, T0, T1 \
    VPXORD  RK, T1, Dst \ // loading round key (running prior to this) costs some latency so move it last

#define transformL(Data, T0, T1, T2, T3) \
    VPROLD    $2,  Data, T0 \ // AVX512F(512)+AVX512VL(128;256), latency 1, CPI 0.5(128;256)/1(512)
    VPROLD    $10, Data, T1 \
    VPROLD    $18, Data, T2 \
    VPROLD    $24, Data, T3 \
    VPXORD    T0, T1, T0 \
    VPXORD    T2, T3, T2 \
    VPXORD    T0, T2, T0 \
    VPXORD    T0, Data, Data \

#define affine(PreMatrix, PostMatrix, Src, Interim, Dst) \
    VGF2P8AFFINEQB $PreAffineConstant, PreMatrix, Src, Interim \ //GFNI + AVX512VL(128;256) / AVX512F(512)
    VGF2P8AFFINEINVQB $PostAffineConstant, PostMatrix, Interim, Dst \ //latency 3?, CPI 0.5(128;256)/1(512)

#define loadShuffle128() \
    MOVQ        $Shuffle<>(SB), R10 \
    VMOVDQU32   (R10), VxShuffle \

#define loadRoundKeyX(R) \
    loadRoundKey(R, VxRoundKey) \

#define getXorX(B, C, D, Dst) \
    getXor(B, C, D, Dst, T0x, T1x, VxRoundKey) \

TEXT ·expandKeyAsm(SB),NOSPLIT,$0-24

    #define loadMask() \
        MOVQ        $1, R8 \
        KMOVW       R8, MASK \

    #define saveKeys(Renc, Rdec, A) \
        VMOVDQU32    A, MASK, (Renc) \
        VMOVDQU32    A, MASK, (Rdec) \
        ADDQ         $4, Renc \
        SUBQ         $4, Rdec \

    #define loadCKey(R, Dst) \
        loadRoundKey(R, Dst) \

    #define transformLPrime(Data) \
        VPROLD    $13,  Data, T0x \ // AVX512F(512)+AVX512VL(128;256), latency 1, CPI 0.5(128;256)/1(512)
        VPROLD    $23, Data, T1x \
        VPXORD    T0x, T1x, T0x \
        VPXORD    T0x, Data, Data \

    #define expandSubRound(A, B, C, D, Renc, Rdec) \
        loadCKey(DX, VxRoundKey) \
        getXorX(B, C, D, VxSrc) \
        affine(VxPreMatrix, VxPostMatrix, VxSrc, VxInterim, VxDst) \
        transformLPrime(VxDst) \
        VPXORD    VxDst, A, A \
        saveKeys(Renc, Rdec, A) \

    #define expandRound(Renc, Rdec) \
        expandSubRound(VxState1, VxState2, VxState3, VxState4, Renc, Rdec) \
        expandSubRound(VxState2, VxState3, VxState4, VxState1, Renc, Rdec) \
        expandSubRound(VxState3, VxState4, VxState1, VxState2, Renc, Rdec) \
        expandSubRound(VxState4, VxState1, VxState2, VxState3, Renc, Rdec) \

    loadMask()
    loadShuffle128()
    loadMatrix(VxPreMatrix, VxPostMatrix)

    MOVD	mk+0(FP), AX
    MOVD	enc+8(FP), BX
    MOVD	dec+16(FP), CX
    MOVD    $CK<>(SB), DX

    ADDQ    $124, CX

    VMOVDQU32   (AX), VxState1
    MOVQ        $FK<>(SB), R8
    VMOVDQU32   (R8), T0x
    rev32(VxShuffle, VxState1)
    VPXORD      T0x, VxState1, VxState1

    transpose1x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)

    expandRound(BX, CX)
    expandRound(BX, CX)
    expandRound(BX, CX)
    expandRound(BX, CX)
    expandRound(BX, CX)
    expandRound(BX, CX)
    expandRound(BX, CX)
    expandRound(BX, CX)

    RET

#define transformLX(Data) \
    transformL(Data, T0x, T1x, T2x, T3x)

#define subRoundX(A, B, C, D) \
    getXorX(B, C, D, VxSrc) \
    affine(VxPreMatrix, VxPostMatrix, VxSrc, VxInterim, VxDst) \
    transformLX(VxDst) \
    VPXORD  VxDst, A, A \

#define roundX(R) \
    loadRoundKeyX(R) \
    subRoundX(VxState1, VxState2, VxState3, VxState4) \
    loadRoundKeyX(R) \
    subRoundX(VxState2, VxState3, VxState4, VxState1) \
    loadRoundKeyX(R) \
    subRoundX(VxState3, VxState4, VxState1, VxState2) \
    loadRoundKeyX(R) \
    subRoundX(VxState4, VxState1, VxState2, VxState3) \


//func cryptoBlockAsm(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsm(SB),NOSPLIT,$0-24

    #define loadInputX1(Src, V1) \ // we should perform transpose/rev later
        VMOVDQU32   (Src), V1 \

    #define storeOutputX1(V1, Dst) \
        VMOVDQU32   V1, (Dst) \

    loadShuffle128()
	MOVQ    src+16(FP), CX
    loadInputX1(CX, VxState1)
    loadMatrix(VxPreMatrix, VxPostMatrix)

	MOVQ    rk+0(FP), AX
	MOVQ    dst+8(FP), BX

    rev32(VxShuffle, VxState1) // latency hiden successfully
    transpose1x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)

    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)

    transpose4x1(VxState4, VxState3, VxState2, VxState1, T0x, T1x)
    rev32(VxShuffle, VxState4)

    storeOutputX1(VxState4, BX)

    RET

//func cryptoBlockAsmX2(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX2(SB),NOSPLIT,$0-24

    #define loadInputX2(Src, V1, V2) \ // we should perform transpose/rev later
        VMOVDQU32   (Src), V1 \
        VMOVDQU32   (16)(Src), V2 \

    #define storeOutputX2(V1, V2, Dst) \
        VMOVDQU32   V1, (Dst) \ //SSE2, latency 5, CPI 1
        VMOVDQU32   V2, (16)(Dst) \

    loadShuffle128()
	MOVQ    src+16(FP), CX
    loadInputX2(CX, VxState1, VxState2)
    loadMatrix(VxPreMatrix, VxPostMatrix)

	MOVQ    rk+0(FP), AX
	MOVQ    dst+8(FP), BX

    rev32(VxShuffle, VxState1) // latency hiden successfully
    rev32(VxShuffle, VxState2)
    transpose2x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)

    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)

    transpose4x2(VxState4, VxState3, VxState2, VxState1, T0x, T1x)
    rev32(VxShuffle, VxState4)
    rev32(VxShuffle, VxState3)

    storeOutputX2(VxState4, VxState3, BX)

    RET

//func cryptoBlockAsmX4(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX4(SB),NOSPLIT,$0-24

    #define loadInputX4(Src, V1, V2, V3, V4) \
        VMOVDQU32   (Src), V1 \
        VMOVDQU32   (16)(Src), V2 \
        VMOVDQU32   (32)(Src), V3 \
        VMOVDQU32   (48)(Src), V4 \

    #define storeOutputX4(V1, V2, V3, V4, Dst) \
        VMOVDQU32   V1, (Dst) \ //SSE2, latency 5, CPI 1
        VMOVDQU32   V2, (16)(Dst) \
        VMOVDQU32   V3, (32)(Dst) \
        VMOVDQU32   V4, (48)(Dst) \

    loadShuffle128()
	MOVQ    src+16(FP), CX
    loadInputX4(CX, VxState1, VxState2, VxState3, VxState4)
    loadMatrix(VxPreMatrix, VxPostMatrix)

	MOVQ    rk+0(FP), AX
	MOVQ    dst+8(FP), BX

    revStates(VxShuffle, VxState1, VxState2, VxState3, VxState4) // latency hiden successfully
    transpose4x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)

    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)
    roundX(AX)

    transpose4x4(VxState4, VxState3, VxState2, VxState1, T0x, T1x)
    revStates(VxShuffle, VxState1, VxState2, VxState3, VxState4)

    storeOutputX4(VxState4, VxState3, VxState2, VxState1, BX)

    RET

//func cryptoBlockAsmX8(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX8(SB),NOSPLIT,$0-24

    #define loadShuffle256() \
        MOVQ                $Shuffle<>(SB), R10 \
        VBROADCASTI32X4     (R10), VyShuffle \ // AVX512F, latency 8? CPI 0.5

    #define loadInputX8(Src, V1, V2, V3, V4) \
        VMOVDQU32   (Src), V1 \ //AVX, latency 7, CPI 0.5
        VMOVDQU32   (32)(Src), V2 \ // we should perform transpose later
        VMOVDQU32   (64)(Src), V3 \
        VMOVDQU32   (96)(Src), V4 \

    #define storeOutputX8(V1, V2, V3, V4, Dst) \
        VMOVDQU32   V1, (Dst) \ //AVX, latency 5, CPI 1
        VMOVDQU32   V2, (32)(Dst) \
        VMOVDQU32   V3, (64)(Dst) \
        VMOVDQU32   V4, (96)(Dst) \

    #define loadRoundKeyY(R) \
        loadRoundKey(R, VyRoundKey) \

    #define getXorY(B, C, D, Dst) \
        getXor(B, C, D, Dst, T0y, T1y, VyRoundKey) \

    #define transformLY(Data) \
        transformL(Data, T0y, T1y, T2y, T3y)

    #define subRoundY(A, B, C, D) \
        getXorY(B, C, D, VySrc) \
        affine(VyPreMatrix, VyPostMatrix, VySrc, VyInterim, VyDst) \
        transformLY(VyDst) \
        VPXORD  VyDst, A, A \

    #define roundY(R) \
        loadRoundKeyY(R) \
        subRoundY(VyState1, VyState2, VyState3, VyState4) \
        loadRoundKeyY(R) \
        subRoundY(VyState2, VyState3, VyState4, VyState1) \
        loadRoundKeyY(R) \
        subRoundY(VyState3, VyState4, VyState1, VyState2) \
        loadRoundKeyY(R) \
        subRoundY(VyState4, VyState1, VyState2, VyState3) \

    loadShuffle256()
	MOVQ    src+16(FP), CX
    loadInputX8(CX, VyState1, VyState2, VyState3, VyState4)
    loadMatrix(VyPreMatrix, VyPostMatrix)

	MOVQ    rk+0(FP), AX
	MOVQ    dst+8(FP), BX

    revStates(VyShuffle, VyState1, VyState2, VyState3, VyState4) // latency hiden successfully
    transpose4x4(VyState1, VyState2, VyState3, VyState4, T0y, T1y)

    roundY(AX)
    roundY(AX)
    roundY(AX)
    roundY(AX)
    roundY(AX)
    roundY(AX)
    roundY(AX)
    roundY(AX)

    transpose4x4(VyState4, VyState3, VyState2, VyState1, T0y, T1y)
    revStates(VyShuffle, VyState1, VyState2, VyState3, VyState4)

    storeOutputX8(VyState4, VyState3, VyState2, VyState1, BX)

    RET

//func cryptoBlockAsmX16(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX16(SB),NOSPLIT,$0-24

    #define loadShuffle512() \
        MOVQ                $Shuffle<>(SB), R10 \
        VBROADCASTI32X4     (R10), VzShuffle \ // AVX512F, latency 8? CPI 0.5

    #define loadInputX16(Src, V1, V2, V3, V4) \ // FIXME: little endian
        VMOVDQU32   (Src), V1 \ //AVX512F, latency 8, CPI 0.5 -- we should delay the transpose operations
        VMOVDQU32   (64)(Src), V2 \
        VMOVDQU32   (128)(Src), V3 \
        VMOVDQU32   (192)(Src), V4 \

    #define storeOutputX16(V1, V2, V3, V4, Dst) \ // FIXME: little endian
        VMOVDQU32   V1, (Dst) \ //AVX512F, latency 5, CPI 1
        VMOVDQU32   V2, (64)(Dst) \
        VMOVDQU32   V3, (128)(Dst) \
        VMOVDQU32   V4, (192)(Dst) \

    #define loadRoundKeyZ(R) \
        loadRoundKey(R, VzRoundKey) \

    #define getXorZ(B, C, D, Dst) \
        getXor(B, C, D, Dst, T0z, T1z, VzRoundKey) \

    #define transformLZ(Data) \
        transformL(Data, T0z, T1z, T2z, T3z) \

    #define subRoundZ(A, B, C, D) \
        getXorZ(B, C, D, VzSrc) \
        affine(VzPreMatrix, VzPostMatrix, VzSrc, VzInterim, VzDst) \
        transformLZ(VzDst) \
        VPXORD  VzDst, A, A \

    #define roundZ(R) \
        loadRoundKeyZ(R) \
        subRoundZ(VzState1, VzState2, VzState3, VzState4) \
        loadRoundKeyZ(R) \
        subRoundZ(VzState2, VzState3, VzState4, VzState1) \
        loadRoundKeyZ(R) \
        subRoundZ(VzState3, VzState4, VzState1, VzState2) \
        loadRoundKeyZ(R) \
        subRoundZ(VzState4, VzState1, VzState2, VzState3) \

    loadShuffle512()
	MOVQ    src+16(FP), CX
    loadInputX16(CX, VzState1, VzState2, VzState3, VzState4) // latency: 8
    loadMatrix(VzPreMatrix, VzPostMatrix)

	MOVQ    rk+0(FP), AX
	MOVQ    dst+8(FP), BX

    revStates(VzShuffle, VzState1, VzState2, VzState3, VzState4) // latency hiden successfully
    transpose4x4(VzState1, VzState2, VzState3, VzState4, T0z, T1z)

    roundZ(AX)
    roundZ(AX)
    roundZ(AX)
    roundZ(AX)
    roundZ(AX)
    roundZ(AX)
    roundZ(AX)
    roundZ(AX)

    transpose4x4(VzState4, VzState3, VzState2, VzState1, T0z, T1z)
    revStates(VzShuffle, VzState1, VzState2, VzState3, VzState4)

    storeOutputX16(VzState4, VzState3, VzState2, VzState1, BX)

    RET

