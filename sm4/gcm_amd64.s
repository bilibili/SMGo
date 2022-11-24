// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

// optimized partially based on the Intel document "Optimized Galois-Counter-Mode Implementation on Intel Architecture Processors"
// https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/communications-ia-galois-counter-mode-paper.pdf

#include "com_amd64.s"

//********        CIPH related      ********
DATA Counter_Add1<>+0x00(SB)/8, $0x0000000000000000
DATA Counter_Add1<>+0x08(SB)/8, $0x0000000100000000
DATA Counter_Add1<>+0x10(SB)/8, $0x0000000000000000
DATA Counter_Add1<>+0x18(SB)/8, $0x0000000200000000
DATA Counter_Add1<>+0x20(SB)/8, $0x0000000000000000
DATA Counter_Add1<>+0x28(SB)/8, $0x0000000300000000
DATA Counter_Add1<>+0x30(SB)/8, $0x0000000000000000
DATA Counter_Add1<>+0x38(SB)/8, $0x0000000400000000
GLOBL Counter_Add1<>(SB), (NOPTR+RODATA), $64

DATA Counter_Add2<>+0x00(SB)/8, $0x0000000000000000
DATA Counter_Add2<>+0x08(SB)/8, $0x0000000400000000
DATA Counter_Add2<>+0x10(SB)/8, $0x0000000000000000
DATA Counter_Add2<>+0x18(SB)/8, $0x0000000400000000
DATA Counter_Add2<>+0x20(SB)/8, $0x0000000000000000
DATA Counter_Add2<>+0x28(SB)/8, $0x0000000400000000
DATA Counter_Add2<>+0x30(SB)/8, $0x0000000000000000
DATA Counter_Add2<>+0x38(SB)/8, $0x0000000400000000
GLOBL Counter_Add2<>(SB), (NOPTR+RODATA), $64

DATA Counter_Add3<>+0x00(SB)/8, $0x0000000000000000
DATA Counter_Add3<>+0x08(SB)/8, $0x0000000200000000
DATA Counter_Add3<>+0x10(SB)/8, $0x0000000000000000
DATA Counter_Add3<>+0x18(SB)/8, $0x0000000200000000
DATA Counter_Add3<>+0x20(SB)/8, $0x0000000000000000
DATA Counter_Add3<>+0x28(SB)/8, $0x0000000200000000
DATA Counter_Add3<>+0x30(SB)/8, $0x0000000000000000
DATA Counter_Add3<>+0x38(SB)/8, $0x0000000200000000
GLOBL Counter_Add3<>(SB), (NOPTR+RODATA), $64

//********      Ghash related     ********
//rev64X2
DATA Shuffle1<>+0x00(SB)/1, $0x07
DATA Shuffle1<>+0x01(SB)/1, $0x06
DATA Shuffle1<>+0x02(SB)/1, $0x05
DATA Shuffle1<>+0x03(SB)/1, $0x04
DATA Shuffle1<>+0x04(SB)/1, $0x03
DATA Shuffle1<>+0x05(SB)/1, $0x02
DATA Shuffle1<>+0x06(SB)/1, $0x01
DATA Shuffle1<>+0x07(SB)/1, $0x00
DATA Shuffle1<>+0x08(SB)/1, $0x0f
DATA Shuffle1<>+0x09(SB)/1, $0x0e
DATA Shuffle1<>+0x0A(SB)/1, $0x0d
DATA Shuffle1<>+0x0B(SB)/1, $0x0c
DATA Shuffle1<>+0x0C(SB)/1, $0x0b
DATA Shuffle1<>+0x0D(SB)/1, $0x0a
DATA Shuffle1<>+0x0E(SB)/1, $0x09
DATA Shuffle1<>+0x0F(SB)/1, $0x08
GLOBL Shuffle1<>(SB), (NOPTR+RODATA), $16

//rev64 and rev64X2
DATA Shuffle2<>+0x00(SB)/1, $0x0f
DATA Shuffle2<>+0x01(SB)/1, $0x0e
DATA Shuffle2<>+0x02(SB)/1, $0x0d
DATA Shuffle2<>+0x03(SB)/1, $0x0c
DATA Shuffle2<>+0x04(SB)/1, $0x0b
DATA Shuffle2<>+0x05(SB)/1, $0x0a
DATA Shuffle2<>+0x06(SB)/1, $0x09
DATA Shuffle2<>+0x07(SB)/1, $0x08
DATA Shuffle2<>+0x08(SB)/1, $0x07
DATA Shuffle2<>+0x09(SB)/1, $0x06
DATA Shuffle2<>+0x0A(SB)/1, $0x05
DATA Shuffle2<>+0x0B(SB)/1, $0x04
DATA Shuffle2<>+0x0C(SB)/1, $0x03
DATA Shuffle2<>+0x0D(SB)/1, $0x02
DATA Shuffle2<>+0x0E(SB)/1, $0x01
DATA Shuffle2<>+0x0F(SB)/1, $0x00
GLOBL Shuffle2<>(SB), (NOPTR+RODATA), $16

//reversebits
DATA AND_MASK<>+0x00(SB)/4, $0x0f0f0f0f
DATA AND_MASK<>+0x04(SB)/4, $0x0f0f0f0f
DATA AND_MASK<>+0x08(SB)/4, $0x0f0f0f0f
DATA AND_MASK<>+0x0c(SB)/4, $0x0f0f0f0f
GLOBL AND_MASK<>(SB), (NOPTR+RODATA), $16

DATA LOWER_MASK<>+0x00(SB)/4, $0x0c040800
DATA LOWER_MASK<>+0x04(SB)/4, $0x0e060a02
DATA LOWER_MASK<>+0x08(SB)/4, $0x0d050901
DATA LOWER_MASK<>+0x0c(SB)/4, $0x0f070b03
GLOBL LOWER_MASK<>(SB), (NOPTR+RODATA), $16

//GHash
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

DATA GCM_POLY<>+0x00(SB)/8, $0x0000000000000087
DATA GCM_POLY<>+0x08(SB)/8, $0x0000000000000000
GLOBL GCM_POLY<>(SB), (NOPTR+RODATA), $16

// **************       Register allocation        ***************
//mask
#define MASK_Mov0_1    K1
#define MASK_Mov01_23  K2

//*********       CryptBlocks related      ********//
//X/Y/Z 14 for J0 and some J_k
#define VxJ0    X14
#define VyJ0    Y14
#define VzJ0    Z14

//X/Y/Z 15 for CIPH_k(J0)
#define VxTMask X15
#define VzTMask Z15

//add constants for fillCounter
#define VxAdd1  X16
#define VyAdd1  Y16
#define VzAdd1  Z16

#define VzAdd2  Z17

#define VyAdd3  Y18
#define VzAdd3  Z18

//*********       GHASH related      ********//
//X/Y/Z 19  H
#define VxH          X19
#define VyH          Y19
#define VzH          Z19

//X/Y/Z 20 Nonce/Additional Data/Data
#define VxDat        X20
#define VzDat        Z20

//result of GHash (usually)
#define VxTag        X21
#define VzTag        Z21

// X/Y/Z 22~24 masks (reverse bits related)
#define VxAndMask    X22
#define VxLowerMask  X23
#define VxHigherMask X24
//#define VxBSwapMask  X19

#define VyAndMask    Y22
#define VyLowerMask  Y23
#define VyHigherMask Y24
//#define VyBSwapMask  Y19

#define VzAndMask    Z22
#define VzLowerMask  Z23
#define VzHigherMask Z24
//#define VzBSwapMask  Z19

//reduce and mul related
#define VxHs         X25
#define VzHs         Z25

#define VxReduce     X26
#define VzReduce     Z26

#define VxLow        X27
#define VzLow        Z27

#define VxMid        X13
#define VzMid        Z13

#define VxHigh       X28
#define VzHigh       Z28

#define VxH4         X29
#define VyH4         Y29
#define VzH4         Z29

#define VzH4s        Z30

#define VzIdx        Z31

//repeated use of Y0,Z1,Z4,Z5
#define VyIdxH01     Y0
#define VzIdxH23     Z1
#define U1x X4
#define U1z Z4
#define U2x X5
#define U2z Z5


// **************       functions used frequently         ***************
//reverse bits
#define reverseBits(V, And, Higher, Lower, T0, T1) \
    VPSRLW      $4, V, T0 \ //AVX512BW
    VPANDD      V, And, T1 \ // the lower part
    VPANDD      T0, And, T0 \ // the higher part
    VPSHUFB     T1, Higher, T1 \
    VPSHUFB     T0, Lower, T0 \
    VPXORD      T0, T1, V \
    //VPSHUFB     VxBSwapMask, T0, V \

//load data with 4 blocks and store in VzDat
#define load4X(data) \
    VMOVDQU32   (data), VzDat \
    ADDQ        $64, data \
    reverseBits(VzDat, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \

//load data with 1 block and store in VxDat
#define load1X(data) \
    VMOVDQU32   (data), VxDat \
    ADDQ        $16, data \
    reverseBits(VxDat, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

// **************    functions related with  cryptoBlockAsm   ***************
#define loadRoundKeyNew(R, RK, reg1, reg2, reg3, reg4) \
    MOVD    (R),   reg1 \
    MOVD    4(R),  reg2 \
    MOVD    8(R),  reg3 \
    MOVD    12(R), reg4 \

#define loadRoundKeyXNew(R, reg1, reg2, reg3, reg4) \
    loadRoundKeyNew(R, VxRoundKey, reg1, reg2, reg3, reg4) \

#define loadRoundKeyYNew(R, reg1, reg2, reg3, reg4) \
    loadRoundKeyNew(R, VyRoundKey, reg1, reg2, reg3, reg4) \

#define loadRoundKeyZNew(R, reg1, reg2, reg3, reg4) \
    loadRoundKeyNew(R, VzRoundKey, reg1, reg2, reg3, reg4) \

#define roundXNew(R,VxS1, VxS4,reg1,reg2,reg3,reg4) \
    loadRoundKeyXNew(R,reg1,reg2,reg3,reg4) \
    VPBROADCASTD reg1, VxRoundKey \
    subRoundX(VxS1, VxState2, VxState3, VxS4) \
    VPBROADCASTD reg2, VxRoundKey \
    subRoundX(VxState2, VxState3, VxS4, VxS1) \
    VPBROADCASTD reg3, VxRoundKey \
    subRoundX(VxState3, VxS4, VxS1, VxState2) \
    VPBROADCASTD reg4, VxRoundKey \
    subRoundX(VxS4, VxS1, VxState2, VxState3) \
    ADDQ    $16, R \

#define roundYNew(R, reg1, reg2, reg3, reg4) \
    loadRoundKeyYNew(R,reg1, reg2, reg3, reg4) \
    VPBROADCASTD reg1, VyRoundKey \
    subRoundY(VyState1, VyState2, VyState3, VyState4) \
    VPBROADCASTD reg2, VyRoundKey \
    subRoundY(VyState2, VyState3, VyState4, VyState1) \
    VPBROADCASTD reg3, VyRoundKey \
    subRoundY(VyState3, VyState4, VyState1, VyState2) \
    VPBROADCASTD reg4, VyRoundKey \
    subRoundY(VyState4, VyState1, VyState2, VyState3) \
    ADDQ    $16, R \

#define roundZNew(R, reg1, reg2, reg3, reg4) \
    loadRoundKeyZNew(R, reg1, reg2, reg3, reg4) \
    VPBROADCASTD reg1, VzRoundKey \
    subRoundZ(VzState1, VzState2, VzState3, VzState4) \
    VPBROADCASTD reg2, VzRoundKey \
    subRoundZ(VzState2, VzState3, VzState4, VzState1) \
    VPBROADCASTD reg3, VzRoundKey \
    subRoundZ(VzState3, VzState4, VzState1, VzState2) \
    VPBROADCASTD reg4, VzRoundKey \
    subRoundZ(VzState4, VzState1, VzState2, VzState3) \
    ADDQ $16, R \

#define reverseBitsZ4(Vz1, Vz2, Vz3, Vz4) \
    reverseBits(Vz1, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz2, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz3, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \

#define cryptoBlockAsmX16Macro(rk,dst, src, reg, hashFlag, reg1, reg2, reg3, reg4)  \
    transpose4x4(VzState1, VzState2, VzState3, VzState4, T0z, T1z) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    roundZNew(rk, reg1, reg2, reg3, reg4) \
    SUBQ $128, rk \
    transpose4x4(VzState4, VzState3, VzState2, VzState1, T0z, T1z) \
    revStates(VzShuffle, VzState1, VzState2, VzState3, VzState4)   \
    xor256(dst,src, VzState4, VzState3, VzState2, VzState1) \
    CMPQ hashFlag, $0  \
    JE X16Done     \
    MOVQ $16, reg  \
    reverseBitsZ4(VzState4, VzState3, VzState2, VzState1) \
    gHashBlocksLoopBy4(reg,VzState4) \
    gHashBlocksLoopBy4(reg,VzState3) \
    gHashBlocksLoopBy4(reg,VzState2) \
    gHashBlocksLoopBy4(reg,VzState1) \
X16Done: \
    NOP \

//for 512-bit lanes,
//Suppose we have V1z=(a0, a1, -, -), and V2z=(b0,b1,-,-), we want to have V=(a0, a1, b0, b1)
#define concatenateY(V1y,V2y,V1z) \
    VMOVDQA64 V1y, T2y        \           //T2z = (a0, a1, 0, 0)
    VMOVDQA64 V2y, T3y         \     //T3z = (b0, b1, 0,0)
    VALIGND $8, T2z, T3z, T3z \  //T3z = (0,0, b0 b1)
    VPADDD T2z, T3z, V1z      \    //V1z = (a0, a1, b0, b1)

#define cryptoBlockAsmX8Macro(rk, dst, src, reg, hashFlag,reg1,reg2,reg3,reg4) \
    transpose4x4(VyState1, VyState2, VyState3, VyState4, T0y, T1y)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    roundYNew(rk,reg1,reg2,reg3,reg4)  \
    SUBQ $128, rk \
    transpose4x4(VyState4, VyState3, VyState2, VyState1, T0y, T1y) \
    revStates(VyShuffle, VyState1, VyState2, VyState3, VyState4)  \
    xor128(dst,src,VyState4,VyState3,VyState2,VyState1) \
    concatenateY(VyState4, VyState3, VzState4)  \
    concatenateY(VyState2, VyState1, VzState2)  \
    VMOVDQU32   VzState4,    (dst)  \
    VMOVDQU32   VzState2,    64(dst)  \
    CMPQ hashFlag, $0  \
    JE X8Done   \
    MOVQ $8, reg  \
    reverseBits(VzState4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(VzState2, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    gHashBlocksLoopBy4(reg,VzState4) \
    gHashBlocksLoopBy4(reg,VzState2) \ //truncate VySt
X8Done:   \
    NOP   \

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

#define cryptoBlockAsmX4Macro(rk, dst, src, reg, hashFlag, reg1,reg2,reg3,reg4)  \
    transpose4x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    SUBQ $128, rk  \
    transpose4x4(VxState4, VxState3, VxState2, VxState1, T0x, T1x)  \
    revStates(VxShuffle, VxState1, VxState2, VxState3, VxState4)    \
    xor64(dst, src, VxState4, VxState3, VxState2, VxState1)         \
    concatenateX(VxState4, VxState3,VxState2, VxState1,VzState4)  \   //the order, need judge
    VMOVDQU32   VzState4,    (dst) \
    CMPQ hashFlag, $0 \
    JE X4Done \
    MOVQ $4, reg \
    reverseBits(VzState4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    gHashBlocksLoopBy4(reg,VzState4) \ //truncate VySt
X4Done:  \
    NOP  \

#define cryptoBlockAsmX2Macro(rk,dst, src, reg, hashFlag,reg1,reg2,reg3,reg4) \
    transpose2x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    SUBQ $128, rk \
    transpose4x2(VxState4, VxState3, VxState2, VxState1, T0x, T1x)   \
    rev32(VxShuffle, VxState4)  \
    rev32(VxShuffle, VxState3)  \
    xor32(dst, src, VxState4, VxState3)   \
    CMPQ hashFlag, $0 \
    JE X2Done \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    reverseBits(VxState3, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    MOVQ $2, reg \
    gHashBlocksLoopBy1(reg,VxState4) \
    gHashBlocksLoopBy1(reg,VxState3) \
X2Done:  \
    NOP  \

#define cryptoBlockAsmX1Macro(rk,dst,src,reg, hashFlag,reg1,reg2,reg3,reg4)    \
    transpose1x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    SUBQ $128, rk \
    transpose4x1(VxState4, VxState3, VxState2, VxState1, T0x, T1x) \
    rev32(VxShuffle, VxState4)  \
    xor16(dst, src, VxState4) \
    CMPQ hashFlag, $0 \
    JE X1Done \
    MOVQ $1, reg \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg,VxState4) \
X1Done: \
    NOP \

#define cryptoBlockAsmRemain(rk,dst,src,reg,reg1,reg2,reg3,reg4)    \
    transpose1x4(VxState1, VxState2, VxState3, VxState4, T0x, T1x)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxState1,VxState4,reg1,reg2,reg3,reg4)  \
    SUBQ $128, rk \
    transpose4x1(VxState4, VxState3, VxState2, VxState1, T0x, T1x) \
    rev32(VxShuffle, VxState4)  \
    xor16(dst, src, VxState4) \

#define cryptoBlockAsmMacro(rk,VxIn, VxOut,reg1,reg2,reg3,reg4)  \
    rev32(VxShuffle, VxIn)   \ // latency hiden successfully   change later, move rev32 to register, save time for zero block
    transpose1x4(VxIn, VxState2, VxState3, VxOut, T0x, T1x)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    roundXNew(rk,VxIn,VxOut,reg1,reg2,reg3,reg4)  \
    SUBQ $128, rk \
    transpose4x1(VxOut, VxState3, VxState2, VxIn, T0x, T1x) \
    rev32(VxShuffle, VxOut)  \

// **************    functions related with  cryptoBlocksAsm   ***************
#define broadcastJ0() \  //broadcast VxJ0 to VzJ0
    VMOVDQA64 VxJ0, VxState1 \
    VMOVDQA64 VxJ0, VxState2 \
    VMOVDQA64 VxJ0, VxState3 \
    concatenateX(VxJ0, VxState1, VxState2, VxState3,VzJ0) \
    rev32(VzShuffle, VzJ0)  \  //rev32 only excutes once at the beginning

// after fillCounterX16, VzJ0_new = VzJ0_old + (16,16,16,16)
#define fillCounterX16() \
    VPADDD VzJ0, VzAdd1, VzState1 \      // + (1,2,3,4)
    VPADDD VzState1, VzAdd2, VzState2 \  // + (4,4,4,4)
    VPADDD VzState2, VzAdd2, VzState3 \  // + (4,4,4,4)
    VPADDD VzState3, VzAdd2, VzState4 \  // + (4,4,4,4)
    VPADDD VzAdd2, VzAdd2, T0z      \  // : (8,8,8,8)
    VPADDD T0z, T0z, T1z                \  // : (16,16,16,16)
    VPADDD VzJ0, T1z, VzJ0              \  // : +(16,16,16,16)

//after fillCounterX8, VyJ0_new = VyJ0_old + (8,8)
#define fillCounterX8() \
    VPADDD VyJ0, VyAdd1, VyState1 \      // + (1,2)
    VPADDD VyState1, VyAdd3, VyState2 \  // + (2,2)
    VPADDD VyState2, VyAdd3, VyState3 \  // + (2,2)
    VPADDD VyState3, VyAdd3, VyState4 \  // + (2,2)
    VPADDD VyAdd3, VyAdd3, T0y      \  // : (4,4)
    VPADDD T0y, T0y, T1y                \  // : (8,8)
    VPADDD VyJ0, T1y, VyJ0              \  // : +(8,8)

//after fillCounterX4, VxJ0_new = VxJ0_old + (4)
#define fillCounterX4() \
    VPADDD VxJ0, VxAdd1, VxState1 \     // + (1)
    VPADDD VxState1, VxAdd1, VxState2 \ // + (1)
    VPADDD VxState2, VxAdd1, VxState3 \ // + (1)
    VPADDD VxState3, VxAdd1, VxState4 \ // + (1)
    VMOVDQA64 VxState4, VxJ0 \            //: + (4)

//after fillCounterX2, VxJ0_new = VxJ0_old + (2)
#define fillCounterX2() \
    VPADDD VxJ0, VxAdd1, VxState1 \      // + (1)
    VPADDD VxState1, VxAdd1, VxState2 \  // + (1)
    VMOVDQA64 VxState2, VxJ0 \             // : + (2)

//after fillCounterX1, VxJ0_new = VxJ0_old + (1)
#define fillCounterX1() \
    VPADDD VxJ0, VxAdd1, VxState1 \     // + (1)
    VMOVDQA64 VxState1, VxJ0 \            // : + (1)

//clear right part
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

//copy *******
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

//cryptoBlocksAsm(roundKeys *uint32, out []byte, in []byte, preCounter *byte, counter *byte, tmp *byte)
#define cryptoBlocksAsm(rk,dst,src,len,tmp,blockCount,reg1,reg2,reg3,hashFlag) \    //tmp include counter and tmp
    MOVL $0, blockCount \
    broadcastJ0()   \  //now suppose const1,2,3 has in the right place
    CMPQ len, $64    \
    JL loopX2        \
loopX16:   \
    CMPQ len, $256  \
    JL loopX8   \
    fillCounterX16()   \
    cryptoBlockAsmX16Macro(rk,dst,src, reg1,hashFlag,reg1,reg2,reg3,blockCount)   \
    ADDQ $256, dst   \
    ADDQ $256, src   \
    SUBQ $256, len   \
    JMP loopX16   \
loopX8:   \
    CMPQ len, $128   \
    JL loopX4   \
    fillCounterX8()  \
    cryptoBlockAsmX8Macro(rk, dst, src, reg1,hashFlag,reg1,reg2,reg3,blockCount)  \
    ADDQ $128, dst   \
    ADDQ $128, src   \
    SUBQ $128, len   \
    JMP loopX8   \
loopX4:   \
    CMPQ len, $64  \
    JL loopX2  \
    fillCounterX4()   \
    cryptoBlockAsmX4Macro(rk, dst, src, reg1,hashFlag,reg1,reg2,reg3,blockCount)   \
    ADDQ $64, dst   \
    ADDQ $64, src   \
    SUBQ $64, len  \
    JMP loopX4    \
loopX2:    \
    CMPQ len, $32   \
    JL loopX1    \
    fillCounterX2()   \
    cryptoBlockAsmX2Macro(rk, dst, src, reg1,hashFlag,reg1,reg2,reg3,blockCount)   \
    ADDQ $32, dst   \
    ADDQ $32, src   \
    SUBQ $32, len    \
    JMP loopX2     \
loopX1:     \
    CMPQ len, $16  \
    JL loopX0   \
    fillCounterX1()   \
    cryptoBlockAsmX1Macro(rk, dst,src, reg1,hashFlag,reg1,reg2,reg3,blockCount)  \
    ADDQ $16, dst   \
    ADDQ $16, src   \
    SUBQ $16, len    \
    JMP loopX1   \
loopX0:    \
    CMPQ len, $0   \
    JLE cryptoBlocksDone     \
    fillCounterX1()   \
    cryptoBlockAsmRemain(rk,tmp,src,reg3,reg1,reg2,reg3,blockCount)  \
    clearRight(tmp,len,reg3,reg2) \
    MOVQ len, reg2 \
    copyAsm(dst,tmp,len,reg3)  \
    SUBQ reg2, tmp \
    CMPQ hashFlag, $0 \
    JE cryptoBlocksDone \
    MOVQ $1, reg3 \
    loadInputX1(tmp, VxState4) \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg3,VxState4) \
cryptoBlocksDone: \
    NOP \

#define cryptoBlocksEnd(tag, tmp,tagSize,blockCount) \
    gHashBlocksBlocksEnd(tag, tmp,tagSize,blockCount) \

// **************       functions related with GHash        ***************
#define loadMasks(tmp1,tmp2) \
    MOVQ                $AND_MASK<>(SB), tmp1 \
    MOVQ                $LOWER_MASK<>(SB), tmp2 \
    VBROADCASTI32X2     (tmp1), VzAndMask \ // latency 8, CPI 0.5
    VBROADCASTI32X4     (tmp2), VzLowerMask \
    VPSLLQ $4, VzLowerMask, VzHigherMask \

#define gHashBlocksPre(reg1, reg2, reg3) \
	MOVQ	            $GCM_POLY<>(SB), reg3  \
	VBROADCASTI32X2     (reg3), VzReduce     \  // latency 3, CPI 1
	VPSRLDQ     $8, VxH, VxHs      \
	VPXORD      VxH, VxHs, VxHs    \  //h^l in lower Hs

#define gHashBlocksLoopBy4Pre(reg1, reg2)  \
    MOVQ        $SHUFFLE_X_LANES<>(SB), reg1  \
    VMOVDQU32   (reg1), VzIdx   \
    MOVQ        $0b00001100, reg1  \
    MOVQ        $0b11110000, reg2  \
    KMOVW       reg1, MASK_Mov0_1   \
    KMOVW       reg2, MASK_Mov01_23  \
	mul(VxH, VxHs, VxH, VxLow, VxMid, VxHigh, T0x)   \
	reduce(U1x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)  \
	mul(VxH, VxHs, U1x, VxLow, VxMid, VxHigh, T0x)    \
	reduce(U2x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)  \
	mul(VxH, VxHs, U2x, VxLow, VxMid, VxHigh, T0x)   \
	reduce(VxH4, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)  \
	MOVQ        $MERGE_H01<>(SB), reg1  \
    MOVQ        $MERGE_H23<>(SB), reg2  \
    VMOVDQU32   (reg1), VyIdxH01  \
    VMOVDQU32   (reg2), VzIdxH23  \
	VPERMQ      U2y, VyIdxH01, MASK_Mov0_1, VyH4   \
	VPERMQ      VyH, VyIdxH01, MASK_Mov0_1, U1y    \
	VPERMQ      U1z, VzIdxH23, MASK_Mov01_23, VzH4 \
	VPSRLDQ     $8, VzH4, VzH4s     \
	VPXORD      VzH4, VzH4s, VzH4s  \ //h^l in lower Hs

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

#define gHashBlocksLoopBy1(count,data) \
	VPXORD     VxTag, data, data  \
	mul(VxH, VxHs, data, VxLow, VxMid, VxHigh, T0x)  \
	reduce(VxTag, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)   \
	SUBQ        $1, count   \

#define gHashBlocksLoopBy1New(count,data,VxOut) \
	VPXORD     VxOut, data, data  \
	mul(VxH, VxHs, data, VxLow, VxMid, VxHigh, T0x)  \
	reduce(VxOut, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)   \
	SUBQ        $1, count   \

#define gHashBlocksLoopBy4(count,data) \
	VPXORD     VzTag, data, data  \
	mul(VzH4, VzH4s, data, VzLow, VzMid, VzHigh, T0z)  \
	reduce(VzTag, VzReduce, VzLow, VzMid, VzHigh, T0z, T1z, T2z, T3z)  \
	VPERMQ      $0b01001110, VzTag, T0z   \ // begin with 0:1:2:3, then exchange 0 vs 1, 2 vs 3 of the 4 128 bit lanes. latency 3, CPI 1
	VPXORD      VzTag, T0z, T0z     \ // we have T0z: 0^1 : 0^1 : 2^3 : 2^3
	VPERMQ      T0z, VzIdx, T1z     \ // we have T1z: 2^3 : 0^1 : 2^3 : 2^3
	VPXORD      T0x, T1x, VxTag     \ // VzTag: 0^1^2^3 : 0: 0: 0 (the higher lanes are cleared automatically - X version has lower CPI)
	SUBQ        $4, count           \

#define gHashBlocksLoopBy4New(count,data, VxOut, VzOut) \
	VPXORD     VzOut, data, data  \
	mul(VzH4, VzH4s, data, VzLow, VzMid, VzHigh, T0z)  \
	reduce(VzOut, VzReduce, VzLow, VzMid, VzHigh, T0z, T1z, T2z, T3z)  \
	VPERMQ      $0b01001110, VzOut, T0z   \ // begin with 0:1:2:3, then exchange 0 vs 1, 2 vs 3 of the 4 128 bit lanes. latency 3, CPI 1
	VPXORD      VzOut, T0z, T0z     \ // we have T0z: 0^1 : 0^1 : 2^3 : 2^3
	VPERMQ      T0z, VzIdx, T1z     \ // we have T1z: 2^3 : 0^1 : 2^3 : 2^3
	VPXORD      T0x, T1x, VxOut     \ // VzOut: 0^1^2^3 : 0: 0: 0 (the higher lanes are cleared automatically - X version has lower CPI)
	SUBQ        $4, count           \

#define gHashBlocksBlocksEnd(tag,tmp,tagSize,reg) \
	reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  \
	VPXORD      VxTag, VxTMask, VxTag   \
	VMOVDQU32   VxTag, (tmp)   \
	copyAsm(tag,tmp,tagSize,reg)  \

#define gHashBlocksBlocksEndNew(tag,tmp,tagSize,reg,VxOut) \
	reverseBits(VxOut, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  \
	VPXORD      VxOut, VxTMask, VxOut   \
	VMOVDQU32   VxOut, (tmp)   \
	copyAsm(tag,tmp,tagSize,reg)  \

//func gHashBlocks(H *byte, tag *byte, data *byte, count int)
TEXT ·gHashBlocks(SB),NOSPLIT,$0-32
	MOVQ	    h+0(FP), AX
	MOVQ	    tag+8(FP), BX
	MOVQ	    data+16(FP), CX
	MOVQ        count+24(FP), DX

	// carefully hide the latency
	VMOVDQU32   (AX), VxH // latency 7, CPI 0.5
	VMOVDQU32   (BX), VxTag // higher lanes will be cleared automatically

	loadMasks(R8,R9)

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

// **************       functions related with calculating J0        ***************
//load temp block
#define loadTmp(Src, V1) \
    VMOVDQU32   (Src), V1 \
    reverseBits(V1, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

#define rev64(reg,src,VxD)           \
    MOVQ        $Shuffle2<>(SB), reg \
    MOVQ         src, T1x            \
    VMOVDQU32   (reg), T0x           \
    VPSHUFB     T0x, T1x, VxD        \

#define calculateJ0Branch2(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    MOVQ nonceLen, blockCount \
    MOVQ nonceLen, remain    \
    ANDQ $15, remain     \
    SHRQ $4, blockCount \
    CMPQ nonceLen, $16  \
    JL last    \
    CMPQ blockCount, $8 \
    JL loopBy1 \
    loopBy4:         \
    load4X(nonce) \
    gHashBlocksLoopBy4New(blockCount, VzDat,VxJ0,VzJ0) \
    CMPQ        blockCount, $3    \
    JG          loopBy4      \
    CMPQ        blockCount, $0    \
    JE          last    \
    loopBy1:  \
    load1X(nonce)  \
    gHashBlocksLoopBy1New(blockCount, VxDat,VxJ0) \
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
    loadTmp(tmp, VxDat) \
    MOVQ $1, blockCount   \
    gHashBlocksLoopBy1New(blockCount, VxDat,VxJ0) \
    doneJ0:   \
    SHLQ $3, nonceLen  \
    rev64(reg1,nonceLen,VxDat)  \
    reverseBits(VxDat, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    MOVQ $1, blockCount  \
    gHashBlocksLoopBy1New(blockCount, VxDat,VxJ0) \
    reverseBits(VxJ0, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x) \

#define makeCounterNew(VxD, src, reg) \
    MOVQ $0b0111, reg     \
    KMOVW reg, MASK       \
    VPXORD VxD, VxD, VxD  \
    VMOVDQU32 (src), MASK, VxD \
    VMOVAPD VxAdd1, T0x \
    PSLLDQ $3, T0x \
    VPADDD VxD, T0x, VxD   \

#define calculateJ0(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    VPXORD VzJ0, VzJ0, VzJ0 \
    CMPQ nonceLen, $12 \
    JE branch1 \
    calculateJ0Branch2(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    JMP endJ0 \
branch1: \
    makeCounterNew(VxJ0, nonce, remain) \
endJ0:  \
    VMOVAPD VxJ0, VxState1 \
    NOP  \

// **************       functions related with calculating S        ***************
#define CalculateSPre(aData,aLen, blockCount, remain, tmp, reg1, reg2, reg3) \
    VPXORD VxTag, VxTag, VxTag \
    MOVQ aLen, blockCount   \
    MOVQ aLen, remain    \
    ANDQ $15, remain     \
    SHRQ $4, blockCount \
    CMPQ aLen, $16 \
    JL withRemain \
    CMPQ blockCount, $8  \
    JL loopWith1  \
loopWith4:         \
    load4X(aData)  \
    gHashBlocksLoopBy4(blockCount, VzDat) \
    CMPQ        blockCount, $3    \
    JG          loopWith4      \
    CMPQ        blockCount, $0    \
    JE          withRemain    \
loopWith1:  \
    load1X(aData) \
    gHashBlocksLoopBy1(blockCount, VxDat) \
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
    load1X(tmp) \
    MOVQ $1, blockCount   \
    gHashBlocksLoopBy1(blockCount, VxDat) \
endSPre: \
    NOP  \

#define CalculateSMid(aData,aLen, blockCount, remain, tmp, reg1, reg2, reg3) \
    MOVQ aLen, blockCount   \
    MOVQ aLen, remain    \
    ANDQ $15, remain     \
    SHRQ $4, blockCount \
    CMPQ aLen, $16 \
    JL toRemain \
    CMPQ blockCount, $8  \
    JL loop1  \
loop4:         \
    load4X(aData) \
    gHashBlocksLoopBy4(blockCount, VzDat) \
    CMPQ        blockCount, $3    \
    JG          loop4      \
    CMPQ        blockCount, $0    \
    JE          toRemain    \
loop1:  \
    load1X(aData) \
    gHashBlocksLoopBy1(blockCount, VxDat) \
    CMPQ        blockCount, $0   \
    JG          loop1     \
toRemain:  \
    CMPQ remain, $0    \
    JE endSMid        \
    MOVQ remain, reg2 \
    MOVQ $0, (tmp) \
    MOVQ $0, 8(tmp) \
    copyAsm(tmp,aData,remain, reg1) \
    SUBQ reg2, tmp \
    load1X(tmp) \
    MOVQ $1, blockCount   \
    gHashBlocksLoopBy1(blockCount, VxDat) \
endSMid:
    NOP

#define rev64X2(reg1,reg2, src1, src2, VxD)  \
    MOVQ        $Shuffle1<>(SB), reg1 \
    MOVQ        $Shuffle2<>(SB), reg2 \
    VMOVDQU32   (reg1), T0x           \
    VMOVDQU32   (reg2), T1x           \
    MOVQ         src1, T2x            \
    MOVQ         src2, T3x           \
    MOVQ        $0x00ff, reg1         \
    KMOVW       reg1, MASK            \
    VPSHUFB     T1x, T3x, VxD         \    //VXD = 0..0 rev(src2)
    VPSHUFB     T0x, T2x, MASK, VxD   \

#define CalculateSPost(tag, aLen, cLen, tmp, blockCount,tagSize, reg) \
    SHLQ $3, aLen \
    SHLQ $3, cLen  \
    rev64X2(blockCount,reg, aLen, cLen, VxDat)   \ //blockCount used as reg1
    reverseBits(VxDat, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \  //add for opt
    MOVQ $1, blockCount  \
    gHashBlocksLoopBy1(blockCount, VxDat) \
    cryptoBlocksEnd(tag,tmp,tagSize,blockCount) \

// **************       SealAsm and OpenAsm        ***************
// R8~15, DI, SI, AX, BX, CX, DX: used as parameters or general purpose drafts
//sealAsm and openAsm
#define RK             R15
#define TagSize        R14
#define Dst            R13
#define Nonce          R12
#define NonceLen       R11

#define Plaintext      R10
#define Cipher         R10

#define PlainLen       R9
#define CipherLen      R9

#define AData          R8
#define ALen           DI

#define Tmp            SI

#define H              AX
#define ETag           AX
#define HashFlag       AX

#define J0             BX

#define BlockCount1    R12
#define BlockCount2    R10

#define Remain1        R11
#define Remain2        R9

#define Reg1           CX
#define Reg2           DX
#define RegT1          R13
#define RegT2          R11
#define RegT3          R8

//related with reverse bits  - load consts
#define loadCounterConstant(reg1, reg2, reg3)   \
    MOVQ        $Counter_Add1<>(SB), reg1  \
    MOVQ        $Counter_Add2<>(SB), reg2  \
    MOVQ        $Counter_Add3<>(SB), reg3  \
    VMOVDQU32   (reg1), VzAdd1   \ //VzAdd1:(1,2,3,4)
    VMOVDQU32   (reg2), VzAdd2   \ //VzAdd2: (4,4,4,4)
    VMOVDQU32   (reg3), VzAdd3   \ //VzAdd3: (2,2,2,2)

#define cryptoPrepare(reg1, reg2, reg3) \
    loadMasks(reg1, reg2) \
    loadShuffle512(reg1) \
    loadMatrix(VzPreMatrix, VzPostMatrix, reg1, reg2) \
    loadCounterConstant(reg1, reg2, reg3) \
    VPXORD VxState1, VxState1, VxState1 \

#define gHashPre(reg1,reg2,reg3) \
    reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  \
    gHashBlocksPre(reg1, reg2, reg3) \
    gHashBlocksLoopBy4Pre(reg1,reg2) \

//func sealAsm(roundKeys *uint32, tagSize int, dst *byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte)
//temp:  H, TMask, J0, tag, counter, tmp, CNT-256, tmp-256
TEXT ·sealAsm(SB), NOSPLIT, $0-104
    cryptoPrepare(Reg1, Reg2, RegT3)

    MOVQ rk+0(FP), RK
    cryptoBlockAsmMacro(RK,VxState1, VxH,Reg1,Reg2,RegT1,RegT2) //H stored in VxH

    gHashPre(Reg1, Reg2, RegT3)

    MOVQ nonce+24(FP), Nonce
    MOVQ nonceLen+32(FP), NonceLen
    MOVQ tmp+96(FP), Tmp
    calculateJ0(Nonce,NonceLen,BlockCount2,Remain2,Tmp,Reg1, Reg2, RegT3)  //J0 store in VxJ0

    cryptoBlockAsmMacro(RK,VxState1, VxTMask,Reg1,Reg2,RegT1,RegT2)

    MOVQ aData+72(FP), AData
    MOVQ aLen+80(FP), ALen
    CalculateSPre(AData,ALen, BlockCount1, Remain1, Tmp, Reg1, Reg2, RegT1) //GHash(A||0) is stored in VxTag

    MOVQ dst+16(FP), Dst
    MOVQ plaintext+48(FP), Plaintext
    MOVQ plainLen+56(FP), PlainLen
    MOVQ $1, HashFlag
    cryptoBlocksAsm(RK,Dst,Plaintext,PlainLen,Tmp,BlockCount1,Reg1,Reg2,RegT2, HashFlag)

    MOVQ dst+16(FP), Dst
    MOVQ aLen+80(FP), ALen
    MOVQ plainLen+56(FP), PlainLen
    ADDQ PlainLen, Dst
    MOVQ tagSize+8(FP), TagSize
    MOVQ tmp+96(FP), Tmp
    CalculateSPost(Dst, ALen, PlainLen, Tmp, BlockCount1, TagSize,Reg1)  //Tag is stored in tag = &dst[len(plaintext)] plainLen = cipherLen

    RET

//func constantTimeCompareAsm(x *byte, y *byte, l int) int32. the result is in reg2
#define constantTimeCompare(x,y,l,reg1,reg2,reg3) \
    MOVQ $0, reg1   \
    MOVQ $0, reg2   \
 fastCmp:             \
    CMPQ l, $8       \
    JL slowCmp       \
    MOVQ 0(x), reg3  \
    XORQ reg3, 0(y)   \
    ORQ (y),reg1  \
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
cmpDone:             \
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

//func openAsm(roundKeys *uint32, tagSize int,dst *byte, nonce []byte, ciphertext []byte, additionalData []byte, temp *byte) int
////temp: H, J0, TMask, expectedTag, tmp, Counter-256, TMP-256
TEXT ·openAsm(SB), NOSPLIT, $0-112
    cryptoPrepare(Reg1, Reg2, RegT3)

    MOVQ rk+0(FP), RK
    cryptoBlockAsmMacro(RK,VxState1,VxH,Reg1,Reg2,RegT1,RegT2) //H stored in VxH

    gHashPre(Reg1, Reg2, RegT3)

    MOVQ nonce+24(FP), Nonce
    MOVQ nonceLen+32(FP), NonceLen
    MOVQ tmp+96(FP), Tmp
    calculateJ0(Nonce,NonceLen,BlockCount2,Remain2,Tmp,Reg1, Reg2, RegT3)  //J0 store in VxJ0

    cryptoBlockAsmMacro(RK,VxState1,VxTMask,Reg1,Reg2,RegT1,RegT2)

    MOVQ aData+72(FP), AData
    MOVQ aLen+80(FP), ALen
    CalculateSPre(AData,ALen, BlockCount1, Remain1, Tmp, Reg1, Reg2, RegT1) //GHash(A||0) is stored in VxTag

    MOVQ cipher+48(FP), Cipher
    MOVQ cipherLen+56(FP), CipherLen
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, CipherLen
    MOVQ tmp+96(FP), Tmp
    CalculateSMid(Cipher,CipherLen, BlockCount1, Remain1, Tmp, Reg1, Reg2, RegT1)

    MOVQ aLen+80(FP), ALen
    MOVQ cipherLen+56(FP), CipherLen
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, CipherLen
    MOVQ tmp+96(FP), Tmp
    MOVQ Tmp, ETag
    ADDQ $16, ETag
    CalculateSPost(ETag, ALen, CipherLen, Tmp, BlockCount1, TagSize,Reg1)  //Tag is stored in ETag

    MOVQ tmp+96(FP), ETag
    ADDQ $16, ETag
    MOVQ cipher+48(FP), Cipher
    MOVQ cipherLen+56(FP), CipherLen
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, CipherLen
    ADDQ CipherLen, Cipher
    constantTimeCompare(ETag, Cipher, TagSize,Reg1,Reg2,RegT1)

    CMPQ Reg2, $0
    JNE tagUnMatch
    MOVQ $0xA5A5, ret1+104(FP)

    MOVQ dst+16(FP), Dst
    MOVQ cipher+48(FP), Cipher
    MOVQ cipherLen+56(FP), CipherLen
    MOVQ tagSize+8(FP), TagSize
    SUBQ TagSize, CipherLen
    MOVQ tmp+96(FP), Tmp
    MOVQ $0, HashFlag
    cryptoBlocksAsm(RK,Dst,Cipher,CipherLen,Tmp,BlockCount1,Reg1,Reg2,RegT2,HashFlag)

    JMP openDone

tagUnMatch:
    MOVQ $0x5A5A, ret1+104(FP)    //tag unmatch

openDone:
    RET

















