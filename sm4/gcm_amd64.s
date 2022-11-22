#include "textflag.h"

//********    EXPAND KEY related    ********

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

// pre- and post-inverse affine matrix
DATA PreAffineMatrix<>+0x00(SB)/8, $0x4c287db91a22505d
GLOBL PreAffineMatrix<>(SB), (NOPTR+RODATA), $8
DATA PostAffineMatrix<>+0x00(SB)/8, $0xf3ab34a974a6b589
GLOBL PostAffineMatrix<>(SB), (NOPTR+RODATA), $8

// pre- and post-inverse affine constant
#define PreAffineConstant 0b00111110
#define PostAffineConstant 0b11010011

//*********    GHASH related          ************
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

// R8~15, DI, SI, AX, BX, CX, DX: used as parameters or general purpose drafts
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

// the mask for saving round keys during key expansion
#define MASK           K1
#define MASK_Mov0_1    K1
#define MASK_Mov01_23  K2

// X/Y/Z 0~5 draft registers
#define T0x X0

#define T1x X1
#define T2x X2
#define T3x X3

#define T4x X4
#define U1x X4

#define T5x X5
#define U2x X5

#define T0y Y0
#define VyIdxH01     Y0

#define T1y Y1
#define T2y Y2
#define T3y Y3

#define T4y Y4
#define U1y Y4

#define T5y Y5
#define U2y Y5

#define T0z Z0

#define T1z Z1
#define VzIdxH23     Z1

#define T2z Z2
#define T3z Z3

#define T4z Z4
#define U1z Z4

#define T5z Z5
#define U2z Z5


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

//X/Y/Z 10 for J0 and some J_k
#define VxJ0    X10
#define VyJ0    Y10
#define VzJ0    Z10

//X/Y/Z 11 for CIPH_k(J0)
#define VxTMask X11
#define VzTMask Z11

// X/Y/Z 12  pre-inverse affine matrix
#define VxPreMatrix X12
#define VyPreMatrix Y12
#define VzPreMatrix Z12

// X/Y/Z 13  post-inverse affine matrix
#define VxPostMatrix X13
#define VyPostMatrix Y13
#define VzPostMatrix Z13

#define VxAdd1  X14
#define VyAdd1  Y14
#define VzAdd1  Z14

#define VzAdd2  Z15

#define VyAdd3  Y16
#define VzAdd3  Z16

// X/Y/Z 27 for round key
#define VxRoundKey   X27
#define VyRoundKey   Y27
#define VzRoundKey   Z27

//*********       GHASH related      ********//
//X/Y/Z 17  H
#define VxH          X17    //17
#define VyH          Y17
#define VzH          Z17

//X/Y/Z 18 Nonce/Additional Data/Data
#define VxDat        X18
#define VzDat        Z18

#define VxTag        X19
#define VzTag        Z19

// X/Y/X 20 for byte order shuffle
#define VxShuffle   X20
#define VyShuffle   Y20
#define VzShuffle   Z20

// X/Y/Z 21~23 masks
#define VxAndMask    X21
#define VxLowerMask  X22
#define VxHigherMask X23
//#define VxBSwapMask  X19

#define VyAndMask    Y21
#define VyLowerMask  Y22
#define VyHigherMask Y23
//#define VyBSwapMask  Y19

#define VzAndMask    Z21
#define VzLowerMask  Z22
#define VzHigherMask Z23
//#define VzBSwapMask  Z19

//reduce and mul related
#define VxHs         X24
#define VzHs         Z24

#define VxReduce     X25
#define VzReduce     Z25

#define VxLow        X26
#define VzLow        Z26

#define VxMid        X27

#define VzMid        Z27

#define VxHigh       X28
#define VzHigh       Z28

#define VxH4         X29
#define VyH4         Y29
#define VzH4         Z29

#define VzH4s        Z30

#define VzIdx        Z31

//consider at last *******
#define movv(V1, V2) \
    \//VPXORD V2, V2, V2 \
    \//VPADDD V2, V1, V2 \
    VMOVAPD V1, V2 \



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


#define setZero(V1) \
    VPXORD V1, V1, V1 \

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


// **************       related with rev        ***************
// related with reverse bytes
#define rev32(Const, R) \
    VPSHUFB     Const, R, R \ // AVX512F(512) or SSE2(128) or AVX2(256), latency 1, CPI 0.5(256)/1(128;512)

#define revStates(Const, S1, S2, S3, S4) \
    rev32(Const, S1) \
    rev32(Const, S2) \
    rev32(Const, S3) \
    rev32(Const, S4) \

#define rev64(reg,src,VxD)           \
    MOVQ        $Shuffle2<>(SB), reg \
    VMOVDQU32   (reg), T0x           \
    MOVQ         src, T1x            \
    VPSHUFB     T0x, T1x, VxD        \

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

//related with reverse bits  - load consts
#define loadMasks(tmp1,tmp2,tmp3) \
    MOVQ                $AND_MASK<>(SB), tmp1 \
    MOVQ                $LOWER_MASK<>(SB), tmp2 \
    MOVQ                $HIGHER_MASK<>(SB), tmp3 \
    VBROADCASTI32X4     (tmp1), VzAndMask \ // latency 8, CPI 0.5
    VBROADCASTI32X4     (tmp2), VzLowerMask \
    VBROADCASTI32X4     (tmp3), VzHigherMask \

//reverse bits
#define reverseBits(V, And, Higher, Lower, T0, T1) \
    VPSRLW      $4, V, T0 \ //AVX512BW
    VPANDD      V, And, T1 \ // the lower part
    VPANDD      T0, And, T0 \ // the higher part
    VPSHUFB     T1, Higher, T1 \
    VPSHUFB     T0, Lower, T0 \
    VPXORD      T0, T1, V \
    //VPSHUFB     VxBSwapMask, T0, V \

#define reverseBitsZ4(Vz1, Vz2, Vz3, Vz4) \
    reverseBits(Vz1, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz2, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz3, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    reverseBits(Vz4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \

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

#define loadCounterConstant(reg1, reg2, reg3)   \
    MOVQ        $Counter_Add1<>(SB), reg1  \
    MOVQ        $Counter_Add2<>(SB), reg2  \
    MOVQ        $Counter_Add3<>(SB), reg3  \
    VMOVDQU32   (reg1), VzAdd1   \ //VzAdd1:(1,2,3,4)
    VMOVDQU32   (reg2), VzAdd2   \ //VzAdd2: (4,4,4,4)
    VMOVDQU32   (reg3), VzAdd3   \ //VzAdd3: (2,2,2,2)

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

//load temp block
#define loadTmp(Src, V1) \
    VMOVDQU32   (Src), V1 \
    reverseBits(V1, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \

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

// **************       macro function related with CIPH        ***************
#define cryptoPrepare(reg1, reg2, reg3) \
    loadMasks(reg1, reg2, reg3) \
    loadShuffle512(reg1) \
    loadMatrix(VzPreMatrix, VzPostMatrix, reg1, reg2) \
    loadCounterConstant(reg1, reg2, reg3) \
    VPXORD VxState1, VxState1, VxState1 \

//load round key
#define loadRoundKey(R, RK) \
    MOVD    (R), X1 \
    ADDQ    $4, R \ //TODO replace by offsets to R
    VPBROADCASTD        X1, RK \ // latency is 3 for 256/512, 1 otherwise; CPI 1

#define loadRoundKeyX(R) \
    loadRoundKey(R, VxRoundKey) \

#define loadRoundKeyY(R) \
    loadRoundKey(R, VyRoundKey) \

#define loadRoundKeyZ(R) \
    loadRoundKey(R, VzRoundKey) \

//related with sub round calculation
#define getXorX(B, C, D, Dst) \
    getXor(B, C, D, Dst, T0x, T1x, VxRoundKey) \

#define getXorY(B, C, D, Dst) \
        getXor(B, C, D, Dst, T0y, T1y, VyRoundKey) \

#define getXorZ(B, C, D, Dst) \
    getXor(B, C, D, Dst, T0z, T1z, VzRoundKey) \

#define getXor(B, C, D, Dst, T0, T1, RK) \
    VPXORD  B, C, T0 \ // AVX512F+AVX512VL, latency 1, CPI 0.33(128;256)/0.5(512)
    VPXORD  D, T0, T1 \
    VPXORD  RK, T1, Dst \ // loading round key (running prior to this) costs some latency so move it last

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

#define roundXNew(R,VxS1, VxS4) \
    loadRoundKeyX(R) \
    subRoundX(VxS1, VxState2, VxState3, VxS4) \
    loadRoundKeyX(R) \
    subRoundX(VxState2, VxState3, VxS4, VxS1) \
    loadRoundKeyX(R) \
    subRoundX(VxState3, VxS4, VxS1, VxState2) \
    loadRoundKeyX(R) \
    subRoundX(VxS4, VxS1, VxState2, VxState3) \

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

//for 512-bit lanes,
//Suppose we have V1z=(a0, a1, -, -), and V2z=(b0,b1,-,-), we want to have V=(a0, a1, b0, b1)
#define concatenateY(V1y,V2y,V1z) \
    VMOVDQA64 V1y, T2y        \           //T2z = (a0, a1, 0, 0)
    VMOVDQA64 V2y, T3y         \     //T3z = (b0, b1, 0,0)
    VALIGND $8, T2z, T3z, T3z \  //T3z = (0,0, b0 b1)
    VPADDD T2z, T3z, V1z      \    //V1z = (a0, a1, b0, b1)

#define cryptoBlockAsmX16Macro(rk,dst, src, reg, hashFlag)  \
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

#define cryptoBlockAsmX8Macro(rk, dst, src, reg, hashFlag) \
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

#define cryptoBlockAsmX4Macro(rk, dst, src, reg, hashFlag)  \
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
    concatenateX(VxState4, VxState3,VxState2, VxState1,VzState4)  \   //the order, need judge
    VMOVDQU32   VzState4,    (dst) \
    CMPQ hashFlag, $0 \
    JE X4Done \
    MOVQ $4, reg \
    reverseBits(VzState4, VzAndMask, VzHigherMask, VzLowerMask, T0z, T1z) \
    gHashBlocksLoopBy4(reg,VzState4) \ //truncate VySt
X4Done:  \
    NOP  \

#define cryptoBlockAsmX2Macro(rk,dst, src, reg, hashFlag) \
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
    CMPQ hashFlag, $0 \
    JE X2Done \
    MOVQ $2, reg \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    reverseBits(VxState3, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg,VxState4) \
    gHashBlocksLoopBy1(reg,VxState3) \
X2Done:  \
    NOP  \

#define cryptoBlockAsmX1Macro(rk,dst,src,reg, hashFlag)    \
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
    CMPQ hashFlag, $0 \
    JE X1Done \
    MOVQ $1, reg \
    reverseBits(VxState4, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \
    gHashBlocksLoopBy1(reg,VxState4) \
X1Done: \
    NOP \

#define cryptoBlockAsmRemain(rk,dst,src,reg)    \
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

#define cryptoBlockAsmMacro(rk,VxIn, VxOut)  \
    rev32(VxShuffle, VxIn)   \ // latency hiden successfully   change later, move rev32 to register, save time for zero block
    transpose1x4(VxIn, VxState2, VxState3, VxOut, T0x, T1x)  \
    roundXNew(rk,VxIn,VxOut)  \
    roundXNew(rk,VxIn,VxOut)  \
    roundXNew(rk,VxIn,VxOut)  \
    roundXNew(rk,VxIn,VxOut)  \
    roundXNew(rk,VxIn,VxOut)  \
    roundXNew(rk,VxIn,VxOut)  \
    roundXNew(rk,VxIn,VxOut)  \
    roundXNew(rk,VxIn,VxOut)  \
    SUBQ $128, rk \
    transpose4x1(VxOut, VxState3, VxState2, VxIn, T0x, T1x) \
    rev32(VxShuffle, VxOut)  \

#define broadcastJ0() \  //broadcast VxJ0 to VzJ0
    VMOVDQA64 VxJ0, VxState1 \
    VMOVDQA64 VxJ0, VxState2 \
    VMOVDQA64 VxJ0, VxState3 \
    concatenateX(VxJ0, VxState1, VxState2, VxState3,VzJ0) \
    rev32(VzShuffle, VzJ0)  \  //rev32 only excutes once at the beginning

#define cryptoBlocksPrepare(reg1, reg2, reg3) \
    broadcastJ0() \  //VzJ0 = (VxJ0, VxJ0, VxJ0, VxJ0) and VxJ0 is in reverse order

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

//cryptoBlocksAsm(roundKeys *uint32, out []byte, in []byte, preCounter *byte, counter *byte, tmp *byte)
#define cryptoBlocksAsm(rk,dst,src,len,tmp,blockCount,reg1,reg2,reg3,hashFlag) \    //tmp include counter and tmp
    MOVL $0, blockCount \
    cryptoBlocksPrepare(reg1,reg2,reg3)   \  //now suppose const1,2,3 has in the right place
    CMPQ len, $64    \
    JL loopX2        \
loopX16:   \
    CMPQ len, $256  \
    JL loopX8   \
    fillCounterX16()   \
    cryptoBlockAsmX16Macro(rk,dst,src, reg1,hashFlag)   \
    ADDQ $256, dst   \
    ADDQ $256, src   \
    SUBQ $256, len   \
    JMP loopX16   \
loopX8:   \
    CMPQ len, $128   \
    JL loopX4   \
    fillCounterX8()  \
    cryptoBlockAsmX8Macro(rk, dst, src, reg1,hashFlag)  \
    ADDQ $128, dst   \
    ADDQ $128, src   \
    SUBQ $128, len   \
    JMP loopX8   \
loopX4:   \
    CMPQ len, $64  \
    JL loopX2  \
    fillCounterX4()   \
    cryptoBlockAsmX4Macro(rk, dst, src, reg1,hashFlag)   \
    ADDQ $64, dst   \
    ADDQ $64, src   \
    SUBQ $64, len  \
    JMP loopX4    \
loopX2:    \
    CMPQ len, $32   \
    JL loopX1    \
    fillCounterX2()   \
    cryptoBlockAsmX2Macro(rk, dst, src, reg1,hashFlag)   \
    ADDQ $32, dst   \
    ADDQ $32, src   \
    SUBQ $32, len    \
    JMP loopX2     \
loopX1:     \
    CMPQ len, $16  \
    JL loopX0   \
    fillCounterX1()   \
    cryptoBlockAsmX1Macro(rk, dst,src, reg1,hashFlag)  \
    ADDQ $16, dst   \
    ADDQ $16, src   \
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

// **************       macro function related with GHash        ***************
#define gHashPre(reg1,reg2,reg3) \
    reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  \
    gHashBlocksPre(reg1, reg2, reg3) \
    gHashBlocksLoopBy4Pre(reg1) \

#define gHashBlocksPre(reg1, reg2, reg3) \
	MOVQ	            $GCM_POLY<>(SB), reg3  \
	VBROADCASTI32X2     (reg3), VzReduce     \  // latency 3, CPI 1
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

// **************       macro function related with J0        ***************
#define makeCounterNew(VxD, src, reg) \
    MOVQ $0b0111, reg     \
    KMOVW reg, MASK       \
    VPXORD VxD, VxD, VxD  \
    VMOVDQU32 (src), MASK, VxD \
    VMOVAPD VxAdd1, T0x \
    PSLLDQ $3, T0x \
    VPADDD VxD, T0x, VxD   \

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

#define calculateJ0(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    setZero(VzJ0) \
    CMPQ nonceLen, $12 \
    JE branch1 \
    calculateJ0Branch2(nonce,nonceLen,blockCount,remain,tmp,reg1, reg2, reg3) \
    JMP endJ0 \
branch1: \
    makeCounterNew(VxJ0, nonce, remain) \
endJ0:  \
    movv(VxJ0, VxState1)   \ // J0 store in VxJ0, keep order -> fillCounter, reverse first (only once), then add number (in reverse order)
    NOP  \


// **************       macro function related with S        ***************
#define CalculateSPre(aData,aLen, blockCount, remain, tmp, reg1, reg2, reg3) \
    setZero(VxTag) \
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

#define CalculateSPost(tag, aLen, cLen, tmp, blockCount,tagSize, reg) \
    SHLQ $3, aLen \
    SHLQ $3, cLen  \
    rev64X2(blockCount,reg, aLen, cLen, VxDat)   \ //blockCount used as reg1
    reverseBits(VxDat, VxAndMask, VxHigherMask, VxLowerMask, T0x, T1x) \  //add for opt
    MOVQ $1, blockCount  \
    gHashBlocksLoopBy1(blockCount, VxDat) \
    cryptoBlocksEnd(tag,tmp,tagSize,blockCount) \


// **************       function related with expandKey       ***************
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

// **************       function related with CIPH       ***************
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

// **************       function related with gHash        ***************
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

// **************       help function for making convenience in test        ***************
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

//makeCounterNew(src *byte, dst *byte)
TEXT ·makeCounterNew(SB),NOSPLIT,$0-16
    MOVQ src+0(FP), AX
    MOVQ dst+8(FP), BX
    loadCounterConstant(CX, DX, SI)
    makeCounterNew(VxJ0, AX, DX)
    VMOVDQU32 VxJ0, (BX)
    RET

//func fillCounterX1(J0 *byte)
TEXT ·fillCounterX1(SB), NOSPLIT, $0-8
    loadCounterConstant(AX, BX, CX)
    MOVQ j0+0(FP), BX
    loadInputX1(BX, VxJ0)
    loadShuffle128(AX)
    rev32(VxShuffle, VxJ0)
    VPADDD VxJ0, VxAdd1, VxJ0
    storeOutputX1(VxJ0,BX)
    RET

TEXT ·fillCounterX4(SB), NOSPLIT, $0-8
    loadCounterConstant(AX, BX, CX)
    MOVQ j0+0(FP), BX
    loadInputX1(BX, VzJ0)
    loadShuffle512(AX)
    rev32(VzShuffle, VzJ0)
    VPADDD VzJ0, VzAdd1, VzJ0
    storeOutputX1(VzJ0,BX)
    RET


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

//func clearRight(dst *byte, len int)
TEXT ·clearRight(SB),NOSPLIT,$0-16
    MOVQ d+0(FP), AX
    MOVQ len+8(FP), BX
    clearRight(AX,BX,CX, DX)
    RET

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

// **************       help function for ensureCapcity        ***************
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


//func sealAsm(roundKeys *uint32, tagSize int, dst *byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte)
//temp:  H, TMask, J0, tag, counter, tmp, CNT-256, tmp-256
TEXT ·sealAsm(SB), NOSPLIT, $80-152    //change later
    cryptoPrepare(Reg1, Reg2, RegT3)   //Z26, Z16, Z17 is used to load constant

    MOVQ rk+0(FP), RK
    cryptoBlockAsmMacro(RK,VxState1, VxH) //H stored in VxH, keep order

    gHashPre(Reg1, Reg2, RegT3)

    MOVQ nonce+24(FP), Nonce
    MOVQ nonceLen+32(FP), NonceLen
    MOVQ tmp+96(FP), Tmp
    calculateJ0(Nonce,NonceLen,BlockCount2,Remain2,Tmp,Reg1, Reg2, RegT3)  //J0 store in VxJ0, keep order,  VxH reverse order

    cryptoBlockAsmMacro(RK,VxState1, VxTMask)

    MOVQ aData+72(FP), AData
    MOVQ aLen+80(FP), ALen
    CalculateSPre(AData,ALen, BlockCount1, Remain1, Tmp, Reg1, Reg2, RegT1) //GHash(A||0) is stored in VxTag and is reverseBits, VxH is also reversebits

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


//func openAsm(roundKeys *uint32, tagSize int,dst *byte, nonce []byte, ciphertext []byte, additionalData []byte, temp *byte) int
////temp: H, J0, TMask, expectedTag, tmp, Counter-256, TMP-256
//used registers: Enc, H, Nonce, Tmp, J0, TMask, Ciphertext, AdditionalData, Dst
TEXT ·openAsm(SB), NOSPLIT, $80-148
    MOVQ rk+0(FP), RK
    MOVQ tagSize+8(FP), TagSize
    MOVQ dst+16(FP), Dst
    MOVQ nonce+24(FP), Nonce
    MOVQ cipher+48(FP), Cipher
    MOVQ aData+72(FP), AData
    MOVQ tmp+96(FP), Tmp

    cryptoPrepare(Reg1, Reg2, RegT3)

    MOVQ rk+0(FP), RK
    cryptoBlockAsmMacro(RK,VxState1,VxH) //H stored in VxH, keep order

    gHashPre(Reg1, Reg2, RegT3)

    MOVQ nonce+24(FP), Nonce
    MOVQ nonceLen+32(FP), NonceLen
    MOVQ tmp+96(FP), Tmp
    calculateJ0(Nonce,NonceLen,BlockCount2,Remain2,Tmp,Reg1, Reg2, RegT3)  //J0 store in VxJ0, keep order,  VxH reverse order

    cryptoBlockAsmMacro(RK,VxState1,VxTMask)

    MOVQ aData+72(FP), AData
    MOVQ aLen+80(FP), ALen
    CalculateSPre(AData,ALen, BlockCount1, Remain1, Tmp, Reg1, Reg2, RegT1) //GHash(A||0) is stored in VxTag and is reverseBits, VxH is also reversebits

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
    ADDQ $48, ETag
    CalculateSPost(ETag, ALen, CipherLen, Tmp, BlockCount1, TagSize,Reg1)  //Tag is stored in ETag

    MOVQ tmp+96(FP), ETag
    ADDQ $48, ETag
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
    //ADDQ $48, Tmp
    MOVQ $0, HashFlag
    cryptoBlocksAsm(RK,Dst,Cipher,CipherLen,Tmp,BlockCount1,Reg1,Reg2,RegT2,HashFlag)

    JMP openDone

tagUnMatch:
    MOVQ $0x5A5A, ret1+104(FP)    //tag unmatch

openDone:
    RET

















