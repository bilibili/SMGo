// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// optimized partially based on the Intel document "Optimized Galois-Counter-Mode Implementation on Intel Architecture Processors"
// https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/communications-ia-galois-counter-mode-paper.pdf

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

DATA SHUFFLE_X_LANES<>+0x00(SB)/8, $0x06
DATA SHUFFLE_X_LANES<>+0x08(SB)/8, $0x07
DATA SHUFFLE_X_LANES<>+0x10(SB)/8, $0x00
DATA SHUFFLE_X_LANES<>+0x18(SB)/8, $0x01
DATA SHUFFLE_X_LANES<>+0x20(SB)/8, $0x04
DATA SHUFFLE_X_LANES<>+0x28(SB)/8, $0x05
DATA SHUFFLE_X_LANES<>+0x30(SB)/8, $0x06
DATA SHUFFLE_X_LANES<>+0x38(SB)/8, $0x07
GLOBL SHUFFLE_X_LANES<>(SB), (NOPTR+RODATA), $64

DATA MERGE_H01<>+0x00(SB)/8, $0x00
DATA MERGE_H01<>+0x08(SB)/8, $0x00
DATA MERGE_H01<>+0x10(SB)/8, $0x00
DATA MERGE_H01<>+0x18(SB)/8, $0x01
GLOBL MERGE_H01<>(SB), (NOPTR+RODATA), $32

DATA MERGE_H23<>+0x00(SB)/8, $0x00
DATA MERGE_H23<>+0x08(SB)/8, $0x00
DATA MERGE_H23<>+0x10(SB)/8, $0x00
DATA MERGE_H23<>+0x18(SB)/8, $0x00
DATA MERGE_H23<>+0x20(SB)/8, $0x00
DATA MERGE_H23<>+0x28(SB)/8, $0x01
DATA MERGE_H23<>+0x30(SB)/8, $0x02
DATA MERGE_H23<>+0x38(SB)/8, $0x03
GLOBL MERGE_H23<>(SB), (NOPTR+RODATA), $64


// Register allocation

// R8~15: general purpose drafts
// AX, BX, CX, DX: parameters

#define MASK_Mov0_1   K1
#define MASK_Mov01_23 K2

// X/Y/Z 0~6 draft registers
#define T0x X0
#define T1x X1
#define T2x X2
#define T3x X3

#define U1x X4
#define U2x X5

#define U1y Y4
#define U2y Y5

#define T0z Z0
#define T1z Z1
#define T2z Z2
#define T3z Z3

#define U1z Z4
#define U2z Z5

#define VyIdxH01     Y10
#define VzIdxH23     Z11

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

#define VyH          Y21

#define VzDat        Z20
#define VzH          Z21
#define VzHs         Z22

#define VxReduce     X23
#define VzReduce     Z23

#define VxLow        X24
#define VxMid        X25
#define VxHigh       X26

#define VzLow        Z24
#define VzMid        Z25
#define VzHigh       Z26

#define VxTag        X27
#define VzTag        Z27

#define VxH4         X28
#define VyH4         Y28
#define VzH4         Z28

#define VzH4s        Z29

#define VzIdx        Z30

#define DEBUG        X31
#define DEBUGz       Z31

#define RoundKeys R10
#define Out R14
#define In R13
#define InLen R12
#define PreCounter R11
#define Counter R8
#define Tmp R9
#define BlockCount R15

#define loadMasks() \
    MOVQ                $AND_MASK<>(SB), R8 \
    MOVQ                $LOWER_MASK<>(SB), R9 \
    MOVQ                $HIGHER_MASK<>(SB), R10 \
    \//MOVQ                $BSWAP_MASK<>(SB), R11 \
    VBROADCASTI32X4     (R8), VzAndMask \ // latency 8, CPI 0.5
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
    //VPSHUFB     VxBSwapMask, T0, V \

#define mul(Factor, FactorS, Input, Lo, Mid, Hi, T0) \
    \ //Karatsuba Multiplication
    VPCLMULQDQ  $0x00, Input, Factor, Lo \ // the low 128 bit  VPCLMULQDQ + AVX512VL, latency 6, CPI1
    VPSRLDQ     $8, Input, T0 \ // h moved to l
    VPXORD      Input, T0, T0 \ // h^l in lower 64 bits
    VPCLMULQDQ  $0x00, T0, FactorS, Mid \
    VPCLMULQDQ  $0x11, Input, Factor, Hi \ // the high 128 bit

#define reduce(Output, Reduce, Lo, Mid, Hi, T0, T1, T2, T3) \
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
    VPCLMULQDQ  $0x00, Reduce, Hi, T0 \ // the low part
    VPCLMULQDQ  $0x01, Reduce, Hi, T1 \ // the high part
    VPSLLDQ     $8, T1, T2 \
    VPXORD      T2, T0, T0 \
    VPXORD      T0, Lo, Lo \
    \ // we then repeat the multiplication for the highest-64 bit part of previous multiplication (upper of h*poly).
    VPCLMULQDQ  $0x01, Reduce, T1, T3 \
    VPXORD      T3, Lo, Output \

#define load4X() \
    VMOVDQU32   (CX), VzDat \
    ADDQ        $64, CX \
    reverseBits(VzDat, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \

#define load1X() \
    VMOVDQU32   (CX), VxDat \
    ADDQ        $16, CX \
    reverseBits(VxDat, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

//func gHashBlocks(H *byte, tag *byte, data *byte, count int)
TEXT ·gHashBlocks(SB),NOSPLIT,$0-32

	MOVQ	    h+0(FP), AX
	MOVQ	    tag+8(FP), BX
	MOVQ	    data+16(FP), CX
    MOVQ        count+24(FP), DX

    // carefully hide the latency
    VMOVDQU32   (AX), VxH // latency 7, CPI 0.5
    VMOVDQU32   (BX), VxTag // higher lanes will be cleared automatically

    loadMasks()

	MOVQ	            $GCM_POLY<>(SB), R8
	VBROADCASTI32X2     (R8), VzReduce // latency 3, CPI 1

    reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
    reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)

    VPSRLDQ     $8, VxH, VxHs
    VPXORD      VxH, VxHs, VxHs //h^l in lower Hs

    CMPQ        DX, $8 // this could be fine tuned based on benchmark results
    JL          loopBy1

    // precompute H^2, H^3 & H^4
    MOVQ        $SHUFFLE_X_LANES<>(SB), R8
    VMOVDQU32   (R8), VzIdx

    MOVQ        $MERGE_H01<>(SB), R8
    MOVQ        $MERGE_H23<>(SB), R9
    VMOVDQU32   (R8), VyIdxH01
    VMOVDQU32   (R9), VzIdxH23

    MOVQ        $0b00001100, R8
    MOVQ        $0b11110000, R9
    KMOVW       R8, MASK_Mov0_1
    KMOVW       R9, MASK_Mov01_23

    mul(VxH, VxHs, VxH, VxLow, VxMid, VxHigh, T0x)
    reduce(U1x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)

    mul(VxH, VxHs, U1x, VxLow, VxMid, VxHigh, T0x)
    reduce(U2x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)

    mul(VxH, VxHs, U2x, VxLow, VxMid, VxHigh, T0x)
    reduce(VxH4, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)

    // we have H^4 : : :  , we should obtain H^4 : H^3 (U2x) : H^2 (U1x) : H (VxH)
    VPERMQ      U2y, VyIdxH01, MASK_Mov0_1, VyH4
    VPERMQ      VyH, VyIdxH01, MASK_Mov0_1, U1y
    VPERMQ      U1z, VzIdxH23, MASK_Mov01_23, VzH4

    VPSRLDQ     $8, VzH4, VzH4s
    VPXORD      VzH4, VzH4s, VzH4s //h^l in lower Hs

loopBy4:
    load4X()
    VPXORD     VzTag, VzDat, VzDat
    mul(VzH4, VzH4s, VzDat, VzLow, VzMid, VzHigh, T0z)
    reduce(VzTag, VzReduce, VzLow, VzMid, VzHigh, T0z, T1z, T2z, T3z)

    // xor 4 parts together
    // total latency is 8
    VPERMQ      $0b01001110, VzTag, T0z // begin with 0:1:2:3, then exchange 0 vs 1, 2 vs 3 of the 4 128 bit lanes. latency 3, CPI 1
    VPXORD      VzTag, T0z, T0z // we have T0z: 0^1 : 0^1 : 2^3 : 2^3
    VPERMQ      T0z, VzIdx, T1z // we have T1z: 2^3 : 0^1 : 2^3 : 2^3
    VPXORD      T0x, T1x, VxTag // VzTag: 0^1^2^3 : 0: 0: 0 (the higher lanes are cleared automatically - X version has lower CPI)

    SUBQ        $4, DX
    CMPQ        DX, $3
    JG          loopBy4

    CMPQ        DX, $0
    JE          blocksEnd

loopBy1:
    load1X()

    VPXORD     VxTag, VxDat, VxDat
    mul(VxH, VxHs, VxDat, VxLow, VxMid, VxHigh, T0x)
    reduce(VxTag, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)

    SUBQ        $1, DX
    CMPQ        DX, $0
    JG          loopBy1

blocksEnd:
    reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
    VMOVDQU32   VxTag, (BX)

//reverseBits(DEBUGz, VzAndMask, VzHigherMask, VzLowerMask, T1z, T2z)
//VMOVDQU32   DEBUGz, (BX)
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

//func makeCounter(dst *byte, src *byte) --- used registers: DI, SI, AX
TEXT ·makeCounter(SB),NOSPLIT,$0-16

    MOVQ   dst+0(FP), DI
    MOVQ   src+8(FP), SI
    MOVQ   0(SI),     AX
    MOVQ   AX,        0(DI)
    MOVL   8(SI),     AX
    MOVL   AX,         8(DI)
    MOVB   $1,        15(DI)
    RET

//func copy12(dst *byte, src *byte)     --- used registers: DI, SI, AX
TEXT ·copy12(SB),NOSPLIT,$0-16
    MOVQ   dst+0(FP), DI
    MOVQ   src+8(FP), SI
    MOVQ   0(SI),     AX
    MOVQ   AX,        0(DI)
    MOVL   8(SI),     AX
    MOVL   AX,        8(DI)
    RET

//func putUint32(b *byte, v uint32)    --- used registers: DI, SI
TEXT ·putUint32(SB),NOSPLIT,$0-16
    MOVQ b+0(FP), DI
    MOVL v+8(FP), SI
    MOVB SIB, 3(DI)
    SHRL $8, SI
    MOVB SIB, 2(DI)
    SHRL $8, SI
    MOVB SIB, 1(DI)
    SHRL $8, SI
    MOVB SIB, (DI)
    RET

//func makeUint32(b *byte) uint32  --- used registers: DI, SI
TEXT ·makeUint32(SB),NOSPLIT,$0-16
    MOVQ b+0(FP), DI
    MOVB (DI), SIB
    SHLL $8, SI
    MOVB 1(DI), SIB
    SHLL $8, SI
    MOVB 2(DI), SIB
    SHLL $8, SI
    MOVB 3(DI), SIB
    MOVL SI, ret+8(FP)
    RET

//func fillSingleBlockAsm(dst *byte, src *byte, count uint32)  --- used registers: DI, SI,AX
TEXT ·fillSingleBlockAsm(SB),NOSPLIT,$16-24
    MOVQ dst+0(FP), DI
    MOVQ src+8(FP), SI

    MOVQ DI, 0(SP)
    MOVQ SI, 0x8(SP)
    CALL ·copy12(SB)

    MOVQ 0(SP), DI
    MOVQ 0x8(SP), SI
    ADDQ $12, DI
    MOVQ DI, 0(SP)
    MOVL count+16(FP), AX
    MOVL AX, 0x8(SP)
    CALL ·putUint32(SB)
    RET

//func fillCounterX(dst *byte, src *byte, count uint32, blockNum uint32)    --- used registers: DI, SI, AX, BX, CX
TEXT ·fillCounterX(SB), NOSPLIT, $40-24
    MOVQ src+8(FP), DI
    ADDQ $12, DI
    MOVQ DI, 0(SP)
    CALL ·makeUint32(SB)
    MOVQ 0(SP), DI
    SUBQ $12, DI
    MOVQ 0x8(SP), SI
    MOVL count+16(FP), AX
    ADDL SI, AX
    ADDL $1, AX
    MOVL blockNum+20(FP), BX
    MOVQ dst+0(FP), CX
    INCL BX

start:
    DECL BX
    JZ done
    MOVQ CX, 0(SP)
    MOVQ DI, 8(SP)
    MOVL AX, 16(SP)
    CALL ·fillSingleBlockAsm(SB)
    MOVQ 0(SP), CX
    MOVQ 8(SP), DI
    MOVL 16(SP), AX
    ADDQ $16, CX
    ADDL $1, AX
    JMP start

done:
    RET

TEXT ·xorAsm(SB),NOSPLIT,$0-16
    MOVQ src1+0(FP), AX
    MOVQ src2+8(FP), BX
    MOVQ len+16(FP), CX
    MOVQ dst+24(FP), DX
loop:
    CMPQ CX, $0
    JLE done
    SUBQ $1, CX
    MOVB (AX), SIB
    MOVB (BX), DIB
    XORB DIB, SIB
    MOVB SIB, (DX)
    ADDQ $1, AX
    ADDQ $1, BX
    ADDQ $1, DX
    JMP loop
done:
    RET

//cryptoBlocksAsm(roundKeys *uint32, out *byte, in []byte, preCounter *byte, counter *byte, tmp *byte) something happend between uint and int,need check again
TEXT ·cryptoBlocksAsm(SB),NOSPLIT,$40-64
    MOVQ roundKeys+0(FP), RoundKeys
    MOVQ out+8(FP), Out
    MOVQ in+16(FP), In
    MOVQ inLen+24(FP), InLen //InLen
    MOVQ preCount+40(FP), PreCounter
    MOVQ count+48(FP), Counter
    MOVQ tmp+56(FP), Tmp
    MOVL $0, BlockCount  //BlockCount
    
loopX16:
    CMPQ InLen, $256
    JL loopX8
    MOVQ Counter, 0(SP)
    MOVQ PreCounter, 8(SP)
    MOVL BlockCount, 16(SP)
    MOVL $16, 20(SP)
    CALL ·fillCounterX(SB)
    MOVQ RoundKeys, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ Counter, 16(SP)
    CALL ·cryptoBlockAsmX16(SB)
    MOVQ 0(SP), RoundKeys
    MOVQ 8(SP), Tmp
    MOVQ 16(SP), Counter
    MOVQ Out, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ In, 16(SP)
    CALL ·xor256(SB)
    ADDQ $256, Out
    ADDQ $256, In
    ADDQ $16, BlockCount
    SUBQ $256, InLen
    JMP loopX16

loopX8:
    CMPQ InLen, $128
    JL loopX4
    MOVQ Counter, 0(SP)
    MOVQ PreCounter, 8(SP)
    MOVL BlockCount, 16(SP)
    MOVL $8, 20(SP)
    CALL ·fillCounterX(SB)
    MOVQ RoundKeys, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ Counter, 16(SP)
    CALL ·cryptoBlockAsmX8(SB)
    MOVQ 0(SP), RoundKeys
    MOVQ 8(SP), Tmp
    MOVQ 16(SP), Counter
    MOVQ Out, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ In, 16(SP)
    CALL ·xor128(SB)
    ADDQ $128, Out
    ADDQ $128, In
    ADDQ $8, BlockCount
    SUBQ $128, InLen
    JMP loopX8

loopX4:
    CMPQ InLen, $64
    JL loopX2
    MOVQ Counter, 0(SP)
    MOVQ PreCounter, 8(SP)
    MOVL BlockCount, 16(SP)
    MOVL $4, 20(SP)
    CALL ·fillCounterX(SB)
    MOVQ RoundKeys, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ Counter, 16(SP)
    CALL ·cryptoBlockAsmX4(SB)
    MOVQ 0(SP), RoundKeys
    MOVQ 8(SP), Tmp
    MOVQ 16(SP), Counter
    MOVQ Out, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ In, 16(SP)
    CALL ·xor64(SB)
    ADDQ $64, Out
    ADDQ $64, In
    ADDQ $4, BlockCount
    SUBQ $64, InLen
    JMP loopX4

loopX2:
    CMPQ InLen, $32
    JL loopX1
    MOVQ Counter, 0(SP)
    MOVQ PreCounter, 8(SP)
    MOVL BlockCount, 16(SP)
    MOVL $2, 20(SP)
    CALL ·fillCounterX(SB)
    MOVQ RoundKeys, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ Counter, 16(SP)
    CALL ·cryptoBlockAsmX2(SB)
    MOVQ 0(SP), RoundKeys
    MOVQ 8(SP), Tmp
    MOVQ 16(SP), Counter
    MOVQ Out, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ In, 16(SP)
    CALL ·xor32(SB)
    ADDQ $32, Out
    ADDQ $32, In
    ADDQ $2, BlockCount
    SUBQ $32, InLen
    JMP loopX2

loopX1:
    CMPQ InLen, $16
    JL loopX0
    MOVQ Counter, 0(SP)
    MOVQ PreCounter, 8(SP)
    MOVL BlockCount, 16(SP)
    MOVL $1, 20(SP)
    CALL ·fillCounterX(SB)
    MOVQ RoundKeys, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ Counter, 16(SP)
    CALL ·cryptoBlockAsm(SB)
    MOVQ 0(SP), RoundKeys
    MOVQ 8(SP), Tmp
    MOVQ 16(SP), Counter
    MOVQ Out, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ In, 16(SP)
    CALL ·xor16(SB)
    ADDQ $16, Out
    ADDQ $16, In
    ADDQ $1, BlockCount
    SUBQ $16, InLen
    JMP loopX1

loopX0:
    CMPQ InLen, $0
    JLE done
    MOVQ Counter, 0(SP)
    MOVQ PreCounter, 8(SP)
    MOVL BlockCount, 16(SP)
    MOVL $1, 20(SP)
    CALL ·fillCounterX(SB)
    MOVQ RoundKeys, 0(SP)
    MOVQ Tmp, 8(SP)
    MOVQ Counter, 16(SP)
    CALL ·cryptoBlockAsm(SB)
    MOVQ 0(SP), RoundKeys
    MOVQ 8(SP), Tmp
    MOVQ 16(SP), Counter

final:
    MOVQ Tmp, 0(SP)
    MOVQ In, 8(SP)
    MOVQ InLen, 16(SP)
    MOVQ Out, 24(SP)
    CALL ·xorAsm(SB)

done:
    RET











































