// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

#include "com_amd64.s"

//********    EXPAND KEY related    ********
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

// **************       function related with expandKey       ***************
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
    loadShuffle128(R8)
    loadMatrix(VxPreMatrix, VxPostMatrix, AX, BX)

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

// **************       function related with CIPH       ***************
//func cryptoBlockAsmX16(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX16(SB),NOSPLIT,$0-24
    loadShuffle512(CX)
	MOVQ    src+16(FP), CX
    loadInputX16(CX, VzState1, VzState2, VzState3, VzState4) // latency: 8
    loadMatrix(VzPreMatrix, VzPostMatrix,AX,BX)

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

//func cryptoBlockAsmX8(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX8(SB),NOSPLIT,$0-24
    loadShuffle256(CX)
	MOVQ    src+16(FP), CX
    loadInputX8(CX, VyState1, VyState2, VyState3, VyState4)
    loadMatrix(VyPreMatrix, VyPostMatrix, AX, BX)

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

//func cryptoBlockAsmX4(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX4(SB),NOSPLIT,$0-24
    loadShuffle128(CX)
	MOVQ    src+16(FP), CX
    loadInputX4(CX, VxState1, VxState2, VxState3, VxState4)
    loadMatrix(VxPreMatrix, VxPostMatrix, AX, BX)

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

//func cryptoBlockAsmX2(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX2(SB),NOSPLIT,$0-24
    loadShuffle128(CX)
	MOVQ    src+16(FP), CX
    loadInputX2(CX, VxState1, VxState2)
    loadMatrix(VxPreMatrix, VxPostMatrix, AX, BX)

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

//func cryptoBlockAsm(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsm(SB),NOSPLIT,$0-24
    loadShuffle128(CX)
	MOVQ    src+16(FP), CX
    loadInputX1(CX, VxState1)
    loadMatrix(VxPreMatrix, VxPostMatrix, AX, BX)

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
