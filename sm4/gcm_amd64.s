#include "textflag.h"

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

DATA GCM_POLY<>+0x00(SB)/8, $0x0000000000000087
DATA GCM_POLY<>+0x08(SB)/8, $0x0000000000000000
GLOBL GCM_POLY<>(SB), (NOPTR+RODATA), $16

// pre- and post-inverse affine matrix
DATA PreAffineMatrix<>+0x00(SB)/8, $0x4c287db91a22505d
GLOBL PreAffineMatrix<>(SB), (NOPTR+RODATA), $8
DATA PostAffineMatrix<>+0x00(SB)/8, $0xf3ab34a974a6b589
GLOBL PostAffineMatrix<>(SB), (NOPTR+RODATA), $8

DATA Counter_Constant1<>+0x00(SB)/8, $0x0000000000000000
DATA Counter_Constant1<>+0x08(SB)/8, $0x0000000100000000
DATA Counter_Constant1<>+0x10(SB)/8, $0x0000000000000000
DATA Counter_Constant1<>+0x18(SB)/8, $0x0000000200000000
DATA Counter_Constant1<>+0x20(SB)/8, $0x0000000000000000
DATA Counter_Constant1<>+0x28(SB)/8, $0x0000000300000000
DATA Counter_Constant1<>+0x30(SB)/8, $0x0000000000000000
DATA Counter_Constant1<>+0x38(SB)/8, $0x0000000400000000
GLOBL Counter_Constant1<>(SB), (NOPTR+RODATA), $64

DATA Counter_Constant2<>+0x00(SB)/8, $0x0000000000000000
DATA Counter_Constant2<>+0x08(SB)/8, $0x0000000400000000
DATA Counter_Constant2<>+0x10(SB)/8, $0x0000000000000000
DATA Counter_Constant2<>+0x18(SB)/8, $0x0000000400000000
DATA Counter_Constant2<>+0x20(SB)/8, $0x0000000000000000
DATA Counter_Constant2<>+0x28(SB)/8, $0x0000000400000000
DATA Counter_Constant2<>+0x30(SB)/8, $0x0000000000000000
DATA Counter_Constant2<>+0x38(SB)/8, $0x0000000400000000
GLOBL Counter_Constant2<>(SB), (NOPTR+RODATA), $64

DATA Counter_Constant3<>+0x00(SB)/8, $0x0000000000000000
DATA Counter_Constant3<>+0x08(SB)/8, $0x0000000200000000
DATA Counter_Constant3<>+0x10(SB)/8, $0x0000000000000000
DATA Counter_Constant3<>+0x18(SB)/8, $0x0000000200000000
DATA Counter_Constant3<>+0x20(SB)/8, $0x0000000000000000
DATA Counter_Constant3<>+0x28(SB)/8, $0x0000000200000000
DATA Counter_Constant3<>+0x30(SB)/8, $0x0000000000000000
DATA Counter_Constant3<>+0x38(SB)/8, $0x0000000200000000
GLOBL Counter_Constant3<>(SB), (NOPTR+RODATA), $64

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

// pre- and post-inverse affine constant
#define PreAffineConstant 0b00111110
#define PostAffineConstant 0b11010011

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

//****add by later***//
#define T6z Z18

#define VxJ0 X12
#define VxTMask X13

#define VxConst1 X19
#define VxConst2 X10
#define VxConst3 X11

#define VyJ0 Y12
#define VyConst1 Y19
#define VyConst2 Y10
#define VyConst3 Y11

#define VzJ0 Z12
#define VzTMask Z13

#define VzConst1 Z19
#define VzConst2 Z10
#define VzConst3 Z11    //change later, VzConst1, VzConst2, VzConst3 should not use so many registers
//****add by later***//

// X/Y/Z 16  pre-inverse affine matrix
//**********change no conflict with VzAndMask, VzLowMask, VzHighMask  ****************
#define VxPreMatrix X14
#define VyPreMatrix Y14
#define VzPreMatrix Z14

// X/Y/Z 17  post-inverse affine matrix
#define VxPostMatrix X15
#define VyPostMatrix Y15
#define VzPostMatrix Z15
//***********************//

// X/Y/Z 18~20 Src, Interim, Dst for affine instructions
//*******************change VxSrc,VxInterim, VxDst from X18-X20 to be as the following
#define VxSrc       X4
#define VxInterim   X0
#define VxDst       X5

#define VySrc       Y4
#define VyInterim   Y0
#define VyDst       Y5

#define VzSrc       Z4
#define VzInterim   Z0
#define VzDst       Z5
//*****************************

// X/Y/Z 21~24 for states
//**** has changed ****//
#define VxState1    X6
#define VxState2    X7
#define VxState3    X8
#define VxState4    X9

#define VyState1    Y6
#define VyState2    Y7
#define VyState3    Y8
#define VyState4    Y9

#define VzState1    Z6
#define VzState2    Z7
#define VzState3    Z8
#define VzState4    Z9
//**** has changed ****//

// X/Y/Z 25 for round key
#define VxRoundKey  X25
#define VyRoundKey  Y25
#define VzRoundKey  Z25

// X/Y/X 26 for byte order shuffle
#define VxShuffle   X31
#define VyShuffle   Y31
#define VzShuffle   Z31

// Register allocation

// R8~15: general purpose drafts
// AX, BX, CX, DX: parameters

#define MASK_Mov0_1   K1
#define MASK_Mov01_23 K2

// X/Y/Z 0~6 draft registers

#define U1x X4
#define U2x X5

#define U1y Y4
#define U2y Y5

#define U1z Z4
#define U2z Z5

#define VyIdxH01     Y0
#define VzIdxH23     Z1

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

#define VxNonce      X20
#define VxAData      X20
#define VxDat        X20
#define VxH          X21
#define VxHs         X22

#define VyH          Y21

#define VzNonce      Z20
#define VzAData      Z20
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
/////////////////////////////////////////////
//func putUint64(b *byte, v uint64)  --- used registers: None
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

#define needExpandAsm(arrayLen, arrayCap, asked, res, temp1, temp2) \
    MOVQ arrayCap, temp1     \
    SUBQ arrayLen, temp1     \
    MOVQ $0, temp2           \
    CMPQ temp1, asked         \
    JGE 2(PC)                \
    MOVQ $1, temp2           \
    MOVQ temp2, res          \

#define loadShuffle512(reg) \
    MOVQ                $Shuffle<>(SB), reg \
    VBROADCASTI32X4     (reg), VzShuffle \ // AVX512F, latency 8? CPI 0.5

#define loadShuffle256(reg) \
    MOVQ                $Shuffle<>(SB), reg \
    VBROADCASTI32X4     (reg), VyShuffle \ // AVX512F, latency 8? CPI 0.5

#define loadShuffle128(reg) \
    MOVQ        $Shuffle<>(SB), reg \
    VMOVDQU32   (reg), VxShuffle \

#define storeOutputX8(V1, V2, V3, V4, Dst) \
        VMOVDQU32   V1, (Dst) \ //AVX, latency 5, CPI 1
        VMOVDQU32   V2, (32)(Dst) \
        VMOVDQU32   V3, (64)(Dst) \
        VMOVDQU32   V4, (96)(Dst) \


#define loadInputX16(Src, V1, V2, V3, V4) \ // FIXME: little endian
    VMOVDQU32   (Src), V1 \ //AVX512F, latency 8, CPI 0.5 -- we should delay the transpose operations
    VMOVDQU32   (64)(Src), V2 \
    VMOVDQU32   (128)(Src), V3 \
    VMOVDQU32   (192)(Src), V4 \

#define loadInputX8(Src, V1, V2, V3, V4) \
    VMOVDQU32   (Src), V1 \ //AVX, latency 7, CPI 0.5
    VMOVDQU32   (32)(Src), V2 \ // we should perform transpose later
    VMOVDQU32   (64)(Src), V3 \
    VMOVDQU32   (96)(Src), V4 \

#define loadInputX4(Src, V1, V2, V3, V4) \
    VMOVDQU32   (Src), V1 \
    VMOVDQU32   (16)(Src), V2 \
    VMOVDQU32   (32)(Src), V3 \
    VMOVDQU32   (48)(Src), V4 \

#define loadInputX2(Src, V1, V2) \ // we should perform transpose/rev later
    VMOVDQU32   (Src), V1 \
    VMOVDQU32   (16)(Src), V2 \

#define loadInputX1(Src, V1) \ // we should perform transpose/rev later
    VMOVDQU32   (Src), V1 \
    
#define loadJ0(Src, V1) \
    VMOVDQU32   (Src), V1 \
    \//rev32(VxShuffle, V1)  \    //maybe here can improve the performance by use the following second method
    \//reverseBits(V1, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

#define loadNonceX4(Src, V1) \
    VMOVDQU32   (Src), V1 \
    ADDQ $64, Src \
    reverseBits(V1, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \

#define loadNonceX1(Src, V1) \
    VMOVDQU32   (Src), V1 \
    ADDQ $16, Src \
    reverseBits(V1, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

#define loadADataX4(Src, V1) \
    VMOVDQU32   (Src), V1 \
    ADDQ $64, Src \
    reverseBits(V1, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \

#define loadADataX1(Src, V1) \
    VMOVDQU32   (Src), V1 \
    ADDQ $16, Src \
    reverseBits(V1, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

#define loadTmp(Src, V1) \
    VMOVDQU32   (Src), V1 \
    reverseBits(V1, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

#define loadMatrix(Pre, Post, reg1, reg2) \
    MOVQ    $PreAffineMatrix<>(SB), reg1 \
    MOVQ    $PostAffineMatrix<>(SB), reg2 \
    VBROADCASTI32X2     (reg1), Pre \ // latency is 3 for 256/512, 1 otherwise; CPI 1
    VBROADCASTI32X2     (reg2), Post \ // 128/256: AVX512DQ+AVX512VL; 512: AVX512DQ

#define rev32(Const, R) \
    VPSHUFB     Const, R, R \ // AVX512F(512) or SSE2(128) or AVX2(256), latency 1, CPI 0.5(256)/1(128;512)

#define revStates(Const, S1, S2, S3, S4) \
    rev32(Const, S1) \
    rev32(Const, S2) \
    rev32(Const, S3) \
    rev32(Const, S4) \

#define storeOutputX16(V1, V2, V3, V4, Dst) \ // FIXME: little endian
    VMOVDQU32   V1, (Dst) \ //AVX512F, latency 5, CPI 1
    VMOVDQU32   V2, (64)(Dst) \
    VMOVDQU32   V3, (128)(Dst) \
    VMOVDQU32   V4, (192)(Dst) \

#define storeOutputX4(V1, V2, V3, V4, Dst) \
        VMOVDQU32   V1, (Dst) \ //SSE2, latency 5, CPI 1
        VMOVDQU32   V2, (16)(Dst) \
        VMOVDQU32   V3, (32)(Dst) \
        VMOVDQU32   V4, (48)(Dst) \

#define storeOutputX2(V1, V2, Dst) \
        VMOVDQU32   V1, (Dst) \ //SSE2, latency 5, CPI 1
        VMOVDQU32   V2, (16)(Dst) \

#define storeOutputX1(V1, Dst) \
        VMOVDQU32   V1, (Dst) \

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

#define xor256(src,dst, V11, V12, V13, V14, V21, V22, V23, V24)    \
    VMOVDQU32   (src), V21        \
    VMOVDQU32   64(src), V22       \
    VMOVDQU32   128(src), V23      \
    VMOVDQU32   192(src), V24     \
    VPXORD      V11, V21, V11      \
    VPXORD      V12, V22, V12      \
    VPXORD      V13, V23, V13       \
    VPXORD      V14, V24, V14       \
    VMOVDQU32   V11, (dst)          \
    VMOVDQU32   V12, 64(dst)        \
    VMOVDQU32   V13, 128(dst)       \
    VMOVDQU32   V14, 192(dst)       \


//func xor128(dst *byte, src1 *byte, src2 *byte)
#define xor128(dst,src,Vy1,Vy2,Vy3,Vy4) \
    VMOVDQU32   (src),   Y1      \
    VMOVDQU32   32(src), Y2      \
    VMOVDQU32   64(src), Y3      \
    VMOVDQU32   96(src), Y4      \
    VPXORD      Y1, Vy1, Vy1     \
    VPXORD      Y2, Vy2, Vy2     \
    VPXORD      Y3, Vy3, Vy3     \
    VPXORD      Y4, Vy4, Vy4     \
    VMOVDQU32   Vy1,    (dst)    \
    VMOVDQU32   Vy2,  32(dst)    \
    VMOVDQU32   Vy3,  64(dst)    \
    VMOVDQU32   Vy4,  96(dst)    \

#define xor64(dst, src, Vx1, Vx2, Vx3, Vx4) \
    VMOVDQU32   (src),   X1      \
    VMOVDQU32   16(src), X2      \
    VMOVDQU32   32(src), X3      \
    VMOVDQU32   48(src), X4      \
    VPXORD      X1, Vx1, Vx1     \
    VPXORD      X2, Vx2, Vx2     \
    VPXORD      X3, Vx3, Vx3     \
    VPXORD      X4, Vx4, Vx4     \
    VMOVDQU32   Vx1,    (dst)    \
    VMOVDQU32   Vx2,  16(dst)    \
    VMOVDQU32   Vx3,  32(dst)    \
    VMOVDQU32   Vx4,  48(dst)    \

//func xor32(dst *byte, src1 *byte, src2 *byte)
#define xor32(dst, src, Vx1, Vx2) \
    VMOVDQU32   (src), X1     \
    VMOVDQU32   16(src), X2   \
    VPXORD      X1, Vx1, Vx1  \
    VPXORD      X2, Vx2, Vx2  \
    VMOVDQU32   Vx1, (dst)    \
    VMOVDQU32   Vx2, 16(dst)  \

//func xor16(dst *byte, src1 *byte, src2 *byte)
#define xor16(dst, src, Vx1) \
    VMOVDQU32   (src), X0   \
    VPXORD      X0, Vx1, Vx1  \
    VMOVDQU32   Vx1, (dst)    \

#define movv(V1, V2) \
    VPXORD V2, V2, V2 \
    VPADDD V2, V1, V2 \

#define loadH(V1, V2) \
    VPXORD V2, V2, V2 \
    VPADDD V2, V1, V2 \
    reverseBits(V2, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)

#define loadMasks(tmp1,tmp2,tmp3) \
    MOVQ                $AND_MASK<>(SB), tmp1 \
    MOVQ                $LOWER_MASK<>(SB), tmp2 \
    MOVQ                $HIGHER_MASK<>(SB), tmp3 \
    VBROADCASTI32X4     (tmp1), VzAndMask \ // latency 8, CPI 0.5
    VBROADCASTI32X4     (tmp2), VzLowerMask \
    VBROADCASTI32X4     (tmp3), VzHigherMask \

#define reverseBits(V, And, Higher, Lower, T0, T1) \
    VPSRLW      $4, V, T0 \ //AVX512BW
    VPANDD      V, And, T1 \ // the lower part
    VPANDD      T0, And, T0 \ // the higher part
    VPSHUFB     T1, Higher, T1 \
    VPSHUFB     T0, Lower, T0 \
    VPXORD      T0, T1, V \
    //VPSHUFB     VxBSwapMask, T0, V \

#define transformL(Data, T0, T1, T2, T3) \
    VPROLD    $2,  Data, T0 \ // AVX512F(512)+AVX512VL(128;256), latency 1, CPI 0.5(128;256)/1(512)
    VPROLD    $10, Data, T1 \
    VPROLD    $18, Data, T2 \
    VPROLD    $24, Data, T3 \
    VPXORD    T0, T1, T0 \
    VPXORD    T2, T3, T2 \
    VPXORD    T0, T2, T0 \
    VPXORD    T0, Data, Data \

#define transformLY(Data) \
        transformL(Data, T0y, T1y, T2y, T3y)

#define affine(PreMatrix, PostMatrix, Src, Interim, Dst) \
    VGF2P8AFFINEQB $PreAffineConstant, PreMatrix, Src, Interim \ //GFNI + AVX512VL(128;256) / AVX512F(512)
    VGF2P8AFFINEINVQB $PostAffineConstant, PostMatrix, Interim, Dst \ //latency 3?, CPI 0.5(128;256)/1(512)

#define load4X(data) \
    VMOVDQU32   (data), VzDat \
    ADDQ        $64, data \
    reverseBits(VzDat, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \ 

#define load1X(data) \
    VMOVDQU32   (data), VxDat \
    ADDQ        $16, data \
    reverseBits(VxDat, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

#define loadRoundKey(R, RK) \
    MOVD    (R), X1 \
    ADDQ    $4, R \ //TODO replace by offsets to R
    VPBROADCASTD        X1, RK \ // latency is 3 for 256/512, 1 otherwise; CPI 1

#define loadRoundKeyZ(R) \
    loadRoundKey(R, VzRoundKey) \

#define loadRoundKeyY(R) \
    loadRoundKey(R, VyRoundKey) \

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

#define getXorX(B, C, D, Dst) \
    getXor(B, C, D, Dst, T0x, T1x, VxRoundKey) \

#define getXorY(B, C, D, Dst) \
        getXor(B, C, D, Dst, T0y, T1y, VyRoundKey) \

#define getXor(B, C, D, Dst, T0, T1, RK) \
    VPXORD  B, C, T0 \ // AVX512F+AVX512VL, latency 1, CPI 0.33(128;256)/0.5(512)
    VPXORD  D, T0, T1 \
    VPXORD  RK, T1, Dst \ // loading round key (running prior to this) costs some latency so move it last

#define transformLX(Data) \
    transformL(Data, T0x, T1x, T2x, T3x)

#define subRoundX(A, B, C, D) \
    getXorX(B, C, D, VxSrc) \
    affine(VxPreMatrix, VxPostMatrix, VxSrc, VxInterim, VxDst) \
    transformLX(VxDst) \
    VPXORD  VxDst, A, A \

#define loadRoundKeyX(R) \
    loadRoundKey(R, VxRoundKey) \

#define roundX(R) \
    loadRoundKeyX(R) \
    subRoundX(VxState1, VxState2, VxState3, VxState4) \
    loadRoundKeyX(R) \
    subRoundX(VxState2, VxState3, VxState4, VxState1) \
    loadRoundKeyX(R) \
    subRoundX(VxState3, VxState4, VxState1, VxState2) \
    loadRoundKeyX(R) \
    subRoundX(VxState4, VxState1, VxState2, VxState3) \

//gHash consider h and tag in Vx register by default
//required Vx Registers later: VzReduce, VxH, VxTag, VxAndMask, VxHigherMask, VxLowerMask, VxHs
#define gHashBlocksPre(reg1, reg2, reg3) \
	\//loadMasks(reg1, reg2, reg3)    \      //change later, loadMasks only once enough
	MOVQ	            $GCM_POLY<>(SB), reg3  \
	VBROADCASTI32X2     (reg3), VzReduce     \  // latency 3, CPI 1
	\//reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x) \ //change later
	VPSRLDQ     $8, VxH, VxHs      \
	VPXORD      VxH, VxHs, VxHs    \  //h^l in lower Hs


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

//used Vx: VzIdx, VyIdxH01, VzIdxH23, MASK_Mov0_1, MASK_Mov01_23, VxH, VxHs, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x
//U2y, VyH4, VyH, U1y U1z, VzH4, VzH4s,
#define gHashBlocksLoopBy4Pre(reg)  \
    MOVQ        $SHUFFLE_X_LANES<>(SB), reg  \
    VMOVDQU32   (reg), VzIdx   \
    MOVQ        $0b00001100, reg  \
    KMOVW       reg, MASK_Mov0_1   \
    MOVQ        $0b11110000, reg  \
    KMOVW       reg, MASK_Mov01_23  \
	mul(VxH, VxHs, VxH, VxLow, VxMid, VxHigh, T0x)   \
	reduce(U1x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)  \
	mul(VxH, VxHs, U1x, VxLow, VxMid, VxHigh, T0x)    \
	reduce(U2x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)  \
	mul(VxH, VxHs, U2x, VxLow, VxMid, VxHigh, T0x)   \
	reduce(VxH4, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)  \
	MOVQ        $MERGE_H01<>(SB), reg  \
    VMOVDQU32   (reg), VyIdxH01  \
    MOVQ        $MERGE_H23<>(SB), reg  \
    VMOVDQU32   (reg), VzIdxH23  \
	VPERMQ      U2y, VyIdxH01, MASK_Mov0_1, VyH4   \
	VPERMQ      VyH, VyIdxH01, MASK_Mov0_1, U1y    \
	VPERMQ      U1z, VzIdxH23, MASK_Mov01_23, VzH4 \
	VPSRLDQ     $8, VzH4, VzH4s     \
	VPXORD      VzH4, VzH4s, VzH4s  \ //h^l in lower Hs

#define gHashBlocksLoopBy4(count,data) \
    \//load4X(data)         \
	VPXORD     VzTag, data, data  \
	mul(VzH4, VzH4s, data, VzLow, VzMid, VzHigh, T0z)  \
	reduce(VzTag, VzReduce, VzLow, VzMid, VzHigh, T0z, T1z, T2z, T3z)  \
	VPERMQ      $0b01001110, VzTag, T0z   \ // begin with 0:1:2:3, then exchange 0 vs 1, 2 vs 3 of the 4 128 bit lanes. latency 3, CPI 1
	VPXORD      VzTag, T0z, T0z     \ // we have T0z: 0^1 : 0^1 : 2^3 : 2^3
	VPERMQ      T0z, VzIdx, T1z     \ // we have T1z: 2^3 : 0^1 : 2^3 : 2^3
	VPXORD      T0x, T1x, VxTag     \ // VzTag: 0^1^2^3 : 0: 0: 0 (the higher lanes are cleared automatically - X version has lower CPI)
	SUBQ        $4, count           \

#define gHashBlocksLoopBy1(count,data) \
    \//load1X(data)   \
	VPXORD     VxTag, data, data  \
	mul(VxH, VxHs, data, VxLow, VxMid, VxHigh, T0x)  \
	reduce(VxTag, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)   \
	SUBQ        $1, count   \

#define gHashBlocksBlocksEnd(tag) \
    \//MOVQ tmp2, count         \
	\//MOVQ tmp1, data           \
	VPXORD      VxTag, VxTMask, VxTag   \
	reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  \
	VMOVDQU32   VxTag, (tag)   \

#define reverseBitsZ4(Vz1, Vz2, Vz3, Vz4) \
    reverseBits(Vz1, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz2, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz3, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \

#define cryptoBlockAsmX16Macro(rk,dst, src, reg)  \
    \//loadShuffle512() \
    \//loadInputX16(src, VzState1, VzState2, VzState3, VzState4)  \ // latency: 8  put forward
    \//loadMatrix(VzPreMatrix, VzPostMatrix) \
    \//revStates(VzShuffle, VzState1, VzState2, VzState3, VzState4)  \ // latency hiden successfully rev is not needed, as VzState1-4 is already in Vz
    transpose4x4(VzState1, VzState2, VzState3, VzState4, T0z, T1z) \
    roundZ(rk) \
    roundZ(rk) \
    roundZ(rk) \
    roundZ(rk) \
    roundZ(rk) \
    roundZ(rk) \
    roundZ(rk) \
    roundZ(rk) \
    SUBQ $128, rk \
    transpose4x4(VzState4, VzState3, VzState2, VzState1, T0z, T1z) \
    revStates(VzShuffle, VzState1, VzState2, VzState3, VzState4)   \
    xor256(src,dst, VzState4, VzState3, VzState2, VzState1, T0z, T1z, T2z, T3z) \
    MOVQ $16, reg  \
    \//seal: input is VzState1 to VzState4, open: input load ciphertext to VzState1 to VzState2 first
    reverseBitsZ4(VzState4, VzState3, VzState2, VzState1) \
    gHashBlocksLoopBy4(reg,VzState4) \
    gHashBlocksLoopBy4(reg,VzState3) \
    gHashBlocksLoopBy4(reg,VzState2) \
    gHashBlocksLoopBy4(reg,VzState1) \

//for 512-bit lanes,
//Suppose we have V1z=(a0, a1, -, -), and V2z=(b0,b1,-,-), we want to have V=(a0, a1, b0, b1)
#define concatenateY(V1y,V2y,V1z) \
    VMOVDQA64 V1y, T2y        \           //T2z = (a0, a1, 0, 0)
    VMOVDQA64 V2y, T3y         \     //T3z = (b0, b1, 0,0)
    VALIGND $8, T2z, T3z, T3z \  //T3z = (0,0, b0 b1)
    VPADDD T2z, T3z, V1z      \    //V1z = (a0, a1, b0, b1)


#define cryptoBlockAsmX8Macro(rk, dst, src, reg) \
    \//loadShuffle256()  \
    \//loadInputX8(src, VyState1, VyState2, VyState3, VyState4)  \
    \//loadMatrix(VyPreMatrix, VyPostMatrix)  \
    \//revStates(VyShuffle, VyState1, VyState2, VyState3, VyState4)  \// latency hiden successfully
    transpose4x4(VyState1, VyState2, VyState3, VyState4, T0y, T1y)  \
    roundY(rk)  \
    roundY(rk)  \
    roundY(rk)  \
    roundY(rk)  \
    roundY(rk)  \
    roundY(rk)  \
    roundY(rk)  \
    roundY(rk)  \
    SUBQ $128, rk \
    transpose4x4(VyState4, VyState3, VyState2, VyState1, T0y, T1y) \
    revStates(VyShuffle, VyState1, VyState2, VyState3, VyState4)  \
    xor128(dst,src,VyState4,VyState3,VyState2,VyState1) \
    MOVQ $8, reg  \
    concatenateY(VyState4, VyState3, VzState4)  \
    reverseBits(VzState4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    gHashBlocksLoopBy4(reg,VzState4) \
    concatenateY(VyState2, VyState1, VzState2)  \
    reverseBits(VzState2, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    gHashBlocksLoopBy4(reg,VzState2) \ //truncate VySt

#define cryptoBlockAsmX4Macro(rk, dst, src, reg)  \
    \//loadShuffle128()  \
    \//loadInputX4(src, VxState1, VxState2, VxState3, VxState4)  \
    \//loadMatrix(VxPreMatrix, VxPostMatrix)  \
    \//revStates(VxShuffle, VxState1, VxState2, VxState3, VxState4)  \ // latency hiden successfully
    transpose4x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    SUBQ $128, rk  \
    transpose4x4(VxState4, VxState3, VxState2, VxState1, T0x, T1x)  \
    revStates(VxShuffle, VxState1, VxState2, VxState3, VxState4)    \
    xor64(dst, src, VxState4, VxState3, VxState2, VxState1)         \
    MOVQ $4, reg \
    concatenateX(VxState4, VxState3,VxState2, VxState1,VzState4)  \   //the order, need judge
    reverseBits(VzState4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    gHashBlocksLoopBy4(reg,VzState4) \ //truncate VySt

#define cryptoBlockAsmX2Macro(rk,dst, src, reg) \
    \//loadShuffle128()   \
    \//loadInputX2(src, VxState1, VxState2)   \
    \//loadMatrix(VxPreMatrix, VxPostMatrix)  \
    \//rev32(VxShuffle, VxState1)   \ // latency hiden successfully
    \//rev32(VxShuffle, VxState2)   \
    transpose2x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundX(rk)   \
    roundX(rk)   \
    roundX(rk)   \
    roundX(rk)   \
    roundX(rk)   \
    roundX(rk)   \
    roundX(rk)   \
    roundX(rk)   \
    SUBQ $128, rk \
    transpose4x2(VxState4, VxState3, VxState2, VxState1, T0x, T1x)   \
    rev32(VxShuffle, VxState4)  \
    rev32(VxShuffle, VxState3)  \
    xor32(dst, src, VxState4, VxState3)   \
    MOVQ $2, reg \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg,VxState4) \
    reverseBits(VxState3, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg,VxState3) \

#define cryptoBlockAsmX1Macro(rk,dst,src,reg)    \
    \//loadShuffle128()   \
    \//loadInputX1(src, VxState1)  \
    \//loadMatrix(VxPreMatrix, VxPostMatrix)  \
    \//rev32(VxShuffle, VxState1)   \ // latency hiden successfully  how to avoid rev32 for state1, J1,J2, Jn rev32 -> rev
    transpose1x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    SUBQ $128, rk \
    transpose4x1(VxState4, VxState3, VxState2, VxState1, T0x, T1x) \
    rev32(VxShuffle, VxState4)  \
    xor16(dst, src, VxState4) \
    MOVQ $1, reg \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg,VxState4) \

#define cryptoBlockAsmRemain(rk,dst,src,reg)    \
    \//loadShuffle128()   \
    \//loadInputX1(src, VxState1)  \
    \//loadMatrix(VxPreMatrix, VxPostMatrix)  \
    \//rev32(VxShuffle, VxState1)   \ // latency hiden successfully  how to avoid rev32 for state1, J1,J2, Jn rev32 -> rev
    transpose1x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    SUBQ $128, rk \
    transpose4x1(VxState4, VxState3, VxState2, VxState1, T0x, T1x) \
    rev32(VxShuffle, VxState4)  \
    xor16(dst, src, VxState4) \
    \//MOVQ $1, reg \
    \//reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    \//gHashBlocksLoopBy1(reg,VxState4) \

#define cryptoPrepare(reg1, reg2, reg3) \
    loadMasks(reg1, reg2, reg3) \
    loadShuffle512(reg1) \
    loadMatrix(VzPreMatrix, VzPostMatrix, reg1, reg2) \

#define loadCounterConstant(reg1, reg2, reg3)   \
    MOVQ        $Counter_Constant1<>(SB), reg1  \
    MOVQ        $Counter_Constant2<>(SB), reg2  \
    MOVQ        $Counter_Constant3<>(SB), reg3  \
    VMOVDQU32   (reg1), VzConst1   \ //VzConst1:(1,2,3,4)
    VMOVDQU32   (reg2), VzConst2   \ //VzConst2: (4,4,4,4)
    VMOVDQU32   (reg3), VzConst3   \ //VzConst3: (2,2,2,2)

#define cryptoBlocksPrepare(reg1, reg2, reg3) \
    gHashBlocksPre(reg1, reg2, reg3) \
    loadCounterConstant(reg1, reg2, reg3) \
    broadcastJ0() \  //VzJ0 = (VxJ0, VxJ0, VxJ0, VxJ0) and VxJ0 is in reverse order

#define cryptoBlocksEnd(tag) \
    gHashBlocksBlocksEnd(tag) \


//func fillSingleBlockAsm(dst *byte, src *byte, count uint32)  --- used registers: DI, SI,AX
#define fillSingleBlockAsm(dst, src, count, temp) \
    copy12(dst, src, temp) \
    ADDQ $12, dst          \
    MOVQ count, temp       \
    putUint32(dst, temp)  \
    ADDQ $4, dst          \


#define setZero(V1) \
    VPXORD V1, V1, V1 \

#define xorAsm(dst,src1,src2,len) \
    loop:                 \
        CMPQ len, $0      \
        JLE end           \
        SUBQ $1, len      \
        MOVB (src1), SIB  \
        MOVB (src2), DIB  \
        XORB DIB, SIB     \
        MOVB SIB, (dst)   \
        ADDQ $1, src1     \
        ADDQ $1, src2     \
        ADDQ $1, dst      \
        JMP loop          \
    end:                  \
        NOP               \

#define clearRight(dst,len,reg1,reg2) \
    MOVQ dst, reg2 \
    ADDQ len, reg2 \
    MOVQ $16, reg1 \
    SUBQ len, reg1 \
loop:             \
    CMPQ reg1, $0 \
    JLE end       \
    MOVB $0, (reg2) \
    ADDQ $1, reg2   \
    SUBQ $1, reg1  \
    JMP loop       \
end:               \
    NOP            \

//func clearRight(dst *byte, len int)
TEXT ·clearRight(SB),NOSPLIT,$0-16
    MOVQ d+0(FP), AX
    MOVQ len+8(FP), BX
    clearRight(AX,BX,CX, DX)
    RET

//cryptoBlocksAsm(roundKeys *uint32, out []byte, in []byte, preCounter *byte, counter *byte, tmp *byte) --- used registers: R8-R15, SI,DI,AX-DX  something happend between uint and int,need check again
#define cryptoBlocksAsm(rk,dst,src,len,tmp,blockCount,reg1,reg2,reg3) \    //tmp include counter and tmp
    MOVL $0, blockCount \
    cryptoBlocksPrepare(reg1,reg2,reg3)   \  //now suppose const1,2,3 has in the right place
    CMPQ len, $64    \
    JL loopX2        \
    gHashBlocksLoopBy4Pre(reg1)  \
loopX16:   \
    CMPQ len, $256  \
    JL loopX8   \
    fillCounterX16()   \
    \//loadInputX16(tmp, VzState1, VzState2, VzState3, VzState4)  \
    cryptoBlockAsmX16Macro(rk,dst,src, reg1)   \
    \//xor256(dst,dst,src)
    ADDQ $256, dst   \
    ADDQ $256, src   \
    ADDQ $16, blockCount  \  //blockCount can be deleted
    SUBQ $256, len   \
    JMP loopX16   \
loopX8:   \
    CMPQ len, $128   \
    JL loopX4   \
    fillCounterX8()  \
    cryptoBlockAsmX8Macro(rk, dst, src, reg1)  \
    ADDQ $128, dst   \
    ADDQ $128, src   \
    ADDQ $8, blockCount  \
    SUBQ $128, len   \
    JMP loopX8   \
loopX4:   \
    CMPQ len, $64  \
    JL loopX2  \
    fillCounterX4()   \
    cryptoBlockAsmX4Macro(rk, dst, src, reg1)   \
    ADDQ $64, dst   \
    ADDQ $64, src   \
    ADDQ $4, blockCount  \
    SUBQ $64, len  \
    JMP loopX4    \
loopX2:    \
    CMPQ len, $32   \
    JL loopX1    \
    fillCounterX2()   \
    cryptoBlockAsmX2Macro(rk, dst, src, reg1)   \
    ADDQ $32, dst   \
    ADDQ $32, src   \
    ADDQ $2, blockCount   \
    SUBQ $32, len    \
    JMP loopX2     \
loopX1:     \
    CMPQ len, $16  \
    JL loopX0   \
    \//rev32(VxShuffle,VxJ0) \  //for debug here, need to be delete
    \//storeOutputX1(VxConst1, Tmp) \ //for debug here, need to be deleted
    fillCounterX1()   \
    \//rev32(VxShuffle,VxJ0) \  //for debug here, need to be delete
    \//storeOutputX1(VxJ0, Tmp) \ //for debug here, need to be deleted
    cryptoBlockAsmX1Macro(rk, dst,src, reg1)  \
    \//reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x) \  //for debug here
    \//storeOutputX1(VxTag, Tmp) \ //for debug here, need to be deleted
    ADDQ $16, dst   \
    ADDQ $16, src   \
    ADDQ $1, blockCount  \
    SUBQ $16, len    \
    JMP loopX1   \
loopX0:    \
    CMPQ len, $0   \
    JLE cryptoBlocksDone     \
    fillCounterX1()   \
    cryptoBlockAsmRemain(rk,tmp,src,reg3)  \
    clearRight(tmp,len,reg3,reg2) \
    MOVQ len, reg2 \
    copyAsm(dst,tmp,len,reg3)  \
    SUBQ reg2, tmp \
    MOVQ $1, reg3 \
    loadInputX1(tmp, VxState4) \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg3,VxState4) \
cryptoBlocksDone: \
    NOP \


    
//func makeCounter(dst *byte, src *byte) --- used registers: DI, SI, AX
#define makeCounter(dst, src, temp) \
    MOVQ   0(src),     temp    \
    MOVQ   temp,        0(dst) \
    MOVL   8(src),     temp    \
    MOVL   temp,         8(dst) \
    MOVB   $1,        15(dst)   \

#define copyAsm(dst,src,len,tmp)  \
    CMPQ len, $8    \
    JL 7(PC)     \
    MOVQ 0(src), tmp \
    MOVQ tmp, 0(dst) \
    ADDQ $8, src    \
    ADDQ $8, dst    \
    SUBQ $8, len    \
    JMP  -7(PC)      \
    CMPQ len, $4    \
    JL  7(PC)       \
    MOVL 0(src), tmp \
    MOVL tmp, 0(dst) \
    ADDQ $4, src    \
    ADDQ $4, dst    \
    SUBQ $4, len    \
    JMP -7(PC)       \
    CMPQ len, $2    \
    JL  7(PC)       \
    MOVW 0(src), tmp \
    MOVW tmp, 0(dst) \
    ADDQ $2, src    \
    ADDQ $2, dst    \
    SUBQ $2, len    \
    JMP -7(PC)       \
    CMPQ len, $1    \
    JL 7(PC)         \
    MOVB 0(src), tmp \
    MOVB tmp, 0(dst) \
    ADDQ $1, src    \
    ADDQ $1, dst    \
    SUBQ $1, len    \
    JMP -7(PC)       \
    NOP             \

//With it, VxState4 -> VxH
#define cryptoBlockAsmMacro(rk)  \
    \//loadShuffle128()   \
    \//loadInputX1(src, VxState1)  \
    \//loadMatrix(VxPreMatrix, VxPostMatrix)  \
    rev32(VxShuffle, VxState1)   \ // latency hiden successfully   change later, move rev32 to register, save time for zero block
    transpose1x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    roundX(rk)  \
    SUBQ $128, rk \
    transpose4x1(VxState4, VxState3, VxState2, VxState1, T0x, T1x) \
    \//moveToVxH(VxState4)   \ //move VxState4 to VxH
    rev32(VxShuffle, VxState4)  \
    \//storeOutputX1(VxState4, dst)  \

//VxH = VxState4, J0 is put in Vxtag,
#define calculateJ0Branch2(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    MOVQ nonceLen, blockCount \
    MOVQ nonceLen, remain    \
    ANDQ $15, remain     \
    SHRQ $4, blockCount \
    gHashBlocksPre(reg1, reg2, reg3) \
    CMPQ nonceLen, $16  \
    JL last    \
    CMPQ blockCount, $8 \
    JL loopBy1 \
    gHashBlocksLoopBy4Pre(reg1) \
    loopBy4:         \
    loadNonceX4(nonce, VzNonce) \ //load nonce
    gHashBlocksLoopBy4(blockCount, VzNonce) \
    CMPQ        blockCount, $3    \
    JG          loopBy4      \
    CMPQ        blockCount, $0    \
    JE          last    \
    loopBy1:  \
    loadNonceX1(nonce, VxNonce) \ //load nonce
    gHashBlocksLoopBy1(blockCount, VxNonce) \
    CMPQ        blockCount, $0   \
    JG          loopBy1     \
    last:   \
    CMPQ remain, $0    \
    JE doneJ0        \
    MOVQ remain, reg2 \
    MOVQ $0, (tmp)    \
    MOVQ $0, 8(tmp)   \
    copyAsm(tmp,nonce,remain,reg1) \
    SUBQ reg2, tmp \   //recover the tmp address
    loadTmp(tmp, VxNonce) \
    MOVQ $1, blockCount   \
    gHashBlocksLoopBy1(blockCount, VxNonce) \
    doneJ0:   \
    SHLQ $3, nonceLen  \
    MOVQ $0, (tmp) \
    ADDQ $8, tmp   \
    putUint64(tmp,nonceLen)  \
    SUBQ $8, tmp  \
    SHRQ $3, nonceLen    \
    loadTmp(tmp, VxNonce)  \
    MOVQ $1, blockCount  \
    gHashBlocksLoopBy1(blockCount, VxNonce) \
    reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x) \


#define calculateJ0(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    CMPQ nonceLen, $12 \
    JE branch1 \
    calculateJ0Branch2(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    movv(VxTag,VxJ0) \
    \//VMOVDQU32   VxTag, (J0) \
    JMP endJ0 \
branch1: \
    makeCounter(tmp, nonce, remain)   \ //use remain as the temp variable
    loadJ0(tmp, VxJ0) \
endJ0:
    NOP

#define CalculateSPre(aData,aLen, blockCount, remain, tmp, reg1, reg2, reg3) \
    MOVQ aLen, blockCount   \
    MOVQ aLen, remain    \
    ANDQ $15, remain     \
    SHRQ $4, blockCount \
    gHashBlocksPre(reg1, reg2, reg3) \
    CMPQ aLen, $16 \
    JL withRemain \
    CMPQ blockCount, $8  \
    JL loopWith1  \
    gHashBlocksLoopBy4Pre(reg1) \
loopWith4:         \
    loadADataX4(aData, VzAData) \ //load additionalData
    gHashBlocksLoopBy4(blockCount, VzAData) \
    CMPQ        blockCount, $3    \
    JG          loopWith4      \
    CMPQ        blockCount, $0    \
    JE          withRemain    \
loopWith1:  \
    loadADataX1(aData, VxAData) \ //load additionalData
    gHashBlocksLoopBy1(blockCount, VxAData) \
    CMPQ        blockCount, $0   \
    JG          loopWith1     \
withRemain:  \
    CMPQ remain, $0    \
    JE endSPre        \
    MOVQ remain, reg2 \
    MOVQ $0, (tmp) \
    MOVQ $0, 8(tmp) \
    copyAsm(tmp,aData,remain, reg1) \
    SUBQ reg2, tmp \
    loadADataX1(tmp, VxAData) \
    MOVQ $1, blockCount   \
    gHashBlocksLoopBy1(blockCount, VxAData) \
endSPre:
    NOP

#define CalculateSPost(tag, aLen, cLen, tmp, blockCount) \
    SHLQ $3, aLen \
    SHLQ $3, cLen  \
    putUint64(tmp, aLen)  \
    ADDQ $8, tmp   \
    putUint64(tmp, cLen)  \
    SUBQ $8, tmp  \
    loadADataX1(tmp, VxAData) \
    MOVQ $1, blockCount  \
    gHashBlocksLoopBy1(blockCount, VxAData) \
    cryptoBlocksEnd(tag) \

#define loadState1(H) \
    loadInputX1(H, VxState1)
    rev32(VxShuffle, VxState1)


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


#define RK R15
#define TagSize R14
#define Dst R13
#define Nonce R12
#define NonceLen R11
#define BlockCount1 R10
#define Remain1 R9
#define Reg31 R8  //may need change
#define Plaintext R10
#define PlainLen R9
#define Cipher R10
#define CipherLen R9
#define BlockCount3 R12
#define Reg33 R11
#define AData R8
#define ALen DI
#define BlockCount2 R12
#define Remain2 R11
#define Reg32 R13
#define Tmp SI
#define H AX
#define J0 BX
#define Reg1 CX
#define Reg2 DX


TEXT ·needExpand(SB), $0-40
	MOVQ array+0(FP), DI
	MOVQ arrayLen+8(FP), SI
	MOVQ arrayCap+16(FP), AX
	MOVQ asked+24(FP), BX
	needExpandAsm(SI, AX, BX, CX, R8, R9)
	MOVQ CX, ret1+32(FP)
	RET

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

//func gHashBlocks(H *byte, tag *byte, data *byte, count int)
TEXT ·gHashBlocks(SB),NOSPLIT,$0-32
	MOVQ	    h+0(FP), AX
	MOVQ	    tag+8(FP), BX
	MOVQ	    data+16(FP), CX
	MOVQ        count+24(FP), DX

	// carefully hide the latency
	VMOVDQU32   (AX), VxH // latency 7, CPI 0.5
	VMOVDQU32   (BX), VxTag // higher lanes will be cleared automatically

	loadMasks(R8,R9,R10)

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

	MOVQ        $MERGE_H01<>(SB), R8
    MOVQ        $MERGE_H23<>(SB), R9
    VMOVDQU32   (R8), VyIdxH01
    VMOVDQU32   (R9), VzIdxH23

	// we have H^4 : : :  , we should obtain H^4 : H^3 (U2x) : H^2 (U1x) : H (VxH)
	VPERMQ      U2y, VyIdxH01, MASK_Mov0_1, VyH4
	VPERMQ      VyH, VyIdxH01, MASK_Mov0_1, U1y
	VPERMQ      U1z, VzIdxH23, MASK_Mov01_23, VzH4

	VPSRLDQ     $8, VzH4, VzH4s
	VPXORD      VzH4, VzH4s, VzH4s //h^l in lower Hs

	loopBy4:
	load4X(CX)
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
	load1X(CX)

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



//func fillCounterX1(J0 *byte)
TEXT ·fillCounterX1(SB), NOSPLIT, $0-8
    loadCounterConstant(AX, BX, CX)
    MOVQ j0+0(FP), BX
    loadInputX1(BX, VxJ0)
    loadShuffle128(AX)
    rev32(VxShuffle, VxJ0)
    VPADDD VxJ0, VxConst1, VxJ0
    storeOutputX1(VxJ0,BX)
    RET

TEXT ·fillCounterX4(SB), NOSPLIT, $0-8
    loadCounterConstant(AX, BX, CX)
    MOVQ j0+0(FP), BX
    loadInputX1(BX, VzJ0)
    loadShuffle512(AX)
    rev32(VzShuffle, VzJ0)
    VPADDD VzJ0, VzConst1, VzJ0
    storeOutputX1(VzJ0,BX)
    RET

//for 512-bit lanes,
//Suppose we have V1=(a0,0), V2=(b0,0), V3=(c0,0,), V4=(d0,0,)
//we want to have V=(a0,b0,c0,d0)   Y1 correspond to Z1, Y2 -> Z2    consuming time, change it later
#define concatenateX(V1x, V2x, V3x, V4x,V1z) \
    VMOVDQA64 V1x, T0x \
    VMOVDQA64 V2x, T1x \
    VMOVDQA64 V3x, T2x \
    VMOVDQA64 V4x, T3x \
    VALIGND $4, T0y, T1y, T1y \ //T1y = (0, b0)
    VPADDD T0y,T1y,T0y \ //T0y = (a0,b0)
    VALIGND $4,T2y, T3y, T3y \ //T3y=(0,d0)
    VPADDD T2y, T3y, T2y \ //T2y = (c0,d0)
    VALIGND $8,T0z,T2z, T2z \ //T2z = (0,0,c0,d0)
    VPADDD T0z, T2z, V1z  \ //V1z = (a0,b0,c0,d0)

//func concatenateX(X1 *byte, X2 *byte, X3 *byte, X4 *byte)
TEXT ·concatenateX(SB),NOSPLIT,$0-32
    MOVQ x1+0(FP), AX
    loadInputX1(AX, T0x)   //T0z = (a0, -, - -)
    MOVQ x2+8(FP), BX
    loadInputX1(BX, T1x)   //T1z = (b0, -, - -)
    MOVQ x3+16(FP), CX
    loadInputX1(CX, T2x)   //T2z = (c0, -, - -)
    MOVQ x4+24(FP), DX
    loadInputX1(DX, T3x)   //T3z = (d0, -, - -)
    VALIGND $4, T0y, T1y, T1y  //T1y = (0, b0)
    VPADDD T0y,T1y,T0y  //T0y = (a0,b0)
    VALIGND $4,T2y, T3y, T3y  //T3y=(0,d0)
    VPADDD T2y, T3y, T2y  //T2y = (c0,d0)
    VALIGND $8,T0z,T2z, T2z  //T2z = (0,0,c0,d0)
    VPADDD T0z, T2z, T0z   //T0z = (a0,b0,c0,d0)
    storeOutputX1(T0z,AX)
    RET



//func concatenateY(Y1 *byte, Y2 *byte)
TEXT ·concatenateY(SB),NOSPLIT,$0-16
    MOVQ y1+0(FP), AX
    loadInputX1(AX, T0z)   //T0z = (a0, a1, - -)
    MOVQ y2+8(FP), BX
    loadInputX1(BX, T1z)   //T1z = (b0, b1, - -)
    VMOVDQA64 T0y, T2y     //T2z = (a0, a1, 0, 0)
    VMOVDQA64 T1y, T3y     //T3z = (b0, b1, 0,0)
    VALIGND $8, T2z, T3z, T3z   //T3z = (0,0, b0 b1)
    VPADDD T2z, T3z, T2z       //V1 = (a0, a1, b0, b1)
    storeOutputX1(T2z,AX)
    RET

#define broadcastJ0() \  //broadcast VxJ0 to VzJ0
    VMOVDQA64 VxJ0, VxState1 \
    VMOVDQA64 VxJ0, VxState2 \
    VMOVDQA64 VxJ0, VxState3 \
    concatenateX(VxJ0, VxState1, VxState2, VxState3,VzJ0) \
    rev32(VzShuffle, VzJ0)  \  //rev32 only excutes once at the beginning

//func broadcastJ0(j0 *byte)
TEXT ·broadcastJ0(SB), NOSPLIT, $0-8
    MOVQ j0+0(FP), AX
    loadInputX1(AX, VxJ0)
    VMOVDQA64 VxJ0, VxState1
    VMOVDQA64 VxJ0, VxState2
    VMOVDQA64 VxJ0, VxState3
    concatenateX(VxJ0, VxState1, VxState2, VxState3,VzJ0)
    storeOutputX1(VzJ0,AX)
    RET

// after fillCounterX16, VzJ0_new = VzJ0_old + (16,16,16,16)
#define fillCounterX16() \
    VPADDD VzJ0, VzConst1, VzState1 \      // + (1,2,3,4)
    VPADDD VzState1, VzConst2, VzState2 \  // + (4,4,4,4)
    VPADDD VzState2, VzConst2, VzState3 \  // + (4,4,4,4)
    VPADDD VzState3, VzConst2, VzState4 \  // + (4,4,4,4)
    VPADDD VzConst2, VzConst2, T0z      \  // : (8,8,8,8)
    VPADDD T0z, T0z, T1z                \  // : (16,16,16,16)
    VPADDD VzJ0, T1z, VzJ0              \  // : +(16,16,16,16)

//after fillCounterX8, VyJ0_new = VyJ0_old + (8,8)
#define fillCounterX8() \
    VPADDD VyJ0, VyConst1, VyState1 \      // + (1,2)
    VPADDD VyState1, VyConst3, VyState2 \  // + (2,2)
    VPADDD VyState2, VyConst3, VyState3 \  // + (2,2)
    VPADDD VyState3, VyConst3, VyState4 \  // + (2,2)
    VPADDD VyConst3, VyConst3, T0y      \  // : (4,4)
    VPADDD T0y, T0y, T1y                \  // : (8,8)
    VPADDD VyJ0, T1y, VyJ0              \  // : +(8,8)

//after fillCounterX4, VxJ0_new = VxJ0_old + (4)
#define fillCounterX4() \
    VPADDD VxJ0, VxConst1, VxState1 \     // + (1)
    VPADDD VxState1, VxConst1, VxState2 \ // + (1)
    VPADDD VxState2, VxConst1, VxState3 \ // + (1)
    VPADDD VxState3, VxConst1, VxState4 \ // + (1)
    VMOVDQA64 VxState4, VxJ0 \            //: + (4)

//after fillCounterX2, VxJ0_new = VxJ0_old + (2)
#define fillCounterX2() \
    VPADDD VxJ0, VxConst1, VxState1 \      // + (1)
    VPADDD VxState1, VxConst1, VxState2 \  // + (1)
    VMOVDQA64 VxState2, VxJ0 \             // : + (2)

//after fillCounterX1, VxJ0_new = VxJ0_old + (1)
#define fillCounterX1() \
    VPADDD VxJ0, VxConst1, VxState1 \     // + (1)
    VMOVDQA64 VxState1, VxJ0 \            // : + (1)


//func sealAsm(roundKeys *uint32, tagSize int, dst []byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte) []byte
//temp:  H, TMask, J0, tag, counter, tmp, CNT-256, tmp-256
TEXT ·sealAsm(SB), NOSPLIT, $80-152    //change later
    MOVQ tagSize+8(FP), TagSize  //Where tagSize is needed, consider later

    cryptoPrepare(Reg1, Reg2, Reg31)   //Z26, Z16, Z17 is used to load constant
    MOVQ h+112(FP), H
    loadState1(H)

    MOVQ rk+0(FP), RK
    cryptoBlockAsmMacro(RK) //H stored in VxH, keep order
    //movv(VxState4, VxH)
    loadH(VxState4, VxH)

    //storeOutputX1(VxH, H)

    MOVQ nonce+40(FP), Nonce
    MOVQ nonceLen+48(FP), NonceLen
    MOVQ temp+112(FP), Tmp
    ADDQ $80, Tmp
    setZero(VzTag) // change later at last.  here setZero can be deleted
    calculateJ0(Nonce,NonceLen,BlockCount1,Remain1,Tmp,Reg1, Reg2, Reg31)  //J0 store in VxJ0, keep order,  VxH reverse order
    //storeOutputX1(VxJ0, Tmp) //store VxJ0 in Tmp for debug
    //reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  //for debug
    //storeOutputX1(VxH, H)

    movv(VxJ0, VxState1)    // J0 store in VxJ0, keep order -> fillCounter, reverse first (only once), then add number (in reverse order)
    cryptoBlockAsmMacro(RK)
    movv(VxState4, VxTMask) // the cipher of J0 is stored in VxTMask, keep order, no reverse
    //storeOutputX1(VxState4, Tmp)

    //reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  //for debug
    //MOVQ temp+112(FP), Tmp
    //ADDQ $80, Tmp
    //storeOutputX1(VxH, Tmp)

    setZero(VxTag)
    MOVQ aData+88(FP), AData
    MOVQ aLen+96(FP), ALen
    CalculateSPre(AData,ALen, BlockCount2, Remain2, Tmp, Reg1, Reg2, Reg32) //GHash(A||0) is stored in VxTag and is reverseBits, VxH is also reversebits
    //for debug
    //reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
    //reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
    //storeOutputX1(VxTag, Tmp)

    MOVQ dst+16(FP), Dst
    MOVQ plaintext+64(FP), Plaintext
    MOVQ plainLen+72(FP), PlainLen
    cryptoBlocksAsm(RK,Dst,Plaintext,PlainLen,Tmp,BlockCount3,Reg1,Reg2,Reg33)
    MOVQ temp+112(FP), Tmp   //for debug use
    ADDQ $80, Tmp
    //for debug
    //MOVQ        $Counter_Constant<>(SB), Reg1
    //VMOVDQU32   (Reg1), VzConst1
    reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
    storeOutputX1(VxTag, Tmp)
    MOVQ dst+16(FP), Dst
    MOVQ Dst, ret1+120(FP)
    MOVQ plainLen+72(FP), PlainLen
    MOVQ PlainLen, ret2+128(FP)
    MOVQ PlainLen, ret3+136(FP)
    RET



//func constantTimeCompareAsm(x *byte, y *byte, l int) int32. the result is in temp2
#define constantTimeCompare(x,y,l,reg1,reg2,reg3) \
    MOVQ $0, reg1   \
    MOVQ $0, reg2   \
fastCmp:             \
    CMPQ l, $8       \
    JL slowCmp       \
    MOVQ (x), reg3  \
    XORQ reg3, (y)  \
    ORQ (y),reg1    \
    ADDQ $8, x       \
    ADDQ $8, y       \
    SUBQ $8, l       \
    JMP fastCmp      \
slowCmp:             \
    CMPQ l, $1       \
    JL cmpDone          \
    MOVB (x), reg3  \
    XORB reg3, (y)  \
    ORB (y), reg2   \
    ADDQ $1, x       \
    ADDQ $1, y       \
    SUBQ $1, l       \
    JMP slowCmp      \
cmpDone:                \
    ORB reg1, reg2 \
    SHRQ $8, reg1   \
    ORB reg1, reg2 \
    SHRQ $8, reg1   \
    ORB reg1, reg2 \
    SHRQ $8, reg1   \
    ORB reg1, reg2 \
    SHRQ $8, reg1   \
    ORB reg1, reg2 \
    SHRQ $8, reg1   \
    ORB reg1, reg2 \
    SHRQ $8, reg1   \
    ORB reg1, reg2 \
    SHRQ $8, reg1   \
    ORB reg1, reg2 \


//func openAsm(roundKeys *uint32, tagSize int,dst []byte, nonce []byte, ciphertext []byte, additionalData []byte, temp *byte) ([]byte, int)
////temp: H, J0, TMask, expectedTag, tmp, Counter-256, TMP-256
//used registers: Enc, H, Nonce, Tmp, J0, TMask, Ciphertext, AdditionalData, Dst
TEXT ·openAsm(SB), NOSPLIT, $80-148
    cryptoPrepare(Reg1, Reg2, Reg31)   //Z26, Z16, Z17 is used to load constant
    MOVQ h+112(FP), H
    loadState1(H)

    MOVQ rk+0(FP), RK
    cryptoBlockAsmMacro(RK) //H stored in VxH, not need reverse
    //movv(VxState4, VxH)
    loadH(VxState4, VxH)

    MOVQ nonce+40(FP), Nonce
    MOVQ nonceLen+48(FP), NonceLen
    MOVQ temp+112(FP), Tmp
    ADDQ $64, Tmp
    setZero(VzTag)
    calculateJ0(Nonce,NonceLen,BlockCount1,Remain1,Tmp,Reg1, Reg2, Reg31)  //J0 store in VxJ0, keep order

    movv(VxJ0, VxState1)
    cryptoBlockAsmMacro(RK)
    movv(VxState4, VxTMask)

    setZero(VxTag)
    MOVQ aData+88(FP), AData
    MOVQ aLen+96(FP), ALen
    CalculateSPre(AData,ALen, BlockCount2, Remain2, Tmp, Reg1, Reg2, Reg32) //GHash(A||0) is stored in VxTag

    MOVQ dst+16(FP), Dst
    MOVQ cipher+64(FP), Cipher
    MOVQ cipherLen+64(FP), CipherLen
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, CipherLen
    cryptoBlocksAsm(RK,Dst,Cipher,CipherLen,Tmp,BlockCount3,Reg1,Reg2,Reg33)

    CalculateSPost(Tmp, ALen, CipherLen, Tmp, BlockCount3)

    ADDQ CipherLen, Cipher
    constantTimeCompare(Tmp,Cipher,TagSize, Reg1, Reg2, Reg33) // the origin tag is put in cipher[len(ciphertext)-tagsize : ]

    //RET   there is still a bug unsolved, ret may contain in some macros