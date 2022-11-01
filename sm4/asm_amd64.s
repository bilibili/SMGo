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

//
#define RoundKeys R10
#define Out R14
#define In R13
#define InLen R12
#define PreCounter R11
#define Counter R8
#define Tmp R9
#define BlockCount R15

#define Enc R14    //AX
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
#define RetCap DX
#define Ret R15
#define Res R15


#define xor256(dst, src1, src2)    \
    VMOVDQU32   (src1), Z1         \
    VMOVDQU32   64(src1), Z4       \
    VMOVDQU32   128(src1), Z7      \
    VMOVDQU32   192(src1), Z10     \
    VMOVDQU32   (src2), Z2         \
    VMOVDQU32   64(src2), Z5       \
    VMOVDQU32   128(src2), Z8      \
    VMOVDQU32   192(src2), Z11     \
    VPXORD      Z1, Z2, Z0         \
    VPXORD      Z4, Z5, Z3         \
    VPXORD      Z7, Z8, Z6         \
    VPXORD      Z10, Z11, Z9       \
    VMOVDQU32   Z0, (dst)          \
    VMOVDQU32   Z3, 64(dst)        \
    VMOVDQU32   Z6, 128(dst)       \
    VMOVDQU32   Z9, 192(dst)       \



//func xor128(dst *byte, src1 *byte, src2 *byte)
#define xor128(dst,src1,src2)   \
    VMOVDQU32   (src1), Z1      \
    VMOVDQU32   64(src1), Z4    \
    VMOVDQU32   (src2), Z2      \
    VMOVDQU32   64(src2), Z5    \
    VPXORD      Z1, Z2, Z0      \
    VPXORD      Z4, Z5, Z3      \
    VMOVDQU32   Z0, (dst)       \
    VMOVDQU32   Z3, 64(dst)     \



#define xor64(dst,src1,src2)  \
    VMOVDQU32   (src1), Z1    \
    VMOVDQU32   (src2), Z2    \
    VPXORD      Z1, Z2, Z0    \
    VMOVDQU32   Z0, (dst)     \

//func xor32(dst *byte, src1 *byte, src2 *byte)
#define xor32(dst,src1,src2)   \
    VMOVDQU32   (src1), Y1     \
    VMOVDQU32   (src2), Y2     \
    VPXORD      Y1, Y2, Y0     \
    VMOVDQU32   Y0, (dst)      \

//func xor16(dst *byte, src1 *byte, src2 *byte)
#define xor16(dst,src1,src2) \
    VMOVDQU32   (src1), X1   \
    VMOVDQU32   (src2), X2   \
    VPXORD      X1, X2, X0   \
    VMOVDQU32   X0, (dst)    \

#define xorAsm1(dst,src1,src2,len) \
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

//func fillCounterX(dst *byte, src *byte, count uint32, blockNum uint32)    --- used registers: DI, SI, AX, BX, CX
#define fillCounterX(dst,src,count,blockNum, temp1, temp2,temp3) \
    MOVQ dst, temp3           \
    ADDQ $12, src             \
    makeUint32(src, temp1)    \
    SUBQ $12, src             \
    ADDL count, temp1         \
    ADDL $1, temp1            \
    fill0: fillSingleBlockAsm(dst, src, temp1, temp2) \
    ADDL $1, temp1  \
    SUBQ $1, blockNum \
    CMPQ blockNum, $0  \
    JG fill0 \
    MOVQ temp3, dst \


#define fillCounterX16(dst,src,count,blockNum, temp1, temp2,temp3) \
    MOVQ dst, temp3           \
    ADDQ $12, src             \
    makeUint32(src, temp1)    \
    SUBQ $12, src             \
    ADDL count, temp1         \
    ADDL $1, temp1            \
    fill16: fillSingleBlockAsm(dst, src, temp1, temp2)\
    ADDL $1, temp1 \
    SUBQ $1, blockNum \
    CMPQ blockNum, $0  \
    JG fill16  \
    MOVQ temp3, dst  \

#define fillCounterX8(dst,src,count,blockNum, temp1, temp2,temp3) \
    MOVQ dst, temp3           \
    ADDQ $12, src             \
    makeUint32(src, temp1)    \
    SUBQ $12, src             \
    ADDL count, temp1         \
    ADDL $1, temp1            \
    fill8: fillSingleBlockAsm(dst, src, temp1, temp2) \
    ADDL $1, temp1  \
    SUBQ $1, blockNum \
    CMPQ blockNum, $0  \
    JG fill8 \
    MOVQ temp3, dst \

#define fillCounterX4(dst,src,count,blockNum, temp1, temp2,temp3) \
    MOVQ dst, temp3           \
    ADDQ $12, src             \
    makeUint32(src, temp1)    \
    SUBQ $12, src             \
    ADDL count, temp1         \
    ADDL $1, temp1            \
    fill4: fillSingleBlockAsm(dst, src, temp1, temp2) \
    ADDL $1, temp1  \
    SUBQ $1, blockNum \
    CMPQ blockNum, $0  \
    JG fill4 \
    MOVQ temp3, dst \

#define fillCounterX2(dst,src,count,blockNum, temp1, temp2,temp3) \
    MOVQ dst, temp3           \
    ADDQ $12, src             \
    makeUint32(src, temp1)    \
    SUBQ $12, src             \
    ADDL count, temp1         \
    ADDL $1, temp1            \
    fill2: fillSingleBlockAsm(dst, src, temp1, temp2) \
    ADDL $1, temp1  \
    SUBQ $1, blockNum \
    CMPQ blockNum, $0  \
    JG fill2 \
    MOVQ temp3, dst \

#define fillCounterX1(dst,src,count,blockNum, temp1, temp2,temp3) \
    MOVQ dst, temp3           \
    ADDQ $12, src             \
    makeUint32(src, temp1)    \
    SUBQ $12, src             \
    ADDL count, temp1         \
    ADDL $1, temp1            \
    fill1: fillSingleBlockAsm(dst, src, temp1, temp2) \
    ADDL $1, temp1  \
    SUBQ $1, blockNum \
    CMPQ blockNum, $0  \
    JG fill1 \
    MOVQ temp3, dst \

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
    //gHashBlocks(DI, SI, AX, BX,R8,R9)
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
    //MOVQ $1, R13
    CALL ·gHashBlocks(SB)
    //gHashBlocks(R15, R14, CX, R13,R8,R9)
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
    MOVQ h+0(FP), BX
    MOVQ BX, 0(SP)
    MOVQ tag+8(FP), CX
    MOVQ CX, 8(SP)
    MOVQ $1, 24(SP)
    //MOVQ $1, R15
    CALL ·gHashBlocks(SB)
    //gHashBlocks(BX, CX, AX, R15,R8,R9)
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

//used registers, R8, R9
#define loadMatrix(Pre, Post) \
    MOVQ    $PreAffineMatrix<>(SB), AX \
    MOVQ    $PostAffineMatrix<>(SB), BX \
    VBROADCASTI32X2     (AX), Pre \ // latency is 3 for 256/512, 1 otherwise; CPI 1
    VBROADCASTI32X2     (BX), Post \ // 128/256: AVX512DQ+AVX512VL; 512: AVX512DQ

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
    MOVQ        $Shuffle<>(SB), AX \
    VMOVDQU32   (AX), VxShuffle \

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

#define loadInputX1(Src, V1) \ // we should perform transpose/rev later
    VMOVDQU32   (Src), V1 \

#define storeOutputX1(V1, Dst) \
    VMOVDQU32   V1, (Dst) \

//func cryptoBlockAsm(rk *uint32, dst, src *byte)
#define cryptoBlockAsmMacro(rk,dst,src)    \
    loadShuffle128()   \
    loadInputX1(src, VxState1)  \
    loadMatrix(VxPreMatrix, VxPostMatrix)  \
    rev32(VxShuffle, VxState1)   \ // latency hiden successfully
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
    storeOutputX1(VxState4, dst)  \

TEXT ·cryptoBlockAsm(SB),NOSPLIT,$0-24
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

#define loadInputX2(Src, V1, V2) \ // we should perform transpose/rev later
    VMOVDQU32   (Src), V1 \
    VMOVDQU32   (16)(Src), V2 \

#define storeOutputX2(V1, V2, Dst) \
    VMOVDQU32   V1, (Dst) \ //SSE2, latency 5, CPI 1
    VMOVDQU32   V2, (16)(Dst) \


//func cryptoBlockAsmX2(rk *uint32, dst, src *byte)
#define cryptoBlockAsmX2Macro(rk,dst,src) \
    loadShuffle128()   \
    loadInputX2(src, VxState1, VxState2)   \
    loadMatrix(VxPreMatrix, VxPostMatrix)  \
    rev32(VxShuffle, VxState1)   \ // latency hiden successfully
    rev32(VxShuffle, VxState2)   \
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
    storeOutputX2(VxState4, VxState3, dst)  \

TEXT ·cryptoBlockAsmX2(SB),NOSPLIT,$0-24
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

//func cryptoBlockAsmX4(rk *uint32, dst, src *byte)
#define cryptoBlockAsmX4Macro(rk, dst, src)  \
    loadShuffle128()  \
    loadInputX4(src, VxState1, VxState2, VxState3, VxState4)  \
    loadMatrix(VxPreMatrix, VxPostMatrix)  \
    revStates(VxShuffle, VxState1, VxState2, VxState3, VxState4)  \ // latency hiden successfully
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
    storeOutputX4(VxState4, VxState3, VxState2, VxState1, dst)      \


TEXT ·cryptoBlockAsmX4(SB),NOSPLIT,$0-24
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

#define loadShuffle256() \
    MOVQ                $Shuffle<>(SB), AX \
    VBROADCASTI32X4     (AX), VyShuffle \ // AVX512F, latency 8? CPI 0.5

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

//func cryptoBlockAsmX8(rk *uint32, dst, src *byte)
#define cryptoBlockAsmX8Macro(rk, dst, src) \
    loadShuffle256()  \
    loadInputX8(src, VyState1, VyState2, VyState3, VyState4)  \
    loadMatrix(VyPreMatrix, VyPostMatrix)  \
    revStates(VyShuffle, VyState1, VyState2, VyState3, VyState4)  \// latency hiden successfully
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
    storeOutputX8(VyState4, VyState3, VyState2, VyState1, dst)  \

TEXT ·cryptoBlockAsmX8(SB),NOSPLIT,$0-24
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

#define loadShuffle512() \
MOVQ                $Shuffle<>(SB), AX \
VBROADCASTI32X4     (AX), VzShuffle \ // AVX512F, latency 8? CPI 0.5

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

//used registers:
//loadShuffle512 - AX, Z26:zShuffle
//loadInputX16 - Z21- Z24: VzState1-VzState4
//loadMatrix - R8, R9, Z16, Z17: VzPreMatrix, VzPostMatrix
//revStates - Z26:VzShuffle, Z21- Z24: VzState1-VzState4
//transpose4x4 - Z21- Z24: VzState1-VzState4, Z0, Z1: T0z, T1z
#define cryptoBlockAsmX16Macro(rk,dst,src)  \
    loadShuffle512() \
    loadInputX16(src, VzState1, VzState2, VzState3, VzState4)  \ // latency: 8
    loadMatrix(VzPreMatrix, VzPostMatrix) \
    revStates(VzShuffle, VzState1, VzState2, VzState3, VzState4)  \ // latency hiden successfully
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
    storeOutputX16(VzState4, VzState3, VzState2, VzState1, dst)     \

TEXT ·cryptoBlockAsmX16(SB),NOSPLIT,$0-24
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

//cryptoBlocksAsm(roundKeys *uint32, out []byte, in []byte, preCounter *byte, counter *byte, tmp *byte) --- used registers: R8-R15, SI,DI,AX-DX  something happend between uint and int,need check again
TEXT ·cryptoBlocksAsm(SB),NOSPLIT,$56-80
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
    MOVL $16, DI
    fillCounterX16(Counter,PreCounter,BlockCount,DI, SI, AX,BX)
    cryptoBlockAsmX16Macro(RoundKeys,Tmp,Counter)
    xor256(Out,Tmp,In)
    ADDQ $256, Out
    ADDQ $256, In
    ADDQ $16, BlockCount
    SUBQ $256, InLen
    JMP loopX16
loopX8:
    CMPQ InLen, $128
    JL loopX4
    MOVL $8, DI
    fillCounterX8(Counter,PreCounter,BlockCount,DI, SI, AX,BX)
    cryptoBlockAsmX8Macro(RoundKeys, Tmp, Counter)
    xor128(Out,Tmp,In)
    ADDQ $128, Out
    ADDQ $128, In
    ADDQ $8, BlockCount
    SUBQ $128, InLen
    JMP loopX8
loopX4:
    CMPQ InLen, $64
    JL loopX2
    MOVL $4, DI
    fillCounterX4(Counter,PreCounter,BlockCount,DI, SI, AX,BX)
    cryptoBlockAsmX4Macro(RoundKeys,Tmp,Counter)
    xor64(Out,Tmp,In)
    ADDQ $64, Out
    ADDQ $64, In
    ADDQ $4, BlockCount
    SUBQ $64, InLen
    JMP loopX4
loopX2:
    CMPQ InLen, $32
    JL loopX1
    MOVL $2, DI
    fillCounterX2(Counter,PreCounter,BlockCount,DI, SI, AX,BX)
    cryptoBlockAsmX2Macro(RoundKeys, Tmp, Counter)
    xor32(Out,Tmp,In)
    ADDQ $32, Out
    ADDQ $32, In
    ADDQ $2, BlockCount
    SUBQ $32, InLen
    JMP loopX2
loopX1:
    CMPQ InLen, $16
    JL loopX0
    MOVL $1, DI
    fillCounterX1(Counter,PreCounter,BlockCount,DI, SI, AX,BX)
    cryptoBlockAsmMacro(RoundKeys, Tmp, Counter)
    xor16(Out,Tmp,In)
    ADDQ $16, Out
    ADDQ $16, In
    ADDQ $1, BlockCount
    SUBQ $16, InLen
    JMP loopX1
loopX0:
    CMPQ InLen, $0
    JLE done
    MOVL $1, DI
    fillCounterX(Counter,PreCounter,BlockCount,DI, SI, AX,BX)
    cryptoBlockAsmMacro(RoundKeys, Tmp, Counter)
final:
    xorAsm1(Out,Tmp,In,InLen)
done:
    RET

//cryptoBlocksAsm(roundKeys *uint32, out []byte, in []byte, preCounter *byte, counter *byte, tmp *byte)
#define cryptoBlocksAsm(RoundKeys, Out, In, InLen, preCounter,Counter,tmp)   \
    MOVL $0, BlockCount     \ //BlockCount
loopX16:                    \
    CMPQ InLen, $256        \
    JL loopX8               \
    MOVL $16, DI            \
    fillCounterX16(Counter,PreCounter,BlockCount,DI, SI, AX,BX)  \
    cryptoBlockAsmX16Macro(RoundKeys,Tmp,Counter)  \
    xor256(Out,Tmp,In)   \
    ADDQ $256, Out       \
    ADDQ $256, In        \
    ADDQ $16, BlockCount  \
    SUBQ $256, InLen      \
    JMP loopX16           \
loopX8:                   \
    CMPQ InLen, $128      \
    JL loopX4             \
    MOVL $8, DI           \
    fillCounterX8(Counter,PreCounter,BlockCount,DI, SI, AX,BX)  \
    cryptoBlockAsmX8Macro(RoundKeys, Tmp, Counter)     \
    xor128(Out,Tmp,In)    \
    ADDQ $128, Out        \
    ADDQ $128, In         \
    ADDQ $8, BlockCount   \
    SUBQ $128, InLen      \
    JMP loopX8            \
loopX4:                   \
    CMPQ InLen, $64       \
    JL loopX2             \
    MOVL $4, DI           \
    fillCounterX4(Counter,PreCounter,BlockCount,DI, SI, AX,BX)  \
    cryptoBlockAsmX4Macro(RoundKeys,Tmp,Counter)  \
    xor64(Out,Tmp,In)  \
    ADDQ $64, Out      \
    ADDQ $64, In       \
    ADDQ $4, BlockCount  \
    SUBQ $64, InLen      \
    JMP loopX4           \
loopX2:                  \
    CMPQ InLen, $32      \
    JL loopX1            \
    MOVL $2, DI          \
    fillCounterX2(Counter,PreCounter,BlockCount,DI, SI, AX,BX)  \
    cryptoBlockAsmX2Macro(RoundKeys, Tmp, Counter)   \
    xor32(Out,Tmp,In)   \
    ADDQ $32, Out       \
    ADDQ $32, In        \
    ADDQ $2, BlockCount  \
    SUBQ $32, InLen      \
    JMP loopX2           \
loopX1:                  \
    CMPQ InLen, $16      \
    JL loopX0            \
    MOVL $1, DI          \
    fillCounterX1(Counter,PreCounter,BlockCount,DI, SI, AX,BX)  \
    cryptoBlockAsmMacro(RoundKeys, Tmp, Counter)  \
    xor16(Out,Tmp,In)   \
    ADDQ $16, Out       \
    ADDQ $16, In        \
    ADDQ $1, BlockCount \
    SUBQ $16, InLen     \
    JMP loopX1          \
loopX0:                 \
    CMPQ InLen, $0      \
    JLE done            \
    MOVL $1, DI         \
    fillCounterX(Counter,PreCounter,BlockCount,DI, SI, AX,BX)  \
    cryptoBlockAsmMacro(RoundKeys, Tmp, Counter)  \
final:   \
    xorAsm1(Out,Tmp,In,InLen)   \
done:  \
    NOP  \

// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// optimized partially based on the Intel document "Optimized Galois-Counter-Mode Implementation on Intel Architecture Processors"
// https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/communications-ia-galois-counter-mode-paper.pdf

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
//#define T0x X0
//#define T1x X1
//#define T2x X2
//#define T3x X3

#define U1x X4
#define U2x X5

#define U1y Y4
#define U2y Y5

//#define T0z Z0
//#define T1z Z1
//#define T2z Z2
//#define T3z Z3

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

// X/Y/Z 18~20 Src, Interim, Dst for affine instructions
//#define VxSrc       X18
//#define VxInterim   X19
//#define VxDst       X20

//#define VySrc       Y18
//#define VyInterim   Y19
//#define VyDst       Y20

//#define VzSrc       Z18
//#define VzInterim   Z19
//#define VzDst       Z20

// X/Y/Z 21~24 for states
//#define VxState1    X21
//#define VxState2    X22
//#define VxState3    X23
//#define VxState4    X24

//#define VyState1    Y21
//#define VyState2    Y22
//#define VyState3    Y23
//#define VyState4    Y24

//#define VzState1    Z21
//#define VzState2    Z22
//#define VzState3    Z23
//#define VzState4    Z24

// X/Y/Z 25 for round key
//#define VxRoundKey  X25
//#define VyRoundKey  Y25
//#define VzRoundKey  Z25

// X/Y/X 26 for byte order shuffle
//#define VxShuffle   X26
//#define VyShuffle   Y26
//#define VzShuffle   Z26


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


#define needExpandAsm(arrayLen, arrayCap, asked, res, temp1, temp2) \
    MOVQ arrayCap, temp1     \
    SUBQ arrayLen, temp1     \
    MOVQ $0, temp2           \
    CMPQ temp1, asked         \
    JGE 2(PC)                \
    MOVQ $1, temp2           \
    MOVQ temp2, res          \

TEXT ·needExpand(SB), $0-40
	MOVQ array+0(FP), DI
	MOVQ arrayLen+8(FP), SI
	MOVQ arrayCap+16(FP), AX
	MOVQ asked+24(FP), BX
	needExpandAsm(SI, AX, BX, CX, R8, R9)
	MOVQ CX, ret1+32(FP)
	RET


//func sealAsm(roundKeys *uint32, tagSize int, dst []byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte) []byte
//temp:  H, TMask, J0, tag, counter, tmp, CNT-256, TMP-256
//cryptoBlockAsm: 24, calculateFirstCounterAsm:48, ensureCapacityAsm:32  cryptoBlocksAsm:80  gHashUpdateAsm:48 gHashFinishAsm:40
TEXT ·sealAsm(SB), NOSPLIT, $80-144    //80->88
    //used registers: AX, R10 (not include the function used)
    MOVQ roundKeys+0(FP), Enc
    MOVQ h+112(FP), H
    //MOVQ Enc, 0(SP)
    //MOVQ H, 8(SP)
    //MOVQ H, 16(SP)
    //CALL ·cryptoBlockAsm(SB)
    //MOVQ 8(SP), H
    cryptoBlockAsmMacro(Enc, H, H)

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
    //MOVQ Enc, 0(SP)
    //MOVQ TMask, 8(SP)
    //MOVQ J0, 16(SP)
    //CALL ·cryptoBlockAsm(SB)
    cryptoBlockAsmMacro(Enc, TMask, J0)

    //used registers: AX, R15, R14, DX, DI, R12  ---- R9
    MOVQ dst+16(FP), Ret
    MOVQ dstLen+24(FP), Tmp
    MOVQ dstCap+32(FP), RetCap
    MOVQ roundKeys+0(FP), Enc
    MOVQ Enc, 0(SP)
    ADDQ Tmp, Ret
    MOVQ Ret, 8(SP)
    SUBQ Tmp, RetCap
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
    MOVQ dstLen+24(FP), Tmp
    ADDQ Tmp, Ret
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
    //MOVQ Tag, 0(SP)
    //MOVQ Tag, 8(SP)
    MOVQ temp+112(FP), TMask
    ADDQ $16, TMask
    //MOVQ TMask, 16(SP)
    //CALL ·xor16(SB)

    xor16(Tag, Tag, TMask)

    MOVQ dst+16(FP), Ret
    MOVQ Ret, ret1+120(FP)
    MOVQ dstCap+32(FP), RetCap
    MOVQ RetCap, ret2+128(FP)
    MOVQ RetCap, ret3+136(FP)

    RET

//func constantTimeCompareAsm(x *byte, y *byte, l int) int32. the result is in temp2
#define constantTimeCompare(x,y,l,temp1,temp2,temp3) \
    MOVQ $0, temp1   \
    MOVQ $0, temp2   \
fastCmp:             \
    CMPQ l, $8       \
    JL slowCmp       \
    MOVQ (x), temp3  \
    XORQ temp3, (y)  \
    ORQ (y),temp1    \
    ADDQ $8, x       \
    ADDQ $8, y       \
    SUBQ $8, l       \
    JMP fastCmp      \
slowCmp:             \
    CMPQ l, $1       \
    JL done          \
    MOVB (x), temp3  \
    XORB temp3, (y)  \
    ORB (y), temp2   \
    ADDQ $1, x       \
    ADDQ $1, y       \
    SUBQ $1, l       \
    JMP slowCmp      \
done:                \
    ORB temp1, temp2 \
    SHRQ $8, temp1   \
    ORB temp1, temp2 \
    SHRQ $8, temp1   \
    ORB temp1, temp2 \
    SHRQ $8, temp1   \
    ORB temp1, temp2 \
    SHRQ $8, temp1   \
    ORB temp1, temp2 \
    SHRQ $8, temp1   \
    ORB temp1, temp2 \
    SHRQ $8, temp1   \
    ORB temp1, temp2 \
    SHRQ $8, temp1   \
    ORB temp1, temp2 \


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
//used registers: Enc, H, Nonce, Tmp, J0, TMask, Ciphertext, AdditionalData, Dst
TEXT ·openAsm(SB), NOSPLIT, $80-148
    //used registers: AX, R10 (not include the function used)
    MOVQ roundKeys+0(FP), Enc
    MOVQ h+112(FP), H
    //MOVQ Enc, 0(SP)
    //MOVQ H, 8(SP)
    //MOVQ H, 16(SP)
    //CALL ·cryptoBlockAsm(SB)
    //MOVQ 8(SP), H

    cryptoBlockAsmMacro(Enc, H, H)

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
    //MOVQ Enc, 0(SP)
    //MOVQ TMask, 8(SP)
    //MOVQ J0, 16(SP)
    //CALL ·cryptoBlockAsm(SB)
    cryptoBlockAsmMacro(Enc, TMask, J0)

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
    MOVQ Tag, TMask
    SUBQ $16, TMask
    //MOVQ TMask, 16(SP)
    //CALL ·xor16(SB)
    xor16(Tag, Tag, TMask)

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







