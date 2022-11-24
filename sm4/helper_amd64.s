// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

#include "com_amd64.s"

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


//func copyAsm(dst *byte, src *byte, len int)
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
