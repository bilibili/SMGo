// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// method credited to Ard Biesheuve from Linaro, see https://www.linaro.org/blog/accelerated-aes-for-the-arm64-linux-kernel/
// ARM opcode refs: https://github.com/CAS-Atlantic/AArch64-Encoding

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

// again, optimize later
#define     t0  R2
#define     t1  R3
#define     t   R4
#define     z0  R5
#define     z1  R6
#define     z2  R7
#define     z3  R8
#define     rk0 R16
#define     rk1 R17
#define     rk2 R20
#define     rk3 R21

#define loadSBox(T) \
    MOVD    $SBox<>(SB), T \
    VLD1.P  64(T), [V16.B16, V17.B16, V18.B16, V19.B16] \
    VLD1.P  64(T), [V20.B16, V21.B16, V22.B16, V23.B16] \
    VLD1.P  64(T), [V24.B16, V25.B16, V26.B16, V27.B16] \
    VLD1.P  64(T), [V28.B16, V29.B16, V30.B16, V31.B16] \

#define loadInput(R) \
	LDPW    (R), (z0, z1) \
	LDPW    8(R), (z2, z3) \

#define storeOutput(R) \
    STPW    (z3, z2), (R) \
    STPW    (z1, z0), 8(R) \

#define loadRoundKey(idx, R) \
	LDPW    idx(R), (rk0, rk1) \
	LDPW    idx+8(R), (rk2, rk3) \
	REVW    rk0, rk0 \ //TODO this could be moved to key expansion
	REVW    rk1, rk1 \
	REVW    rk2, rk2 \
	REVW    rk3, rk3 \

#define getXor(B, C, D, RK) \
    EORW    B, C, t0 \
    EORW    D, RK, t1 \
    EORW    t0, t1, t \
    VMOV    t, V0.S[0] \

// use PMULL to implement the L transformation
#define transformL() \
    \//VPMULL   V0.D1, V1.D1, V2.Q1 \
    \//VMOV    V2.S[0], t0 \
    \//VMOV    V2.S[1], t1 \
    \//EOR     t0, t1, t \

#define lX1() \
    VMOV    V0.S[0], R0 \
    REVW    R0, R0 \
	RORW	$30, R0, R1 \
	RORW	$22, R0, R2 \
	EOR	R1, R2, R1 \
	RORW	$14, R0, R2 \
	RORW	$8, R0, R3 \
	EOR	R2, R3, R2 \
	EOR	R1, R0, R0 \
	EOR	R2, R0, t \
	REVW    t, t \

#define subRound(A, B, C, D, RK) \
    getXor(B, C, D, RK) \
    VMOVI   $0x40, V15.B16 \
    VSUB    V15.B16, V0.B16, V9.B16 \
    VTBL    V0.B16, [V16.B16, V17.B16, V18.B16, V19.B16], V0.B16 \ //WORD    $0x0E006000 | 0x00<<16 | 16<<5 | 0x00
    VSUB    V15.B16, V9.B16, V10.B16 \
    WORD    $0x0E007000 | 9<<16 | 20<<5 | 0x00 \ //VTBX1    V9.B16, [V20.B16, V21.B16, V22.B16, V23.B16], V0.B16 \
    VSUB    V15.B16, V10.B16, V11.B16 \
    WORD    $0x0E007000 | 10<<16 | 24<<5 | 0x00 \ //VTBX    V10.B16, [V24.B16, V25.B16, V26.B16, V27.B16], V0.B16 \
    WORD    $0x0E007000 | 11<<16 | 28<<5 | 0x00 \ //VTBX    V11.B16, [V28.B16, V29.B16, V30.B16, V31.B16], V0.B16 \
    lX1() \
    EORW    t, A, A \

#define round(A, B, C, D, IDX, R) \
    loadRoundKey(IDX, R) \
    subRound(A, B, C, D, rk0) \
    subRound(B, C, D, A, rk1) \
    subRound(C, D, A, B, rk2) \
    subRound(D, A, B, C, rk3) \

TEXT ·expandKeyAsm(SB),NOSPLIT,$0-16

    RET

//func encryptBlockAsm(rk *uint32, dst, src *byte)
TEXT ·encryptBlockAsm(SB),NOSPLIT,$0-24
    loadSBox(R9)

	MOVD	rk+0(FP), R10
	MOVD	dst+8(FP), R11
	MOVD	src+16(FP), R12

    loadInput(R12)

    round(z0, z1, z2, z3, 0, R10)
    round(z0, z1, z2, z3, 16, R10)
    round(z0, z1, z2, z3, 32, R10)
    round(z0, z1, z2, z3, 48, R10)
    round(z0, z1, z2, z3, 64, R10)
    round(z0, z1, z2, z3, 80, R10)
    round(z0, z1, z2, z3, 96, R10)
    round(z0, z1, z2, z3, 112, R10)

    storeOutput(R11)

    RET

TEXT ·decryptBlockAsm(SB),NOSPLIT,$0-24

    RET
