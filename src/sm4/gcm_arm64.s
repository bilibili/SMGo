// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

#include "textflag.h"

#define     Dat     V0
#define     Dat2    V1
#define     Dat3    V2
#define     Dat4    V3

#define     H       V4
#define     Hs      V5
#define     Hpower2 V6
#define     Hp2s    V7
#define     Hpower3 V8
#define     Hp3s    V9
#define     Hpower4 V10
#define     Hp4s    V11

#define     Zero    V12
#define     Reduce  V13 // for reduce from 256 bit to 128 bit over x^128 + x^7 + x^2 + x + 1

#define     T0      V14
#define     T1      V15
#define     T2      V16
#define     T3      V17

#define     Low1    V18
#define     Mid1    V19
#define     High1   V20

#define     Low2    V21
#define     Mid2    V22
#define     High2   V23

#define     Low3    V24
#define     Mid3    V25
#define     High3   V26

#define     Low4    V27
#define     Mid4    V28
#define     High4   V29

#define     Tag     V30

#define     DEBUG   V31

#define mul(Factor, FactorS, Input, Lo, Mid, Hi) \
    VEXT        $8, Input.B16, Input.B16, T0.B16 \
    VEOR        Input.B16, T0.B16, T0.B16 \ // Dat.h ^ Dat.l
    \ //Karatsuba Multiplication
    VPMULL      Input.D1, Factor.D1, Lo.Q1 \ // the low 128 bit
    VPMULL2     Input.D2, Factor.D2, Hi.Q1 \ // the high 128 bit
    VPMULL      T0.D1, FactorS.D1, Mid.Q1 \

#define reduce(Output, Lo, Mid, Hi) \
    \ // merge Middle 128 bits to High & Low
    VEOR        Hi.B16, Lo.B16, T1.B16 \
    VEOR        Mid.B16, T1.B16, Mid.B16 \ // the middle 128 bit
    VEXT        $8, Zero.B16, Mid.B16, T2.B16 \ // ** higher ** 64 bits of middle
    VEXT        $8, Mid.B16, Zero.B16, T3.B16 \ // ** lower ** 64 bit of middle
    VEOR        Hi.B16, T2.B16, Hi.B16 \
    VEOR        Lo.B16, T3.B16, Lo.B16 \
    \ // reduce 256 bit (Lo:Hi) to 128 bit (Lo) over g(x) = 1 + x + x^2 + x^7 + x^128
    \ // for this multiplication: (l:h)*(poly:0) = l*poly ^ (h*poly)>>64
    \ // with poly = 1 + x + x^2 + x^7
    VPMULL      Reduce.D1, Hi.D1, T0.Q1 \ // the low part
    VPMULL2     Reduce.D2, Hi.D2, T1.Q1 \ // the high part
    VEXT        $8, T1.B16, Zero.B16, T2.B16 \
    VEOR        T2.B16, T0.B16, T0.B16 \
    VEOR        T0.B16, Lo.B16, Lo.B16 \
    \ // we then repeat the multiplication for the highest-64 bit part of previous multiplication (upper of h*poly).
    VEXT        $8, Zero.B16, T1.B16, T2.B16 \
    VPMULL      T2.D1, Reduce.D1, T3.Q1 \
    VEOR        T3.B16, Lo.B16, Output.B16 \

//func gHashBlocks(H *byte, tag *byte, data *byte, count int)
TEXT ·gHashBlocks(SB),NOSPLIT,$0-32

	MOVD	    h+0(FP), R10
	MOVD	    tag+8(FP), R11
	MOVD	    data+16(FP), R12
    MOVD        count+24(FP), R13

    VLD1        (R10), [H.B16]
    VLD1        (R11), [Tag.B16]
    VRBIT       H.B16, H.B16
    VRBIT       Tag.B16, Tag.B16

    VEXT        $8, H.B16, H.B16, Hs.B16
    VEOR        H.B16, Hs.B16, Hs.B16 // (Hh^Hl : Hh^Hl)

    VEOR        Zero.B16, Zero.B16, Zero.B16 // clear the content

	MOVD	    $0x87, R9
	VDUP	    R9, Reduce.D2

    CMP         $8, R13 // this could be fine tuned based on benchmark results
    BLT         loopBy1

    // precompute H^2, H^3 & H^4
    mul(H, Hs, H, Low1, Mid1, High1)
    reduce(Hpower2, Low1, Mid1, High1)
    VEXT        $8, Hpower2.B16, Hpower2.B16, Hp2s.B16
    VEOR        Hpower2.B16, Hp2s.B16, Hp2s.B16

    mul(H, Hs, Hpower2, Low1, Mid1, High1)
    reduce(Hpower3, Low1, Mid1, High1)
    VEXT        $8, Hpower3.B16, Hpower3.B16, Hp3s.B16
    VEOR        Hpower3.B16, Hp3s.B16, Hp3s.B16

    mul(H, Hs, Hpower3, Low1, Mid1, High1)
    reduce(Hpower4, Low1, Mid1, High1)
    VEXT        $8, Hpower4.B16, Hpower4.B16, Hp4s.B16
    VEOR        Hpower4.B16, Hp4s.B16, Hp4s.B16

loopBy4:
    VLD1.P      64(R12), [Dat.B16, Dat2.B16, Dat3.B16, Dat4.B16]
    VRBIT       Dat.B16, Dat.B16
    VRBIT       Dat2.B16, Dat2.B16
    VRBIT       Dat3.B16, Dat3.B16
    VRBIT       Dat4.B16, Dat4.B16
    VEOR        Tag.B16, Dat.B16, Dat.B16

    mul(Hpower4, Hp4s, Dat, Low1, Mid1, High1)
    mul(Hpower3, Hp3s, Dat2, Low2, Mid2, High2)
    mul(Hpower2, Hp2s, Dat3, Low3, Mid3, High3)
    mul(H, Hs, Dat4, Low4, Mid4, High4)

    VEOR        Low2.B16, Low3.B16, T0.B16
    VEOR        Mid2.B16, Mid3.B16, T1.B16
    VEOR        High2.B16, High3.B16, T2.B16
    VEOR        Low4.B16, T0.B16, T0.B16
    VEOR        Mid4.B16, T1.B16, T1.B16
    VEOR        High4.B16, T2.B16, T2.B16
    VEOR        T0.B16, Low1.B16, Low1.B16
    VEOR        T1.B16, Mid1.B16, Mid1.B16
    VEOR        T2.B16, High1.B16, High1.B16

    reduce(Tag, Low1, Mid1, High1)

    SUB         $4, R13
    CMP         $3, R13
    BGT         loopBy4

    CMP         $0, R13
    BEQ         blocksEnd

loopBy1:
    VLD1.P      16(R12), [Dat.B16]
    VRBIT       Dat.B16, Dat.B16
    VEOR        Tag.B16, Dat.B16, Dat.B16

    mul(H, Hs, Dat, Low1, Mid1, High1)
    reduce(Tag, Low1, Mid1, High1)

    SUB         $1, R13
    CMP         $0, R13
    BGT         loopBy1

blocksEnd:
    VRBIT       Tag.B16, Tag.B16
    VST1        [Tag.B16], (R11)

    RET

//func xor256(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor256(SB),NOSPLIT,$0-24

	MOVD	dst+0(FP), R10
	MOVD	src1+8(FP), R11
	MOVD	src2+16(FP), R12

	VLD1.P  64(R11), [V0.B16, V1.B16, V2.B16, V3.B16]
	VLD1.P  64(R11), [V8.B16, V9.B16, V10.B16, V11.B16]
	VLD1.P  64(R11), [V16.B16, V17.B16, V18.B16, V19.B16]
	VLD1.P  64(R11), [V24.B16, V25.B16, V26.B16, V27.B16]
	VLD1.P  64(R12), [V4.B16, V5.B16, V6.B16, V7.B16]
	VLD1.P  64(R12), [V12.B16, V13.B16, V14.B16, V15.B16]
	VLD1.P  64(R12), [V20.B16, V21.B16, V22.B16, V23.B16]
	VLD1.P  64(R12), [V28.B16, V29.B16, V30.B16, V31.B16]
	VEOR    V0.B16, V4.B16, V0.B16
	VEOR    V1.B16, V5.B16, V1.B16
	VEOR    V2.B16, V6.B16, V2.B16
	VEOR    V3.B16, V7.B16, V3.B16
	VEOR    V8.B16, V12.B16, V8.B16
	VEOR    V9.B16, V13.B16, V9.B16
	VEOR    V10.B16, V14.B16, V10.B16
	VEOR    V11.B16, V15.B16, V11.B16
	VEOR    V16.B16, V20.B16, V16.B16
	VEOR    V17.B16, V21.B16, V17.B16
	VEOR    V18.B16, V22.B16, V18.B16
	VEOR    V19.B16, V23.B16, V19.B16
	VEOR    V24.B16, V28.B16, V24.B16
	VEOR    V25.B16, V29.B16, V25.B16
	VEOR    V26.B16, V30.B16, V26.B16
	VEOR    V27.B16, V31.B16, V27.B16
	VST1.P  [V0.B16, V1.B16, V2.B16, V3.B16], 64(R10)
	VST1.P  [V8.B16, V9.B16, V10.B16, V11.B16], 64(R10)
	VST1.P  [V16.B16, V17.B16, V18.B16, V19.B16], 64(R10)
	VST1.P  [V24.B16, V25.B16, V26.B16, V27.B16], 64(R10)

    RET

//func xor128(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor128(SB),NOSPLIT,$0-24

	MOVD	dst+0(FP), R10
	MOVD	src1+8(FP), R11
	MOVD	src2+16(FP), R12

	VLD1.P  64(R11), [V0.B16, V1.B16, V2.B16, V3.B16]
	VLD1.P  64(R11), [V8.B16, V9.B16, V10.B16, V11.B16]
	VLD1.P  64(R12), [V4.B16, V5.B16, V6.B16, V7.B16]
	VLD1.P  64(R12), [V12.B16, V13.B16, V14.B16, V15.B16]
	VEOR    V0.B16, V4.B16, V0.B16
	VEOR    V1.B16, V5.B16, V1.B16
	VEOR    V2.B16, V6.B16, V2.B16
	VEOR    V3.B16, V7.B16, V3.B16
	VEOR    V8.B16, V12.B16, V8.B16
	VEOR    V9.B16, V13.B16, V9.B16
	VEOR    V10.B16, V14.B16, V10.B16
	VEOR    V11.B16, V15.B16, V11.B16
	VST1.P  [V0.B16, V1.B16, V2.B16, V3.B16], 64(R10)
	VST1.P  [V8.B16, V9.B16, V10.B16, V11.B16], 64(R10)

    RET

//func xor64(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor64(SB),NOSPLIT,$0-24

	MOVD	dst+0(FP), R10
	MOVD	src1+8(FP), R11
	MOVD	src2+16(FP), R12

	VLD1    (R11), [V0.B16, V1.B16, V2.B16, V3.B16]
	VLD1    (R12), [V4.B16, V5.B16, V6.B16, V7.B16]
	VEOR    V0.B16, V4.B16, V0.B16
	VEOR    V1.B16, V5.B16, V1.B16
	VEOR    V2.B16, V6.B16, V2.B16
	VEOR    V3.B16, V7.B16, V3.B16
	VST1    [V0.B16, V1.B16, V2.B16, V3.B16], (R10)

    RET

//func xor32(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor32(SB),NOSPLIT,$0-24

	MOVD	dst+0(FP), R10
	MOVD	src1+8(FP), R11
	MOVD	src2+16(FP), R12

	VLD1    (R11), [V0.B16, V1.B16]
	VLD1    (R12), [V2.B16, V3.B16]
	VEOR    V0.B16, V2.B16, V0.B16
	VEOR    V1.B16, V3.B16, V1.B16
	VST1    [V0.B16, V1.B16], (R10)

    RET

//func xor16(dst *byte, src1 *byte, src2 *byte)
TEXT ·xor16(SB),NOSPLIT,$0-24

	MOVD	dst+0(FP), R10
	MOVD	src1+8(FP), R11
	MOVD	src2+16(FP), R12

	VLD1    (R11), [V0.B16]
	VLD1    (R12), [V1.B16]
	VEOR    V0.B16, V1.B16, V0.B16
	VST1    [V0.B16], (R10)

    RET
