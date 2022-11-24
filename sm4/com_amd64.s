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

//*********    CIPH and ExpandKey related          ************
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

// pre- and post-inverse affine matrix
DATA PreAffineMatrix<>+0x00(SB)/8, $0x4c287db91a22505d
GLOBL PreAffineMatrix<>(SB), (NOPTR+RODATA), $8
DATA PostAffineMatrix<>+0x00(SB)/8, $0xf3ab34a974a6b589
GLOBL PostAffineMatrix<>(SB), (NOPTR+RODATA), $8

// pre- and post-inverse affine constant
#define PreAffineConstant 0b00111110
#define PostAffineConstant 0b11010011

#define MASK  K1

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
#define U1y Y4

#define T5y Y5
#define U2y Y5

#define T0z Z0

#define T1z Z1

#define T2z Z2
#define T3z Z3

#define T4z Z4

#define T5z Z5

//**********      CIPH related     **************
// X/Y/Z Src, Interim, Dst for affine instructions
#define VxInterim X0
#define VyInterim Y0
#define VzInterim Z0

#define VxSrc X4
#define VySrc Y4
#define VzSrc Z4

#define VxDst X5
#define VyDst Y5
#define VzDst Z5

// X/Y/Z 6~9 for states
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

// X/Y/Z 12  pre-inverse affine matrix
#define VxPreMatrix X12
#define VyPreMatrix Y12
#define VzPreMatrix Z12

// X/Y/Z 13  post-inverse affine matrix
#define VxPostMatrix X13
#define VyPostMatrix Y13
#define VzPostMatrix Z13

// X/Y/X 20 for byte order shuffle
#define VxShuffle   X20
#define VyShuffle   Y20
#define VzShuffle   Z20

// X/Y/Z 27 for round key
#define VxRoundKey   X27
#define VyRoundKey   Y27
#define VzRoundKey   Z27


// **************       related with rev        ***************
// related with reverse bytes
#define rev32(Const, R) \
    VPSHUFB     Const, R, R \ // AVX512F(512) or SSE2(128) or AVX2(256), latency 1, CPI 0.5(256)/1(128;512)

#define revStates(Const, S1, S2, S3, S4) \
    rev32(Const, S1) \
    rev32(Const, S2) \
    rev32(Const, S3) \
    rev32(Const, S4) \

//related with reverse bits  - load consts
#define loadMasks(tmp1,tmp2) \
    MOVQ                $AND_MASK<>(SB), tmp1 \
    MOVQ                $LOWER_MASK<>(SB), tmp2 \
    VBROADCASTI32X2     (tmp1), VzAndMask \ // latency 8, CPI 0.5
    VBROADCASTI32X4     (tmp2), VzLowerMask \
    VPSLLQ $4, VzLowerMask, VzHigherMask \

// **************       related with load        ***************
//load shuffle constant
#define loadShuffle512(reg) \
    MOVQ                $Shuffle<>(SB), reg \
    VBROADCASTI32X4     (reg), VzShuffle \ // AVX512F, latency 8? CPI 0.5

#define loadShuffle256(reg) \
    MOVQ                $Shuffle<>(SB), reg \
    VBROADCASTI32X4     (reg), VyShuffle \ // AVX512F, latency 8? CPI 0.5

#define loadShuffle128(reg) \
    MOVQ        $Shuffle<>(SB), reg \
    VMOVDQU32   (reg), VxShuffle \

#define loadMatrix(Pre, Post, reg1, reg2) \
    MOVQ    $PreAffineMatrix<>(SB), reg1 \
    MOVQ    $PostAffineMatrix<>(SB), reg2 \
    VBROADCASTI32X2     (reg1), Pre \ // latency is 3 for 256/512, 1 otherwise; CPI 1
    VBROADCASTI32X2     (reg2), Post \ // 128/256: AVX512DQ+AVX512VL; 512: AVX512DQ

//load input with 16 blocks
#define loadInputX16(Src, V1, V2, V3, V4) \ // FIXME: little endian
    VMOVDQU32   (Src), V1 \ //AVX512F, latency 8, CPI 0.5 -- we should delay the transpose operations
    VMOVDQU32   (64)(Src), V2 \
    VMOVDQU32   (128)(Src), V3 \
    VMOVDQU32   (192)(Src), V4 \

//load input with 8 blocks
#define loadInputX8(Src, V1, V2, V3, V4) \
    VMOVDQU32   (Src), V1 \ //AVX, latency 7, CPI 0.5
    VMOVDQU32   (32)(Src), V2 \ // we should perform transpose later
    VMOVDQU32   (64)(Src), V3 \
    VMOVDQU32   (96)(Src), V4 \

//load input with 4 blocks
#define loadInputX4(Src, V1, V2, V3, V4) \
    VMOVDQU32   (Src), V1 \
    VMOVDQU32   (16)(Src), V2 \
    VMOVDQU32   (32)(Src), V3 \
    VMOVDQU32   (48)(Src), V4 \

//load input with 2 blocks
#define loadInputX2(Src, V1, V2) \ // we should perform transpose/rev later
    VMOVDQU32   (Src), V1 \
    VMOVDQU32   (16)(Src), V2 \

//load input with 1 blocks
#define loadInputX1(Src, V1) \ // we should perform transpose/rev later
    VMOVDQU32   (Src), V1 \

// **************       related with store        ***************
//store output with 16 blocks
#define storeOutputX16(V1, V2, V3, V4, Dst) \ // FIXME: little endian
    VMOVDQU32   V1, (Dst) \ //AVX512F, latency 5, CPI 1
    VMOVDQU32   V2, (64)(Dst) \
    VMOVDQU32   V3, (128)(Dst) \
    VMOVDQU32   V4, (192)(Dst) \

//store output with 8 blocks
#define storeOutputX8(V1, V2, V3, V4, Dst) \
    VMOVDQU32   V1, (Dst) \ //AVX, latency 5, CPI 1
    VMOVDQU32   V2, (32)(Dst) \
    VMOVDQU32   V3, (64)(Dst) \
    VMOVDQU32   V4, (96)(Dst) \

//store output with 4 blocks
#define storeOutputX4(V1, V2, V3, V4, Dst) \
    VMOVDQU32   V1, (Dst) \ //SSE2, latency 5, CPI 1
    VMOVDQU32   V2, (16)(Dst) \
    VMOVDQU32   V3, (32)(Dst) \
    VMOVDQU32   V4, (48)(Dst) \

//store output with 2 blocks
#define storeOutputX2(V1, V2, Dst) \
    VMOVDQU32   V1, (Dst) \ //SSE2, latency 5, CPI 1
    VMOVDQU32   V2, (16)(Dst) \

//store output with 1 blocks
#define storeOutputX1(V1, Dst) \
    VMOVDQU32   V1, (Dst) \

// **************       related with xor        ***************
#define xor256(dst,src, Vz1, Vz2, Vz3, Vz4)    \
    VMOVDQU32   (src),    Z0        \
    VMOVDQU32   64(src),  Z1        \
    VMOVDQU32   128(src), Z2        \
    VMOVDQU32   192(src), Z3        \
    VPXORD      Vz1, Z0, Vz1        \
    VPXORD      Vz2, Z1, Vz2        \
    VPXORD      Vz3, Z2, Vz3        \
    VPXORD      Vz4, Z3, Vz4        \
    VMOVDQU32   Vz1,   (dst)        \
    VMOVDQU32   Vz2,   64(dst)      \
    VMOVDQU32   Vz3,   128(dst)     \
    VMOVDQU32   Vz4,   192(dst)     \

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

#define xor64(dst, src, Vx1, Vx2, Vx3, Vx4) \
    VMOVDQU32   (src),   X1      \
    VMOVDQU32   16(src), X2      \
    VMOVDQU32   32(src), X3      \
    VMOVDQU32   48(src), X4      \
    VPXORD      X1, Vx1, Vx1     \
    VPXORD      X2, Vx2, Vx2     \
    VPXORD      X3, Vx3, Vx3     \
    VPXORD      X4, Vx4, Vx4     \

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

//load round key
#define loadRoundKey(R, RK) \
    MOVD    (R), X1 \
    ADDQ    $4, R \ //TODO replace by offsets to R
    VPBROADCASTD  X1, RK \ // latency is 3 for 256/512, 1 otherwise; CPI 1

#define loadRoundKeyX(R) \
    loadRoundKey(R, VxRoundKey) \

#define loadRoundKeyY(R) \
    loadRoundKey(R, VyRoundKey) \

#define loadRoundKeyZ(R) \
    loadRoundKey(R, VzRoundKey) \

//related with sub round calculation
#define getXor(B, C, D, Dst, T0, T1, RK) \
    VPXORD  B, C, T0 \ // AVX512F+AVX512VL, latency 1, CPI 0.33(128;256)/0.5(512)
    VPXORD  D, T0, T1 \
    VPXORD  RK, T1, Dst \ // loading round key (running prior to this) costs some latency so move it last

#define getXorX(B, C, D, Dst) \
    getXor(B, C, D, Dst, T0x, T1x, VxRoundKey) \
    \//getXor(B, C, D, Dst, VxMid, VxHigh, VxRoundKey) \

#define getXorY(B, C, D, Dst) \
    getXor(B, C, D, Dst, T0y, T1y, VyRoundKey) \

#define getXorZ(B, C, D, Dst) \
    getXor(B, C, D, Dst, T0z, T1z, VzRoundKey) \

#define affine(PreMatrix, PostMatrix, Src, Interim, Dst) \
    VGF2P8AFFINEQB $PreAffineConstant, PreMatrix, Src, Interim \ //GFNI + AVX512VL(128;256) / AVX512F(512)
    VGF2P8AFFINEINVQB $PostAffineConstant, PostMatrix, Interim, Dst \ //latency 3?, CPI 0.5(128;256)/1(512)

#define transformL(Data, T0, T1, T2, T3) \
    VPROLD    $2,  Data, T0 \ // AVX512F(512)+AVX512VL(128;256), latency 1, CPI 0.5(128;256)/1(512)
    VPROLD    $10, Data, T1 \
    VPROLD    $18, Data, T2 \
    VPROLD    $24, Data, T3 \
    VPXORD    T0, T1, T0 \
    VPXORD    T2, T3, T2 \
    VPXORD    T0, T2, T0 \
    VPXORD    T0, Data, Data \

#define transformLX(Data) \
    transformL(Data, T0x, T1x, T2x, T3x)

#define transformLY(Data) \
    transformL(Data, T0y, T1y, T2y, T3y)

#define transformLZ(Data) \
    transformL(Data, T0z, T1z, T2z, T3z) \

#define subRoundX(A, B, C, D) \
    getXorX(B, C, D, VxSrc) \
    affine(VxPreMatrix, VxPostMatrix, VxSrc, VxInterim, VxDst) \
    transformLX(VxDst) \
    VPXORD  VxDst, A, A \

#define subRoundY(A, B, C, D) \
    getXorY(B, C, D, VySrc) \
    affine(VyPreMatrix, VyPostMatrix, VySrc, VyInterim, VyDst) \
    transformLY(VyDst) \
    VPXORD  VyDst, A, A \

#define subRoundZ(A, B, C, D) \
    getXorZ(B, C, D, VzSrc) \
    affine(VzPreMatrix, VzPostMatrix, VzSrc, VzInterim, VzDst) \
    transformLZ(VzDst) \
    VPXORD  VzDst, A, A \

#define roundX(R) \
    loadRoundKeyX(R) \
    subRoundX(VxState1, VxState2, VxState3, VxState4) \
    loadRoundKeyX(R) \
    subRoundX(VxState2, VxState3, VxState4, VxState1) \
    loadRoundKeyX(R) \
    subRoundX(VxState3, VxState4, VxState1, VxState2) \
    loadRoundKeyX(R) \
    subRoundX(VxState4, VxState1, VxState2, VxState3) \

#define roundY(R) \
    loadRoundKeyY(R) \
    subRoundY(VyState1, VyState2, VyState3, VyState4) \
    loadRoundKeyY(R) \
    subRoundY(VyState2, VyState3, VyState4, VyState1) \
    loadRoundKeyY(R) \
    subRoundY(VyState3, VyState4, VyState1, VyState2) \
    loadRoundKeyY(R) \
    subRoundY(VyState4, VyState1, VyState2, VyState3) \

#define roundZ(R) \
    loadRoundKeyZ(R) \
    subRoundZ(VzState1, VzState2, VzState3, VzState4) \
    loadRoundKeyZ(R) \
    subRoundZ(VzState2, VzState3, VzState4, VzState1) \
    loadRoundKeyZ(R) \
    subRoundZ(VzState3, VzState4, VzState1, VzState2) \
    loadRoundKeyZ(R) \
    subRoundZ(VzState4, VzState1, VzState2, VzState3) \

