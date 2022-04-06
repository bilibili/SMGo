// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// optimized based on the Intel document "Optimized Galois-Counter-Mode Implementation on Intel Architecture Processors"
// https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/communications-ia-galois-counter-mode-paper.pdf

// rtdsc() can return clock cycles since last reset

#include "textflag.h"

// unfortunately there is nothing like ARM/VRBIT in amd64
DATA AND_MASK<>+0x00(SB)/4, $0x0f0f0f0f
DATA AND_MASK<>+0x04(SB)/4, $0x0f0f0f0f
DATA AND_MASK<>+0x08(SB)/4, $0x0f0f0f0f
DATA AND_MASK<>+0x0c(SB)/4, $0x0f0f0f0f
GLOBL AND_MASK<>(SB), (NOPTR+RODATA), $16

DATA LOWER_MASK<>+0x00(SB)/1, $0x00
DATA LOWER_MASK<>+0x01(SB)/1, $0x08
DATA LOWER_MASK<>+0x02(SB)/1, $0x04
DATA LOWER_MASK<>+0x03(SB)/1, $0x0c
DATA LOWER_MASK<>+0x04(SB)/1, $0x02
DATA LOWER_MASK<>+0x05(SB)/1, $0x0a
DATA LOWER_MASK<>+0x06(SB)/1, $0x06
DATA LOWER_MASK<>+0x07(SB)/1, $0x0e
DATA LOWER_MASK<>+0x08(SB)/1, $0x01
DATA LOWER_MASK<>+0x09(SB)/1, $0x09
DATA LOWER_MASK<>+0x0a(SB)/1, $0x05
DATA LOWER_MASK<>+0x0b(SB)/1, $0x0d
DATA LOWER_MASK<>+0x0c(SB)/1, $0x03
DATA LOWER_MASK<>+0x0d(SB)/1, $0x0b
DATA LOWER_MASK<>+0x0e(SB)/1, $0x07
DATA LOWER_MASK<>+0x0f(SB)/1, $0x0f
GLOBL LOWER_MASK<>(SB), (NOPTR+RODATA), $16

DATA HIGHER_MASK<>+0x00(SB)/1, $0x00
DATA HIGHER_MASK<>+0x01(SB)/1, $0x80
DATA HIGHER_MASK<>+0x02(SB)/1, $0x40
DATA HIGHER_MASK<>+0x03(SB)/1, $0xc0
DATA HIGHER_MASK<>+0x04(SB)/1, $0x20
DATA HIGHER_MASK<>+0x05(SB)/1, $0xa0
DATA HIGHER_MASK<>+0x06(SB)/1, $0x60
DATA HIGHER_MASK<>+0x07(SB)/1, $0xe0
DATA HIGHER_MASK<>+0x08(SB)/1, $0x10
DATA HIGHER_MASK<>+0x09(SB)/1, $0x90
DATA HIGHER_MASK<>+0x0a(SB)/1, $0x50
DATA HIGHER_MASK<>+0x0b(SB)/1, $0xd0
DATA HIGHER_MASK<>+0x0c(SB)/1, $0x30
DATA HIGHER_MASK<>+0x0d(SB)/1, $0xb0
DATA HIGHER_MASK<>+0x0e(SB)/1, $0x70
DATA HIGHER_MASK<>+0x0f(SB)/1, $0xf0
GLOBL HIGHER_MASK<>(SB), (NOPTR+RODATA), $16

DATA BSWAP_MASK<>+0x00(SB)/1, $0x0f
DATA BSWAP_MASK<>+0x01(SB)/1, $0x0e
DATA BSWAP_MASK<>+0x02(SB)/1, $0x0d
DATA BSWAP_MASK<>+0x03(SB)/1, $0x0c
DATA BSWAP_MASK<>+0x04(SB)/1, $0x0b
DATA BSWAP_MASK<>+0x05(SB)/1, $0x0a
DATA BSWAP_MASK<>+0x06(SB)/1, $0x09
DATA BSWAP_MASK<>+0x07(SB)/1, $0x08
DATA BSWAP_MASK<>+0x08(SB)/1, $0x07
DATA BSWAP_MASK<>+0x09(SB)/1, $0x06
DATA BSWAP_MASK<>+0x0a(SB)/1, $0x05
DATA BSWAP_MASK<>+0x0b(SB)/1, $0x04
DATA BSWAP_MASK<>+0x0c(SB)/1, $0x03
DATA BSWAP_MASK<>+0x0d(SB)/1, $0x02
DATA BSWAP_MASK<>+0x0e(SB)/1, $0x01
DATA BSWAP_MASK<>+0x0f(SB)/1, $0x00
GLOBL BSWAP_MASK<>(SB), (NOPTR+RODATA), $16

DATA GCM_POLY<>+0x00(SB)/8, $0x0000000000000087
DATA GCM_POLY<>+0x08(SB)/8, $0x0000000000000000
GLOBL GCM_POLY<>(SB), (NOPTR+RODATA), $16


// Register allocation

// R8~15: general purpose drafts
// AX, BX, CX, DX: parameters

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

// X/Y/Z 16~19 masks
#define VxAndMask    X16
#define VxLowerMask  X17
#define VxHigherMask X18
//#define VxBSwapMask  X19

#define VyAndMask    Y16
#define VyLowerMask  Y17
#define VyHigherMask Y18
//#define VyBSwapMask  Y19

#define VzAndMask    Z16
#define VzLowerMask  Z17
#define VzHigherMask Z18
//#define VzBSwapMask  Z19

#define VxDat        X20
#define VxH          X21
#define VxHs         X22

#define VyDat        Y20
#define VyH          Y21
#define VyHs         Y22

#define VzDat        Z20
#define VzH          Z21
#define VzHs         Z22

#define VxReduce     X23
#define VyReduce     Y23
#define VzReduce     Z23

#define VxLow        X24
#define VxMid        X25
#define VxHigh       X26

#define VyLow        Y24
#define VyMid        Y25
#define VyHigh       Y26

#define VzLow        Z24
#define VzMid        Z25
#define VzHigh       Z26

#define VxTag        X27
#define VyTag        Y27
#define VzTag        Z27

#define DEBUG X31

#define loadMasks() \
    MOVQ                $AND_MASK<>(SB), R8 \
    MOVQ                $LOWER_MASK<>(SB), R9 \
    MOVQ                $HIGHER_MASK<>(SB), R10 \
    \//MOVQ                $BSWAP_MASK<>(SB), R11 \
    VBROADCASTI32X4     (R8), VzAndMask \
    VBROADCASTI32X4     (R9), VzLowerMask \
    VBROADCASTI32X4     (R10), VzHigherMask \
    \//VBROADCASTI32X4     (R11), VzBSwapMask \

#define reverseBits(V, And, Higher, Lower, T0, T1) \
    VPSRLW      $4, V, T0 \ //AVX512BW
    VPANDD      V, And, T1 \ // the lower part
    VPANDD      T0, And, T0 \ // the higher part
    VPSHUFB     T1, Higher, T1 \
    VPSHUFB     T0, Lower, T0 \
    VPXORD      T0, T1, V \
    //VPSHUFB     VxBSwapMask, T0, V \ //not sure if we ever need this, keep it here for now TODO

#define mul(Factor, FactorS, Input, Lo, Mid, Hi, T0) \
    VPSRLDQ     $8, Input, T0 \ // h moved to l
    VPXORD      Input, T0, T0 \ // h^l in lower 64 bits
    \ //Karatsuba Multiplication
    VPCLMULQDQ  $0x00, Input, Factor, Lo \ // the low 128 bit  VPCLMULQDQ + AVX512VL, latency 6, CPI1
    VPCLMULQDQ  $0x11, Input, Factor, Hi \ // the high 128 bit
    VPCLMULQDQ  $0x00, T0, FactorS, Mid \

#define reduce(Output, Lo, Mid, Hi, T0, T1, T2, T3) \
    \ // merge Middle 128 bits to High & Low
    VPXORD      Hi, Lo, T1 \
    VPXORD      Mid, T1, Mid \ // the middle 128 bit
    VPSRLDQ     $8, Mid, T2 \ // ** higher ** 64 bits of middle in lower T2
    VPSLLDQ     $8, Mid, T3 \ // ** lower ** 64 bit of middle in higher T3
    VPXORD      Hi, T2, Hi \
    VPXORD      Lo, T3, Lo \
    \ // reduce 256 bit (Lo:Hi) to 128 bit (Lo) over g(x) = 1 + x + x^2 + x^7 + x^128
    \ // for this multiplication: (l:h)*(poly:0) = l*poly ^ (h*poly)>>64
    \ // with poly = 1 + x + x^2 + x^7
    VPCLMULQDQ  $0x00, VxReduce, Hi, T0 \ // the low part
    VPCLMULQDQ  $0x01, VxReduce, Hi, T1 \ // the high part
    VPSLLDQ     $8, T1, T2 \
    VPXORD      T2, T0, T0 \
    VPXORD      T0, Lo, Lo \
    \ // we then repeat the multiplication for the highest-64 bit part of previous multiplication (upper of h*poly).
    VPCLMULQDQ  $0x01, VxReduce, T1, T3 \
    VPXORD      T3, Lo, Output \

#define load1X() \
    VMOVDQU32   (CX), VxDat \
    ADDQ        $16, CX \
    reverseBits(VxDat, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \



//func gHashBlocks(H *byte, tag *byte, data *byte, count int)
TEXT ·gHashBlocks(SB),NOSPLIT,$0-32

    loadMasks()

	MOVQ	    h+0(FP), AX
	MOVQ	    tag+8(FP), BX
	MOVQ	    data+16(FP), CX
    MOVQ        count+24(FP), DX

	MOVQ	            $GCM_POLY<>(SB), R8
	VBROADCASTI32X2     (R8), VxReduce
//VMOVDQU32 VxReduce, DEBUG

    VMOVDQU32   (AX), VxH
    VMOVDQU32   (BX), VxTag
    reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x) // hide the latency of braodcasting load
    reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)

    VPSRLDQ     $8, VxH, VxHs
    VPXORD      VxH, VxHs, VxHs //h^l in lower Hs

loopBy1:
    load1X()

    VPXORD     VxTag, VxDat, VxDat
    mul(VxH, VxHs, VxDat, VxLow, VxMid, VxHigh, T0x)
    reduce(VxTag, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)


    SUBQ        $1, DX
    CMPQ        DX, $0
    JG         loopBy1

blocksEnd:
    reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
    VMOVDQU32   VxTag, (BX)

//reverseBits(DEBUG, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
//VMOVDQU32   DEBUG, (BX)
    RET

//func xor256(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor256(SB),NOSPLIT,$0-24

	MOVQ    dst+0(FP), AX
	MOVQ    src1+8(FP), BX
	MOVQ    src2+16(FP), CX

    VMOVDQU32   (BX), Z1
    VMOVDQU32   64(BX), Z4
    VMOVDQU32   128(BX), Z7
    VMOVDQU32   192(BX), Z10

    VMOVDQU32   (CX), Z2
    VMOVDQU32   64(CX), Z5
    VMOVDQU32   128(CX), Z8
    VMOVDQU32   192(CX), Z11

    VPXORD      Z1, Z2, Z0
    VPXORD      Z4, Z5, Z3
    VPXORD      Z7, Z8, Z6
    VPXORD      Z10, Z11, Z9

    VMOVDQU32   Z0, (AX)
    VMOVDQU32   Z3, 64(AX)
    VMOVDQU32   Z6, 128(AX)
    VMOVDQU32   Z9, 192(AX)

    RET

//func xor128(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor128(SB),NOSPLIT,$0-24

	MOVQ    dst+0(FP), AX
	MOVQ    src1+8(FP), BX
	MOVQ    src2+16(FP), CX

    VMOVDQU32   (BX), Z1
    VMOVDQU32   64(BX), Z4

    VMOVDQU32   (CX), Z2
    VMOVDQU32   64(CX), Z5

    VPXORD      Z1, Z2, Z0
    VPXORD      Z4, Z5, Z3

    VMOVDQU32   Z0, (AX)
    VMOVDQU32   Z3, 64(AX)

    RET

//func xor64(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor64(SB),NOSPLIT,$0-24

	MOVQ    dst+0(FP), AX
	MOVQ    src1+8(FP), BX
	MOVQ    src2+16(FP), CX

    VMOVDQU32   (BX), Z1
    VMOVDQU32   (CX), Z2
    VPXORD      Z1, Z2, Z0

    VMOVDQU32   Z0, (AX)

    RET

//func xor32(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor32(SB),NOSPLIT,$0-24

	MOVQ    dst+0(FP), AX
	MOVQ    src1+8(FP), BX
	MOVQ    src2+16(FP), CX

    VMOVDQU32   (BX), Y1
    VMOVDQU32   (CX), Y2
    VPXORD      Y1, Y2, Y0

    VMOVDQU32   Y0, (AX)

    RET

//func xor16(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor16(SB),NOSPLIT,$0-24

	MOVQ    dst+0(FP), AX
	MOVQ    src1+8(FP), BX
	MOVQ    src2+16(FP), CX

    VMOVDQU32   (BX), X1
    VMOVDQU32   (CX), X2
    VPXORD      X1, X2, X0

    VMOVDQU32   X0, (AX)

    RET
