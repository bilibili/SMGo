// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// "table lookup in NEON" method credited to Ard Biesheuve from Linaro, see https://www.linaro.org/blog/accelerated-aes-for-the-arm64-linux-kernel/

// TBX is not available in Go assembly for ARM64 so we have to code the machine word.
// See ARM opcode refs: https://github.com/CAS-Atlantic/AArch64-Encoding

// A useful referenc will be the "NEON Programmer's Guide", by ARM.

// Note: this assembly file is developed and benchmarked with Apple M1. It might perform differently with other NOEN implementations.
// According to works of Dougall Johnson here: https://dougallj.github.io/applecpu/firestorm-simd.html
// TBX with 4 registers and 16B query with Apple M1 has a latency of 8.

// According to the "Arm Cortex-X1 Core Software Optimization Guide", the TBX instruction with 4 registers, has a altency of 6.
// By now (early 2022) Cortex-X1 is the most performant ARM microarchitecture. So this suggests a need for X16 implementation.
// But only test results can tell. Let us know your results should you run benchmarks on any other NEON implementations.

#include "textflag.h"
//see Test_printDataBlock for data generation
//note: data have been reserved due to LE/BE
DATA SBox<>+0x00(SB)/8, $0xb73de1ccfee990d6
DATA SBox<>+0x08(SB)/8, $0x052cfb28c214b616
DATA SBox<>+0x10(SB)/8, $0xc304be2a769a672b
DATA SBox<>+0x18(SB)/8, $0x99068649261344aa
DATA SBox<>+0x20(SB)/8, $0x7a98ef91f450429c
DATA SBox<>+0x28(SB)/8, $0x62accfed430b5433
DATA SBox<>+0x30(SB)/8, $0x95e808c9a91cb3e4
DATA SBox<>+0x38(SB)/8, $0xa63f8f75fa94df80
DATA SBox<>+0x40(SB)/8, $0xba1773f3fca70747
DATA SBox<>+0x48(SB)/8, $0xa84f85e6193c5983
DATA SBox<>+0x50(SB)/8, $0x8bda6471b2816b68
DATA SBox<>+0x58(SB)/8, $0x359d56704b0febf8
DATA SBox<>+0x60(SB)/8, $0xa2d158635e0e241e
DATA SBox<>+0x68(SB)/8, $0x877821013b7c2225
DATA SBox<>+0x70(SB)/8, $0x5227d39f574600d4
DATA SBox<>+0x78(SB)/8, $0x9ec8c4a0e702364c
DATA SBox<>+0x80(SB)/8, $0xb538c740d28abfea
DATA SBox<>+0x88(SB)/8, $0xa11561f9cef2f7a3
DATA SBox<>+0x90(SB)/8, $0x551a349ba45daee0
DATA SBox<>+0x98(SB)/8, $0xe3b18cf5303293ad
DATA SBox<>+0xa0(SB)/8, $0x60ca66822ee2f61d
DATA SBox<>+0xa8(SB)/8, $0x6f4e530dab2329c0
DATA SBox<>+0xb0(SB)/8, $0x2f8efdde4537dbd5
DATA SBox<>+0xb8(SB)/8, $0x515b6c6d726aff03
DATA SBox<>+0xc0(SB)/8, $0x7fbcddbb92af1b8d
DATA SBox<>+0xc8(SB)/8, $0xd85a101f415cd911
DATA SBox<>+0xd0(SB)/8, $0xbd7bcda58831c10a
DATA SBox<>+0xd8(SB)/8, $0xb0b4e5b812d0742d
DATA SBox<>+0xe0(SB)/8, $0x7e77960c4a976989
DATA SBox<>+0xe8(SB)/8, $0x84c66ec509f1b965
DATA SBox<>+0xf0(SB)/8, $0x204ddc3aec7df018
DATA SBox<>+0xf8(SB)/8, $0x4839cbd73e5fee79
GLOBL SBox<>(SB), (NOPTR+RODATA), $256

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
// V16 ~ V31: SBox
// V15: constant for table lookup
// V11~14: drafts
// V7~10: input data and program state (for 2X)
// V6: round key (load per round)
// V2~5: input data and program state (for 1X)
// V1: target and initial index for table lookup (for 8X)
// V0: target and initial index for table lookup (for 4X)

// R0~8: general purpose drafts
// R9~12: parameters

// When in 16X mode, L1 cache will be used to stash states
// R13~16  pointers to stack variables (for 16X)

// 1st set of state, naming convension from sm4.go
#define     Z0  V0
#define     Z1  V1
#define     Z2  V2
#define     Z3  V3

// 2nd set of state if we are going to do 2X (1X deals with up to 4 blocks in parallel, 2X 8 blocks)
#define     Y0  V4
#define     Y1  V5
#define     Y2  V6
#define     Y3  V7

// to hold the XOR results to be fed into the tau transformation
#define     U0 V8
#define     U1 V9
#define     U2 V10
#define     U3 V11

// round key, loaded per round; also used to load CK during key expansion
#define     RK  V12

// draft registers, served as temporal variables
#define     T0  V13
#define     T1  V14

#define     CONST V15

#define     StashZ  R13
#define     StashY  R14
#define     StashW  R15
#define     StashX  R16

#define loadSBox(Rx) \
    MOVD    $SBox<>(SB), Rx \
    VLD1.P  64(Rx), [V16.B16, V17.B16, V18.B16, V19.B16] \
    VLD1.P  64(Rx), [V20.B16, V21.B16, V22.B16, V23.B16] \
    VLD1.P  64(Rx), [V24.B16, V25.B16, V26.B16, V27.B16] \
    VLD1.P  64(Rx), [V28.B16, V29.B16, V30.B16, V31.B16] \

// lookup up to 4 data blcoks (16bytes / block)
#define tableLookupX4() \
    VSUB    CONST.B16, U0.B16, Y0.B16 \
    VTBL    U0.B16, [V16.B16, V17.B16, V18.B16, V19.B16], U0.B16 \
    VSUB    CONST.B16, Y0.B16, Y1.B16 \
    WORD    $0x4E007000 | 4<<16 | 20<<5 | 0x08 \
    VSUB    CONST.B16, Y1.B16, Y2.B16 \
    WORD    $0x4E007000 | 5<<16 | 24<<5 | 0x08 \
    WORD    $0x4E007000 | 6<<16 | 28<<5 | 0x08 \

#define swap(A, B) \
    \//VSWP     A, B //unrecognized instruction, TODO
    VMOV    A, T0.B16 \
    VMOV    B, A \
    VMOV    T0.B16, B \

#define revZ() \
    VREV32  Z0.B16, Z0.B16 \
    VREV32  Z1.B16, Z1.B16 \
    VREV32  Z2.B16, Z2.B16 \
    VREV32  Z3.B16, Z3.B16 \

#define revY() \
    VREV32  Y0.B16, Y0.B16 \
    VREV32  Y1.B16, Y1.B16 \
    VREV32  Y2.B16, Y2.B16 \
    VREV32  Y3.B16, Y3.B16 \

// It should only use T0 & T1 as drafts
#define getXor(B, C, D, DST) \
    VEOR    B.B16, C.B16, T0.B16 \
    VEOR    D.B16, RK.B16, T1.B16 \
    VEOR    T0.B16, T1.B16, DST.B16 \

// transform in-place
// Note: VMUL & VMULL instructions can perform polynormial multiplication for P8 & P16 data types.
// But we would need P32.
// Also, these two intructions are not available in Go arm64 assembly.
#define transformL(Data, Tx) \
    VSHL    $2,  Data.S4, T0.S4 \
    VSRI    $30, Data.S4, T0.S4 \
    VSHL    $10, Data.S4, T1.S4 \
    VSRI    $22, Data.S4, T1.S4 \
    VEOR    T0.B16, T1.B16, T0.B16 \
    VSHL    $18, Data.S4, Tx.S4 \
    VSRI    $14, Data.S4, Tx.S4 \
    VSHL    $24, Data.S4, T1.S4 \
    VSRI    $8,  Data.S4, T1.S4 \
    VEOR    Tx.B16, T1.B16, Tx.B16 \
    VEOR    T0.B16, Tx.B16, T0.B16 \
    VEOR    T0.B16, Data.B16, Data.B16 \

#define subRoundX4(A, B, C, D) \
    getXor(B, C, D, U0) \
    tableLookupX4() \
    transformL(U0, Y0) \
    VEOR    U0.B16, A.B16, A.B16 \

TEXT ·expandKeyAsm(SB),NOSPLIT,$0-24

    #define saveKeys(Renc, Rdec, A) \
        VST1.P  A.S[0], 4(Renc) \
        VST1    A.S[0], (Rdec) \
        SUB     $4, Rdec, Rdec \

    #define loadCKey(R, Dst) \
        VLD1.P  4(R), Dst.S[0] \

    #define transformLPrime(Data) \
        VSHL    $13,  Data.S4, T0.S4 \
        VSRI    $19, Data.S4, T0.S4 \
        VSHL    $23, Data.S4, T1.S4 \
        VSRI    $9, Data.S4, T1.S4 \
        VEOR    T0.B16, T1.B16, T0.B16 \
        VEOR    T0.B16, Data.B16, Data.B16 \

    #define expandSubRound(A, B, C, D, Renc, Rdec) \
        loadCKey(R13, RK) \
        getXor(B, C, D, U0) \
        tableLookupX4() \
        transformLPrime(U0) \
        VEOR    U0.B16, A.B16, A.B16 \
        saveKeys(Renc, Rdec, A) \

    #define expandRound(Renc, Rdec) \
        expandSubRound(Z0, Z1, Z2, Z3, Renc, Rdec) \
        expandSubRound(Z1, Z2, Z3, Z0, Renc, Rdec) \
        expandSubRound(Z2, Z3, Z0, Z1, Renc, Rdec) \
        expandSubRound(Z3, Z0, Z1, Z2, Renc, Rdec) \

    loadSBox(R0)

	MOVD	mk+0(FP), R10
	MOVD	enc+8(FP), R11
	MOVD	dec+16(FP), R12
	MOVD    $CK<>(SB), R13

    ADD     $124, R12, R12

    VMOVI   $0x40, CONST.B16

    // load FKs into Yx
    MOVD    $FK<>(SB), R1
    VLD1    (R1), [Y0.S4]

    VLD1    (R10), [Z0.S4]
    VREV32  Z0.B16, Z0.B16

    VEOR    Y0.B16, Z0.B16, Z0.B16

    VMOV    Z0.S[1], Z1.S[0]
    VMOV    Z0.S[2], Z2.S[0]
    VMOV    Z0.S[3], Z3.S[0]

    expandRound(R11, R12)
    expandRound(R11, R12)
    expandRound(R11, R12)
    expandRound(R11, R12)
    expandRound(R11, R12)
    expandRound(R11, R12)
    expandRound(R11, R12)
    expandRound(R11, R12)

    RET

//func cryptoBlockAsm(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsm(SB),NOSPLIT,$0-24

    #define loadInputX1(R) \
        VLD1.P  4(R), Z0.S[0] \
        VLD1.P  4(R), Z1.S[0] \
        VLD1.P  4(R), Z2.S[0] \
        VLD1.P  4(R), Z3.S[0] \
        revZ() \

    #define storeOutputX1(R) \
        revZ() \
        VST1.P  Z3.S[0], 4(R) \
        VST1.P  Z2.S[0], 4(R) \
        VST1.P  Z1.S[0], 4(R) \
        VST1.P  Z0.S[0], 4(R) \

    #define loadRoundKeyX1(R) \
        VLD1.P  4(R), RK.S[0] \

    #define round(R) \
        loadRoundKeyX1(R) \
        subRoundX4(Z0, Z1, Z2, Z3) \
        loadRoundKeyX1(R) \
        subRoundX4(Z1, Z2, Z3, Z0) \
        loadRoundKeyX1(R) \
        subRoundX4(Z2, Z3, Z0, Z1) \
        loadRoundKeyX1(R) \
        subRoundX4(Z3, Z0, Z1, Z2) \

    loadSBox(R0)

	MOVD	rk+0(FP), R10
	MOVD	dst+8(FP), R11
	MOVD	src+16(FP), R12

    VMOVI   $0x40, CONST.B16
    loadInputX1(R12)

    round(R10)
    round(R10)
    round(R10)
    round(R10)
    round(R10)
    round(R10)
    round(R10)
    round(R10)

    storeOutputX1(R11)
    RET

//func cryptoBlockAsmX2(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX2(SB),NOSPLIT,$0-24

    #define loadInputX2(R) \
        VLD1.P  4(R), Z0.S[0] \
        VLD1.P  4(R), Z1.S[0] \
        VLD1.P  4(R), Z2.S[0] \
        VLD1.P  4(R), Z3.S[0] \
        VLD1.P  4(R), Z0.S[1] \
        VLD1.P  4(R), Z1.S[1] \
        VLD1.P  4(R), Z2.S[1] \
        VLD1.P  4(R), Z3.S[1] \
        revZ() \

    #define storeOutputX2(R) \
        revZ() \
        VST1.P  Z3.S[0], 4(R) \
        VST1.P  Z2.S[0], 4(R) \
        VST1.P  Z1.S[0], 4(R) \
        VST1.P  Z0.S[0], 4(R) \
        VST1.P  Z3.S[1], 4(R) \
        VST1.P  Z2.S[1], 4(R) \
        VST1.P  Z1.S[1], 4(R) \
        VST1.P  Z0.S[1], 4(R) \

    #define loadRoundKeyX2(R) \
        VLD1.P  4(R), RK.S[0] \
        VDUP    RK.S[0], RK.S2 \

    #define roundX2(R) \
        loadRoundKeyX2(R) \
        subRoundX4(Z0, Z1, Z2, Z3) \
        loadRoundKeyX2(R) \
        subRoundX4(Z1, Z2, Z3, Z0) \
        loadRoundKeyX2(R) \
        subRoundX4(Z2, Z3, Z0, Z1) \
        loadRoundKeyX2(R) \
        subRoundX4(Z3, Z0, Z1, Z2) \

    loadSBox(R0)

	MOVD	rk+0(FP), R10
	MOVD	dst+8(FP), R11
	MOVD	src+16(FP), R12

    VMOVI   $0x40, CONST.B16
    loadInputX2(R12)

    roundX2(R10)
    roundX2(R10)
    roundX2(R10)
    roundX2(R10)
    roundX2(R10)
    roundX2(R10)
    roundX2(R10)
    roundX2(R10)

    storeOutputX2(R11)
    RET

#define loadRoundKeyX4(R) \
    VLD1.P  4(R), RK.S[0] \
    VDUP    RK.S[0], RK.S4 \

#define loadInputX8(R) \
    VLD4.P  64(R), [Z0.S4, Z1.S4, Z2.S4, Z3.S4] \
    VLD4.P  64(R), [Y0.S4, Y1.S4, Y2.S4, Y3.S4] \
    revZ() \
    revY() \

#define storeOutputX8(R) \
    revZ() \
    revY() \
    swap(Z0.B16, Z3.B16) \
    swap(Z1.B16, Z2.B16) \
    swap(Y0.B16, Y3.B16) \
    swap(Y1.B16, Y2.B16) \
    VST4.P  [Z0.S4, Z1.S4, Z2.S4, Z3.S4], 64(R) \
    VST4.P  [Y0.S4, Y1.S4, Y2.S4, Y3.S4], 64(R) \

//func cryptoBlockAsmX4(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX4(SB),NOSPLIT,$0-24

    #define loadInputX4(R) \
        VLD4    (R), [Z0.S4, Z1.S4, Z2.S4, Z3.S4] \
        revZ() \

    #define storeOutputX4(R) \
        revZ() \
        swap(Z0.B16, Z3.B16) \
        swap(Z1.B16, Z2.B16) \
        VST4    [Z0.S4, Z1.S4, Z2.S4, Z3.S4], (R) \

    #define roundX4(R) \
        loadRoundKeyX4(R) \
        subRoundX4(Z0, Z1, Z2, Z3) \
        loadRoundKeyX4(R) \
        subRoundX4(Z1, Z2, Z3, Z0) \
        loadRoundKeyX4(R) \
        subRoundX4(Z2, Z3, Z0, Z1) \
        loadRoundKeyX4(R) \
        subRoundX4(Z3, Z0, Z1, Z2) \

    loadSBox(R0)

	MOVD	rk+0(FP), R10
	MOVD	dst+8(FP), R11
	MOVD	src+16(FP), R12

    VMOVI   $0x40, CONST.B16
    loadInputX4(R12)

    roundX4(R10)
    roundX4(R10)
    roundX4(R10)
    roundX4(R10)
    roundX4(R10)
    roundX4(R10)
    roundX4(R10)
    roundX4(R10)

    storeOutputX4(R11)
    RET

//func cryptoBlockAsmX8(rk *uint32, dst, src *byte)
TEXT ·cryptoBlockAsmX8(SB),NOSPLIT,$0-24

    // lookup up to 8 data blocks
    // interleaved to hide the latency of TBL and TBX (partially)
    #define tableLookupX8() \
        VSUB    CONST.B16, U0.B16, U2.B16 \
        VTBL    U0.B16, [V16.B16, V17.B16, V18.B16, V19.B16], U0.B16 \
        VSUB    CONST.B16, U1.B16, U3.B16 \
        VTBL    U1.B16, [V16.B16, V17.B16, V18.B16, V19.B16], U1.B16 \
        VSUB    CONST.B16, U2.B16, T0.B16 \
        WORD    $0x4E007000 | 10<<16 | 20<<5 | 0x08 \
        VSUB    CONST.B16, U3.B16, T1.B16 \
        WORD    $0x4E007000 | 11<<16 | 20<<5 | 0x09 \
        VSUB    CONST.B16, T0.B16, U2.B16 \
        WORD    $0x4E007000 | 13<<16 | 24<<5 | 0x08 \
        VSUB    CONST.B16, T1.B16, U3.B16 \
        WORD    $0x4E007000 | 14<<16 | 24<<5 | 0x09 \
        WORD    $0x4E007000 | 10<<16 | 28<<5 | 0x08 \
        WORD    $0x4E007000 | 11<<16 | 28<<5 | 0x09 \

    #define subRoundX8(A, B, C, D, E, F, G, H) \
        getXor(B, C, D, U0) \
        getXor(F, G, H, U1) \
        tableLookupX8() \
        transformL(U0, U2) \
        transformL(U1, U3) \
        VEOR    U0.B16, A.B16, A.B16 \
        VEOR    U1.B16, E.B16, E.B16 \

    #define roundX8(R) \
        loadRoundKeyX4(R) \
        subRoundX8(Z0, Z1, Z2, Z3, Y0, Y1, Y2, Y3) \
        loadRoundKeyX4(R) \
        subRoundX8(Z1, Z2, Z3, Z0, Y1, Y2, Y3, Y0) \
        loadRoundKeyX4(R) \
        subRoundX8(Z2, Z3, Z0, Z1, Y2, Y3, Y0, Y1) \
        loadRoundKeyX4(R) \
        subRoundX8(Z3, Z0, Z1, Z2, Y3, Y0, Y1, Y2) \

    loadSBox(R0)

	MOVD	rk+0(FP), R10
	MOVD	dst+8(FP), R11
	MOVD	src+16(FP), R12

    VMOVI   $0x40, CONST.B16
    loadInputX8(R12)

    roundX8(R10)
    roundX8(R10)
    roundX8(R10)
    roundX8(R10)
    roundX8(R10)
    roundX8(R10)
    roundX8(R10)
    roundX8(R10)

    storeOutputX8(R11)
    RET

//func cryptoBlockAsmX16Internal(rk *uint32, dst, src, tmp *byte)
TEXT ·cryptoBlockAsmX16Internal(SB),NOSPLIT,$0-32

    #define stashZ(R) \
        VST1    [Z0.B16, Z1.B16, Z2.B16, Z3.B16], (R) \

    #define popZ(R) \
        VLD1    (R), [Z0.B16, Z1.B16, Z2.B16, Z3.B16] \

    #define stashY(R) \
        VST1    [Y0.B16, Y1.B16, Y2.B16, Y3.B16], (R) \

    #define popY(R) \
        VLD1    (R), [Y0.B16, Y1.B16, Y2.B16, Y3.B16] \

    #define loadInputX16(R, Rx) \
        loadInputX8(Rx) \
        stashZ(StashX) \
        stashY(StashW) \
        loadInputX8(R) \
        stashZ(StashZ) \
        stashY(StashY) \

    #define storeOutputX16(R) \
        storeOutputX8(R) \
        popZ(StashX) \
        popY(StashW) \
        storeOutputX8(R) \

    // lookup 16 data blocks
    // interleaved to hide the latency of TBL and TBX
    #define tableLookupX16() \
        \// 1st
        VSUB    CONST.B16, U0.B16, Z0.B16 \
        VTBL    U0.B16, [V16.B16, V17.B16, V18.B16, V19.B16], U0.B16 \
        VSUB    CONST.B16, U1.B16, Z1.B16 \
        VTBL    U1.B16, [V16.B16, V17.B16, V18.B16, V19.B16], U1.B16 \
        VSUB    CONST.B16, U2.B16, Y0.B16 \
        VTBL    U2.B16, [V16.B16, V17.B16, V18.B16, V19.B16], U2.B16 \
        VSUB    CONST.B16, U3.B16, Y1.B16 \
        VTBL    U3.B16, [V16.B16, V17.B16, V18.B16, V19.B16], U3.B16 \
        \// 2nd
        VSUB    CONST.B16, Z0.B16, Z2.B16 \
        WORD    $0x4E007000 | 0<<16 | 20<<5 | 0x08 \
        VSUB    CONST.B16, Z1.B16, Z3.B16 \
        WORD    $0x4E007000 | 1<<16 | 20<<5 | 0x09 \
        VSUB    CONST.B16, Y0.B16, Y2.B16 \
        WORD    $0x4E007000 | 4<<16 | 20<<5 | 0x0A \
        VSUB    CONST.B16, Y1.B16, Y3.B16 \
        WORD    $0x4E007000 | 5<<16 | 20<<5 | 0x0B \
        \// 3rd
        VSUB    CONST.B16, Z2.B16, Z0.B16 \
        WORD    $0x4E007000 | 2<<16 | 24<<5 | 0x08 \
        VSUB    CONST.B16, Z3.B16, Z1.B16 \
        WORD    $0x4E007000 | 3<<16 | 24<<5 | 0x09 \
        VSUB    CONST.B16, Y2.B16, Y0.B16 \
        WORD    $0x4E007000 | 6<<16 | 24<<5 | 0x0A \
        VSUB    CONST.B16, Y3.B16, Y1.B16 \
        WORD    $0x4E007000 | 7<<16 | 24<<5 | 0x0B \
        \// 4th
        WORD    $0x4E007000 | 0<<16 | 28<<5 | 0x08 \
        WORD    $0x4E007000 | 1<<16 | 28<<5 | 0x09 \
        WORD    $0x4E007000 | 4<<16 | 28<<5 | 0x0A \
        WORD    $0x4E007000 | 5<<16 | 28<<5 | 0x0B \

    #define subRoundX16(A, B, C, D, E, F, G, H) \
        getXor(B, C, D, U0) \
        getXor(F, G, H, U1) \
        popZ(StashX) \
        popY(StashW) \
        getXor(B, C, D, U2) \
        getXor(F, G, H, U3) \
        \// Then we can go with table lookup
        tableLookupX16() \
        \// And in-place transformation
        transformL(U0, Z0) \
        transformL(U1, Z1) \
        transformL(U2, Y0) \
        transformL(U3, Y1) \
        popZ(StashX) \ // TODO only load A
        popY(StashW) \ // TODO only load E
        VEOR U2.B16, A.B16, A.B16 \
        VEOR U3.B16, E.B16, E.B16 \
        stashZ(StashX) \ // TODO only save A
        stashY(StashW) \ // TODO only save E
        popZ(StashZ) \
        popY(StashY) \
        VEOR U0.B16, A.B16, A.B16 \
        VEOR U1.B16, E.B16, E.B16 \
        stashZ(StashZ) \ // TODO only save A
        stashY(StashY) \ // TODO only save E

    #define roundX16(R) \
        loadRoundKeyX4(R) \
        subRoundX16(Z0, Z1, Z2, Z3, Y0, Y1, Y2, Y3) \
        loadRoundKeyX4(R) \
        subRoundX16(Z1, Z2, Z3, Z0, Y1, Y2, Y3, Y0) \
        loadRoundKeyX4(R) \
        subRoundX16(Z2, Z3, Z0, Z1, Y2, Y3, Y0, Y1) \
        loadRoundKeyX4(R) \
        subRoundX16(Z3, Z0, Z1, Z2, Y3, Y0, Y1, Y2) \

    loadSBox(R0)

	MOVD	rk+0(FP), R10
	MOVD	dst+8(FP), R11
	MOVD	src+16(FP), R12

	MOVD    tmp+24(FP), StashZ
    ADD     $64, StashZ, StashY
    ADD     $128, StashZ, StashX
    ADD     $192, StashZ, StashW

    ADD     $128, R12, R17

    VMOVI   $0x40, CONST.B16
    loadInputX16(R12, R17)

    roundX16(R10)
    roundX16(R10)
    roundX16(R10)
    roundX16(R10)
    roundX16(R10)
    roundX16(R10)
    roundX16(R10)
    roundX16(R10)

    storeOutputX16(R11)

    RET

