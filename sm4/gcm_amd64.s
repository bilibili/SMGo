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

#define Enc AX
#define Dst BX
#define Nonce DX
#define Plaintext DI
#define Ciphertext DI
#define AdditionalData SI
#define H R10
#define TMask R11
#define J0 R12
#define Tag R13
#define TagSize CX
#define RetLen R14
#define RetCap DX
#define Ret R15
#define Res R15

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
#define makeCounter(dst, src, temp) \
    MOVQ   0(src),     temp    \
    MOVQ   temp,        0(dst) \
    MOVL   8(src),     temp    \
    MOVL   temp,         8(dst) \
    MOVB   $1,        15(dst)   \

//func copy12(dst *byte, src *byte)     --- used registers: DI, SI, AX
#define copy12(dst, src, temp)  \
    MOVQ   0(src),     temp \
    MOVQ   temp,        0(dst) \
    MOVL   8(src),     temp  \
    MOVL   temp,        8(dst)  \

//func copy(dst *byte, src *byte, len int)  ---used registers: DI, SI, AX, BX,
TEXT ·copyAsm(SB),NOSPLIT,$0-24
    MOVQ dst+0(FP), DI
    MOVQ src+8(FP), SI
    MOVQ len+16(FP), AX
copyQ:
    CMPQ AX, $8
    JL copyL
    MOVQ 0(SI), BX
    MOVQ BX, 0(DI)
    ADDQ $8, SI
    ADDQ $8, DI
    SUBQ $8, AX
    JMP copyQ
copyL:
    CMPQ AX, $4
    JL copyW
    MOVL 0(SI), BX
    MOVL BX, 0(DI)
    ADDQ $4, SI
    ADDQ $4, DI
    SUBQ $4, AX
    JMP copyL
copyW:
    CMPQ AX, $2
    JL copyB
    MOVW 0(SI), BX
    MOVW BX, 0(DI)
    ADDQ $2, SI
    ADDQ $2, DI
    SUBQ $2, AX
    JMP copyW
copyB:
    CMPQ AX, $1
    JL done
    MOVB 0(SI), BX
    MOVB BX, 0(DI)
    ADDQ $1, SI
    ADDQ $1, DI
    SUBQ $1, AX
    JMP copyB
done:
    RET
    
//func putUint32(b *byte, v uint32)    --- used registers: DI, SI
#define putUint32(b,v) \
    MOVB v, 3(b)  \
    SHRL $8, v    \
    MOVB v, 2(b)  \
    SHRL $8, v    \
    MOVB v, 1(b)  \
    SHRL $8, v    \
    MOVB v, (b)   \

//func putUint64(b *byte, v uint64)  --- used registers: SI, DI   why not SHRQ? this need test later
#define putUint64(b,v) \
    MOVB v, 7(b)  \
    SHRL $8, v    \
    MOVB v, 6(b)  \
    SHRL $8, v    \
    MOVB v, 5(b)  \
    SHRL $8, v    \
    MOVB v, 4(b)  \
    SHRL $8, v    \
    MOVB v, 3(b)  \
    SHRL $8, v    \
    MOVB v, 2(b)  \
    SHRL $8, v    \
    MOVB v, 1(b)  \
    SHRL $8, v    \
    MOVB v, (b)   \

//func makeUint32(b *byte) uint32  --- used registers: DI, SI
#define makeUint32(b,v) \
    MOVB (b), v  \
    SHLL $8, v   \
    MOVB 1(b), v \
    SHLL $8, v   \
    MOVB 2(b), v \
    SHLL $8, v   \
    MOVB 3(b), v \

//func fillSingleBlockAsm(dst *byte, src *byte, count uint32)  --- used registers: DI, SI,AX
#define fillSingleBlockAsm(dst, src, count, temp) \
    copy12(dst, src, temp) \
    ADDQ $12, dst          \
    MOVQ count, temp       \
    putUint32(dst, temp)  \
    ADDQ $4, dst          \


#define fillCounterX1(dst, src, count, blockNum, temp1, temp2) \
    ADDQ $12, src         \
    makeUint32(src,temp1)  \
    SUBQ $12, src         \
    ADDL count, temp1     \
    ADDL $1, temp1        \
    INCL blockNum         \
start: DECL blockNum      \
    JZ fillEnd            \
    fillSingleBlockAsm(dst, src, temp1, temp2) \
    ADDL $1, temp1 \
    JMP start \
fillEnd: ADDL blockNum, count \

//func fillCounterX(dst *byte, src *byte, count uint32, blockNum uint32)    --- used registers: DI, SI, AX, BX, CX
TEXT ·fillCounterX(SB), NOSPLIT, $40-24
    MOVQ src+8(FP), DI
    ADDQ $12, DI
//MOVQ DI, 0(SP)
    makeUint32(DI, SI)
//CALL ·makeUint32(SB)
//MOVQ 0(SP), DI
    SUBQ $12, DI
//MOVQ 0x8(SP), SI
    MOVL count+16(FP), AX
    ADDL SI, AX
    ADDL $1, AX
    MOVL blockNum+20(FP), BX
    MOVQ dst+0(FP), CX
    INCL BX

start:
    DECL BX
    JZ done
    //MOVQ CX, 0(SP)
    //MOVQ DI, 8(SP)
    //MOVL AX, 16(SP)
    fillSingleBlockAsm(CX, DI, AX, DX)
    //CALL ·fillSingleBlockAsm(SB)
    //MOVQ 0(SP), CX
    //MOVQ 8(SP), DI
    //MOVL 16(SP), AX
    //ADDQ $16, CX
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

//cryptoBlocksAsm(roundKeys *uint32, out []byte, in []byte, preCounter *byte, counter *byte, tmp *byte) --- used registers: R8-R15, SI,DI,AX-DX  something happend between uint and int,need check again
TEXT ·cryptoBlocksAsm(SB),NOSPLIT,$40-80
    MOVQ roundKeys+0(FP), RoundKeys
    MOVQ out+8(FP), Out
    MOVQ in+32(FP), In
    MOVQ inLen+40(FP), InLen //InLen
    MOVQ preCount+56(FP), PreCounter
    MOVQ count+64(FP), Counter
    MOVQ tmp+72(FP), Tmp

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

//func gHashUpdateAsm(H *byte, tag *byte, in []byte, tmp *byte)
TEXT ·gHashUpdateAsm(SB),NOSPLIT,$32-48
    MOVQ h+0(FP), DI
    MOVQ tag+8(FP), SI
    MOVQ in+16(FP), AX
    MOVQ l+24(FP), BX
    MOVQ BX, R13
    MOVQ BX, R15
    ANDQ $15, R13
    CMPQ BX, $16
    JL last
    MOVQ DI, 0(SP)
    MOVQ SI, 8(SP)
    MOVQ AX, 16(SP)
    SHRQ $4, BX
    MOVQ BX, 24(SP)
    CALL ·gHashBlocks(SB)
    MOVQ 16(SP), AX
last:
    CMPQ R13, $0
    JE done
    MOVQ tmp+40(FP), CX
    //clear zero for tmp
    MOVQ $0, (CX)
    MOVQ $0, 8(CX)
    SUBQ R13, R15
    ADDQ R15, AX
    MOVQ DI, R15
    MOVQ SI, R14
    MOVQ CX, 0(SP)
    MOVQ AX, 8(SP)
    MOVQ R13, 16(SP)
    CALL ·copyAsm(SB)
    MOVQ R15, 0(SP)
    MOVQ R14, 8(SP)
    MOVQ CX, 16(SP)
    MOVQ $1, 24(SP)
    CALL ·gHashBlocks(SB)
done:
    RET

//func gHashFinishAsm(H *byte, tag *byte,tmp *byte, aadLen uint64, plainLen uint64)
TEXT ·gHashFinishAsm(SB),NOSPLIT,$32-40
    MOVQ tmp+16(FP), AX
    MOVQ aadLen+24(FP), BX
    MOVQ plainLen+32(FP), CX
    SHLQ $3, BX
    SHLQ $3, CX
    //MOVQ AX, 0(SP)
    //MOVQ BX, 8(SP)
    putUint64(AX,BX)
    //CALL ·putUint64(SB)
    ADDQ $8, AX
    //MOVQ AX, 0(SP)
    //MOVQ CX, 8(SP)
    putUint64(AX,CX)
    //CALL ·putUint64(SB)
    SUBQ $8, AX
    MOVQ AX, 16(SP)
    MOVQ h+0(FP), AX
    MOVQ AX, 0(SP)
    MOVQ tag+8(FP), AX
    MOVQ AX, 8(SP)
    MOVQ $1, 24(SP)
    CALL ·gHashBlocks(SB)
    RET

//func calculateFirstCounterAsm(nonce []byte, counter *byte, H *byte, tmp *byte)
TEXT ·calculateFirstCounterAsm(SB),NOSPLIT,$48-48
    MOVQ nonce+0(FP), DI
    MOVQ nonceLen+8(FP), SI
    MOVQ nonceCap+16(FP), DX
    MOVQ counter+24(FP), AX
    MOVQ h+32(FP), BX
    MOVQ tmp+40(FP), CX
    CMPQ SI, $12
    JE branch1
    MOVQ BX, 0(SP)
    MOVQ AX, 8(SP)
    MOVQ DI, 16(SP)
    MOVQ SI, 24(SP)
    MOVQ DX, 32(SP)
    MOVQ CX, 40(SP)
    CALL ·gHashUpdateAsm(SB)
    MOVQ 24(SP), SI
    MOVQ 40(SP), CX
    MOVQ CX, 16(SP)
    MOVQ $0, 24(SP)
    MOVQ SI, 32(SP)
    CALL ·gHashFinishAsm(SB)
    JMP done

branch1:
    //MOVQ AX, 0(SP)
    //MOVQ DI, 8(SP)
    makeCounter(AX, DI, CX)
    //CALL ·makeCounter(SB)

done:
    RET

TEXT ·needExpandAsm(SB), $0-40
    MOVQ array+0(FP), DI
    MOVQ arrayLen+8(FP), SI
    MOVQ arrayCap+16(FP), AX
    MOVQ asked+24(FP), BX
    SUBQ SI, AX
    CMPQ AX, BX
    JGE keepBranch
    MOVQ $1, ret1+32(FP)
    JMP done
keepBranch:
    MOVQ $0, ret1+32(FP)
done:
    RET


//func sealAsm(roundKeys *uint32, tagSize int, dst []byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte) []byte
//temp:  H, TMask, J0, tag, counter, tmp, CNT-256, TMP-256
//cryptoBlockAsm: 24, calculateFirstCounterAsm:48, ensureCapacityAsm:32  cryptoBlocksAsm:80  gHashUpdateAsm:48 gHashFinishAsm:40
TEXT ·sealAsm(SB), NOSPLIT, $80-144    //80->88
    //used registers: AX, R10 (not include the function used)
    MOVQ roundKeys+0(FP), Enc
    MOVQ h+112(FP), H
    MOVQ Enc, 0(SP)
    MOVQ H, 8(SP)
    MOVQ H, 16(SP)
    CALL ·cryptoBlockAsm(SB)
    MOVQ 8(SP), H

    //used registers: DX, R9, R12, R11
    MOVQ nonce+40(FP), Nonce
    MOVQ Nonce, 0(SP)
    MOVQ nonceLen+48(FP), Nonce
    MOVQ Nonce, 8(SP)
    MOVQ nonceCap+56(FP), Nonce
    MOVQ Nonce, 16(SP)
    MOVQ temp+112(FP), Tmp
    MOVQ Tmp, J0
    ADDQ $32, J0
    MOVQ J0, 24(SP)
    MOVQ H, 32(SP)
    ADDQ $80, Tmp
    MOVQ Tmp, 40(SP)
    CALL ·calculateFirstCounterAsm(SB)
    MOVQ 24(SP), J0
    MOVQ 40(SP), TMask

    //used registers: R11, AX, R12
    SUBQ $64, TMask
    MOVQ roundKeys+0(FP), Enc
    MOVQ Enc, 0(SP)
    MOVQ TMask, 8(SP)
    MOVQ J0, 16(SP)
    CALL ·cryptoBlockAsm(SB)

    //used registers: AX, R15, R14, DX, DI, R12  ---- R9
    MOVQ dst+16(FP), Ret
    MOVQ dstLen+24(FP), RetLen
    MOVQ dstCap+32(FP), RetCap
    MOVQ roundKeys+0(FP), Enc
    MOVQ Enc, 0(SP)
    ADDQ RetLen, Ret
    MOVQ Ret, 8(SP)
    SUBQ RetLen, RetCap
    MOVQ RetCap, 16(SP)
    MOVQ RetCap, 24(SP)
    MOVQ plaintext+64(FP), Plaintext
    MOVQ Plaintext, 32(SP)
    MOVQ plaintextLen+72(FP), Plaintext
    MOVQ Plaintext, 40(SP)
    MOVQ plaintextCap+80(FP), Plaintext
    MOVQ Plaintext, 48(SP)
    MOVQ temp+112(FP), J0
    ADDQ $32, J0
    MOVQ J0, 56(SP)
    ADDQ $48, J0
    MOVQ J0, 64(SP)
    ADDQ $256, J0
    MOVQ J0, 72(SP)
    CALL ·cryptoBlocksAsm(SB)

    MOVQ h+112(FP), H
    MOVQ H, 0(SP)
    MOVQ dst+16(FP), Ret
    MOVQ dstLen+24(FP), RetLen
    ADDQ RetLen, Ret
    MOVQ plaintextLen+72(FP), Plaintext
    ADDQ Plaintext, Ret
    MOVQ Ret, 8(SP)

    MOVQ additionalData+88(FP), AdditionalData
    MOVQ AdditionalData, 16(SP)
    MOVQ additionalDataLen+96(FP), AdditionalData
    MOVQ AdditionalData, 24(SP)
    MOVQ additionalDataCap+104(FP), AdditionalData
    MOVQ AdditionalData, 32(SP)
    MOVQ temp+112(FP), Tmp
    ADDQ $80, Tmp
    MOVQ Tmp, 40(SP)
    CALL ·gHashUpdateAsm(SB)
    MOVQ 8(SP), Tag

    //used registers: R15, CX, DI --- R9, DI
    MOVQ plaintextLen+72(FP), Plaintext
    SUBQ Plaintext, Tag
    MOVQ Tag, 16(SP)
    MOVQ Plaintext, 24(SP)
    MOVQ Plaintext, 32(SP)
    CALL ·gHashUpdateAsm(SB)
    MOVQ 40(SP), Tmp
    MOVQ 24(SP), Plaintext

    //used registers: R9, SI, DI

    MOVQ Tmp, 16(SP)
    MOVQ additionalDataLen+96(FP), AdditionalData
    MOVQ AdditionalData, 24(SP)
    MOVQ Plaintext, 32(SP)
    CALL ·gHashFinishAsm(SB)
    MOVQ 8(SP), Tag

    //used registers: R13
    MOVQ Tag, 0(SP)
    MOVQ Tag, 8(SP)
    MOVQ temp+112(FP), TMask
    ADDQ $16, TMask
    MOVQ TMask, 16(SP)
    CALL ·xor16(SB)

    MOVQ dst+16(FP), Ret
    MOVQ Ret, ret1+120(FP)
    MOVQ dstCap+32(FP), RetCap
    MOVQ RetCap, ret2+128(FP)
    MOVQ RetCap, ret3+136(FP)

    RET

//func constantTimeCompareAsm(x *byte, y *byte, l int) int32
TEXT ·constantTimeCompareAsm(SB), NOSPLIT, $0-28
    MOVQ x+0(FP), DI
    MOVQ y+8(FP), SI
    MOVQ l+16(FP), AX
    MOVQ $0, BX
    MOVQ $0, CX
fastCmp:
    CMPQ AX, $8
    JL slowCmp
    MOVQ (DI), DX
    XORQ DX, (SI)
    ORQ (SI),BX
    ADDQ $8, DI
    ADDQ $8, SI
    SUBQ $8, AX
    JMP fastCmp
slowCmp:
    CMPQ AX, $1
    JL done
    MOVB (DI), DX
    XORB DX, (SI)
    ORB (SI), CX
    ADDQ $1, DI
    ADDQ $1, SI
    SUBQ $1, AX
    JMP slowCmp
done:
    ORB BX, CX
    SHRQ $8, BX
    ORB BX, CX
    SHRQ $8, BX
    ORB BX, CX
    SHRQ $8, BX
    ORB BX, CX
    SHRQ $8, BX
    ORB BX, CX
    SHRQ $8, BX
    ORB BX, CX
    SHRQ $8, BX
    ORB BX, CX
    SHRQ $8, BX
    ORB BX, CX
    MOVL CX, ret1+24(FP)
    RET

//func openAsm(roundKeys *uint32, tagSize int,dst []byte, nonce []byte, ciphertext []byte, additionalData []byte, temp *byte) ([]byte, int)
////temp: H, J0, TMask, expectedTag, tmp, Counter-256, TMP-256


TEXT ·openAsm(SB), NOSPLIT, $80-148
    //used registers: AX, R10 (not include the function used)
    MOVQ roundKeys+0(FP), Enc
    MOVQ h+112(FP), H
    MOVQ Enc, 0(SP)
    MOVQ H, 8(SP)
    MOVQ H, 16(SP)
    CALL ·cryptoBlockAsm(SB)
    MOVQ 8(SP), H

    //used registers: DX, R9, R12, R11
    MOVQ nonce+40(FP), Nonce
    MOVQ Nonce, 0(SP)
    MOVQ nonceLen+48(FP), Nonce
    MOVQ Nonce, 8(SP)
    MOVQ nonceCap+56(FP), Nonce
    MOVQ Nonce, 16(SP)
    MOVQ temp+112(FP), Tmp
    MOVQ Tmp, J0
    ADDQ $16, J0
    MOVQ J0, 24(SP)
    MOVQ H, 32(SP)
    ADDQ $64, Tmp
    MOVQ Tmp, 40(SP)
    CALL ·calculateFirstCounterAsm(SB)
    MOVQ 24(SP), J0
    MOVQ 40(SP), TMask

    //used registers: R11, AX, R12
    SUBQ $32, TMask
    MOVQ roundKeys+0(FP), Enc
    MOVQ Enc, 0(SP)
    MOVQ TMask, 8(SP)
    MOVQ J0, 16(SP)
    CALL ·cryptoBlockAsm(SB)


    MOVQ h+112(FP), H
    MOVQ H, 0(SP)
    ADDQ $48, H
    MOVQ H, 8(SP)
    MOVQ additionalData+88(FP), AdditionalData
    MOVQ AdditionalData, 16(SP)
    MOVQ additionalDataLen+96(FP), AdditionalData
    MOVQ AdditionalData, 24(SP)
    MOVQ additionalDataCap+104(FP), AdditionalData
    MOVQ AdditionalData, 32(SP)
    MOVQ temp+112(FP), Tmp
    ADDQ $64, Tmp
    MOVQ Tmp, 40(SP)
    CALL ·gHashUpdateAsm(SB)

    //used registers: R15, CX, DI --- R9, DI
    MOVQ cipher+64(FP), Ciphertext
    MOVQ Ciphertext, 16(SP)
    MOVQ cipherLen+72(FP), Ciphertext
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, Ciphertext
    MOVQ Ciphertext, 24(SP)
    MOVQ Ciphertext, 32(SP)
    CALL ·gHashUpdateAsm(SB)
    MOVQ 40(SP), Tmp
    MOVQ 24(SP), Ciphertext

    //used registers: R9, SI, DI
    MOVQ Tmp, 16(SP)
    MOVQ additionalDataLen+96(FP), AdditionalData
    MOVQ AdditionalData, 24(SP)
    MOVQ Ciphertext, 32(SP)
    CALL ·gHashFinishAsm(SB)
    MOVQ 8(SP), Tag

    //used registers: R13
    MOVQ Tag, 0(SP)
    SUBQ $16, Tag
    MOVQ Tag, 16(SP)
    CALL ·xor16(SB)

    //r:=constantTimeCompareAsm(&temp[48],&tag[0],g.tagSize)
    MOVQ cipher+64(FP), Dst
    MOVQ cipherlen+72(FP), Ciphertext
    ADDQ Ciphertext, Dst
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, Dst
    MOVQ Dst, 8(SP)
    MOVQ TagSize, 16(SP)
    CALL ·constantTimeCompareAsm(SB)
    MOVL 24(SP), Res
    MOVL Res, ret4+144(FP)

    //cryptoBlocksAsm(&g.roundKeys[0], out, ciphertext[:len(ciphertext)-g.tagSize], &temp[16], &temp[80], &temp[336])
    //
    MOVQ roundKeys+0(FP), Enc
    MOVQ Enc, 0(SP)
    MOVQ dst+16(FP), Dst
    MOVQ dstLen+24(FP), Tmp
    ADDQ Tmp, Dst
    MOVQ Dst, 8(SP)
    MOVQ dstCap+32(FP), Dst
    SUBQ Tmp, Dst
    MOVQ Dst, 16(SP)
    MOVQ Dst, 24(SP)
    MOVQ cipher+64(FP), Ciphertext
    MOVQ Ciphertext, 32(SP)
    MOVQ cipherLen+72(FP), Ciphertext
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, Ciphertext
    MOVQ Ciphertext, 40(SP)
    MOVQ Ciphertext, 48(SP)
    MOVQ temp+112(FP), Tmp
    ADDQ $16, Tmp
    MOVQ Tmp, 56(SP)
    ADDQ $64, Tmp
    MOVQ Tmp, 64(SP)
    ADDQ $256, Tmp
    MOVQ Tmp, 72(SP)
    CALL ·cryptoBlocksAsm(SB)
    MOVQ 40(SP), Ciphertext

    MOVQ dst+16(FP), Dst
    MOVQ Dst, ret1+120(FP)
    MOVQ dstLen+24(FP), Dst
    ADDQ Ciphertext, Dst
    MOVQ Dst, ret2+128(FP)
    MOVQ Dst, ret3+136(FP)

    RET







