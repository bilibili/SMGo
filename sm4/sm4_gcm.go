// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64 || arm64

package sm4

import (
	"crypto/cipher"
	"errors"
)

const (
	gcmMinimumTagSize    = 12
	gcmStandardNonceSize = 12
)

type gcmAble interface {
	NewGCM(nonceSize, tagSize int) (cipher.AEAD, error)
}

func (sm4 *sm4CipherAsm) NewGCM(nonceSize, tagSize int) (cipher.AEAD, error) {
	g := &sm4GcmAsm{
		cipher:    sm4,
		roundKeys: sm4.enc[:],
		nonceSize: nonceSize,
		tagSize:   tagSize,
	}
	return g, nil
}

type sm4GcmAsm struct {
	cipher    cipher.Block
	roundKeys []uint32
	nonceSize int
	tagSize   int
}

func (g *sm4GcmAsm) Seal(dst, nonce, plaintext, additionalData []byte) []byte {
	if len(nonce) != g.nonceSize {
		panic("crypto/cipher: incorrect nonce length given to GCM")
	}
	if uint64(len(plaintext)) > ((1<<32)-2)*BlockSize {
		panic("crypto/cipher: message too large for GCM")
	}

	var temp [6*BlockSize+512] byte
	//temp:  H, TMask, J0, tag, counter, tmp, CNT-256, tmp-256
	ret := ensureCapacity(dst, len(plaintext)+g.tagSize)
	ret = sealAsm(&g.roundKeys[0], g.tagSize, ret, nonce, plaintext, additionalData, &temp[0])
	return ret
}

var errOpen = errors.New("cipher: message authentication failed")

func (g *sm4GcmAsm) Open(dst, nonce, ciphertext, additionalData []byte) ([]byte, error) {
	if len(nonce) != g.nonceSize {
		panic("crypto/cipher: incorrect nonce length given to GCM")
	}
	// Sanity check to prevent the authentication from always succeeding if an implementation
	// leaves tagSize uninitialized, for example.
	if g.tagSize < gcmMinimumTagSize {
		panic("crypto/cipher: incorrect GCM tag size")
	}

	if len(ciphertext) < g.tagSize {
		return nil, errOpen
	}
	if uint64(len(ciphertext)) > ((1<<32)-2)*BlockSize+uint64(g.tagSize) {
		return nil, errOpen
	}

	//temp: H, J0, TMask, expectedTag, tmp, Counter-256, TMP-256
	var temp [5*BlockSize+512] byte

	ret := ensureCapacity(dst, len(ciphertext)-g.tagSize)

	ret, flag:=openAsm(&g.roundKeys[0], g.tagSize,ret, nonce, ciphertext, additionalData, &temp[0])

	if flag!=0{
		return nil, errOpen
	}

	return ret, nil
}

func (g *sm4GcmAsm) NonceSize() int {
	return g.nonceSize
}

func (g *sm4GcmAsm) Overhead() int {
	return g.tagSize
}


func (g *sm4GcmAsm) calculateFirstCounter(nonce []byte, counter []byte, H []byte){
	var tmp [BlockSize]byte
	calculateFirstCounterAsm(nonce,&counter[0],&H[0],&tmp[0])
}


func ensureCapacity(array []byte, asked int) (head []byte) {
	res := needExpand(array, asked)
	arrayLen := len(array)
	if res == 0{
		head = array
	}else{
		head = make([]byte,arrayLen,arrayLen+asked)
		//head = make([]byte, arrayLen+asked)
		if arrayLen!=0 {
			copyAsm(&head[0], &array[0], arrayLen)
		}
	}
	return
}

func (g *sm4GcmAsm) gHashUpdate(H, tag, in []byte) {
	var tmp [BlockSize]byte
	gHashUpdateAsm(&H[0], &tag[0], in, &tmp[0])
}

func (g *sm4GcmAsm) gHashFinish(H, tag []byte, aadLen, plainLen uint64) { // length in bytes
	var tmp [BlockSize]byte
	gHashFinishAsm(&H[0], &tag[0], &tmp[0], aadLen, plainLen)

}

func (g *sm4GcmAsm) cryptoBlocks(roundKeys []uint32, out, in, preCounter []byte) {
	var counter, tmp [256]byte
	cryptoBlocksAsm(&roundKeys[0], out, in, &preCounter[0], &counter[0], &tmp[0])
}

//func fillCounter256(dst, src []byte, count uint32) {
//	fillCounterX(&dst[0], &src[0], count, 16)
//}
//
//func fillCounter128(dst, src []byte, count uint32) {
//	fillCounterX(&dst[0], &src[0], count, 8)
//}
//
//func fillCounter64(dst, src []byte, count uint32) {
//	fillCounterX(&dst[0], &src[0], count, 4)
//}
//
//func fillCounter32(dst, src []byte, count uint32) {
//	fillCounterX(&dst[0], &src[0], count, 2)
//}
//
//func fillCounter16(dst, src []byte, count uint32) {
//	fillCounterX(&dst[0], &src[0], count, 1)
//}

func fillSingleBlock(dst, src []byte, count uint32) {
	fillSingleBlockAsm(&dst[0],&src[0],count)
}

//go:noescape
func gHashBlocks(H *byte, tag *byte, data *byte, count int)

//go:noescape
func xor256(dst *byte, src1 *byte, src2 *byte)

//go:noescape
func xor128(dst *byte, src1 *byte, src2 *byte)

////go:noescape
//func xor64(dst *byte, src1 *byte, src2 *byte)

////go:noescape
//func xor32(dst *byte, src1 *byte, src2 *byte)

////go:noescape
//func xor16(dst *byte, src1 *byte, src2 *byte)

//go:noescape
func makeCounter(dst *byte, src *byte)

//go:noescape
func copy12(dst *byte, src *byte)

//go:noescape
func putUint32(b *byte, v uint32)

//go:noescape
func putUint64(b *byte, v uint64)

//go:noescape
func makeUint32(b *byte) uint32

//go:noescape
func fillSingleBlockAsm(dst *byte, src *byte, count uint32)

//go:noescape
func fillCounterX(dst *byte, src *byte, count uint32, blockNum uint32)

//go:noescape
func cryptoBlocksAsm(roundKeys *uint32, out []byte, in []byte, preCounter *byte, counter *byte, tmp *byte)

//go:noescape
func xorAsm(src1 *byte, src2 *byte, len int32, dst *byte)

//go:noescape
func calculateFirstCounterAsm(nonce []byte, counter *byte, H *byte, tmp *byte)

//go:noescape
func gHashUpdateAsm(H *byte, tag *byte, in []byte, tmp *byte)

//go:noescape
func gHashFinishAsm(H *byte, tag *byte, tmp *byte, aadLen uint64, plainLen uint64)

//go:noescape
func copyAsm(dst *byte, src *byte, len int)

//go:noescape
func needExpand(array []byte, asked int) int

//go:noescape
func sealAsm(roundKeys *uint32, tagSize int, dst []byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte) []byte

//go:noescape
func constantTimeCompareAsm(x *byte, y *byte, l int) int32

//go:noescape
func openAsm(roundKeys *uint32, tagSize int,dst []byte, nonce []byte, ciphertext []byte, additionalData []byte, temp *byte) ([]byte, int32)


////func putUint32(b *byte, v uint32)    --- used registers: DI, SI
//TEXT ·putUint32(SB),NOSPLIT,$0-16
//MOVQ b+0(FP), DI
//MOVL v+8(FP), SI
//MOVB SIB, 3(DI)
//SHRL $8, SI
//MOVB SIB, 2(DI)
//SHRL $8, SI
//MOVB SIB, 1(DI)
//SHRL $8, SI
//MOVB SIB, (DI)
//RET
//
////func putUint64(b *byte, v uint64)  --- used registers: SI, DI   why not SHRQ? this need test later
//TEXT ·putUint64(SB),NOSPLIT,$0-16
//MOVQ b+0(FP), DI
//MOVQ v+8(FP), SI
//MOVB SIB, 7(DI)
//SHRL $8, SI
//MOVB SIB, 6(DI)
//SHRL $8, SI
//MOVB SIB, 5(DI)
//SHRL $8, SI
//MOVB SIB, 4(DI)
//SHRL $8, SI
//MOVB SIB, 3(DI)
//SHRL $8, SI
//MOVB SIB, 2(DI)
//SHRL $8, SI
//MOVB SIB, 1(DI)
//SHRL $8, SI
//MOVB SIB, (DI)
//RET
//
////func makeUint32(b *byte) uint32  --- used registers: DI, SI
//TEXT ·makeUint32(SB),NOSPLIT,$0-16
//MOVQ b+0(FP), DI
//MOVB (DI), SIB
//SHLL $8, SI
//MOVB 1(DI), SIB
//SHLL $8, SI
//MOVB 2(DI), SIB
//SHLL $8, SI
//MOVB 3(DI), SIB
//MOVL SI, ret+8(FP)
//RET
//
////func fillSingleBlockAsm(dst *byte, src *byte, count uint32)  --- used registers: DI, SI,AX
//TEXT ·fillSingleBlockAsm(SB),NOSPLIT,$16-24
//MOVQ dst+0(FP), DI
//MOVQ src+8(FP), SI
//
//MOVQ DI, 0(SP)
//MOVQ SI, 0x8(SP)
//CALL ·copy12(SB)
//
//MOVQ 0(SP), DI
//MOVQ 0x8(SP), SI
//ADDQ $12, DI
//MOVQ DI, 0(SP)
//MOVL count+16(FP), AX
//MOVL AX, 0x8(SP)
//CALL ·putUint32(SB)
//RET

////func makeCounter(dst *byte, src *byte) --- used registers: DI, SI, AX
//TEXT ·makeCounter(SB),NOSPLIT,$0-16
//
//MOVQ   dst+0(FP), DI
//MOVQ   src+8(FP), SI
//MOVQ   0(SI),     AX
//MOVQ   AX,        0(DI)
//MOVL   8(SI),     AX
//MOVL   AX,         8(DI)
//MOVB   $1,        15(DI)
//RET
//
////func copy12(dst *byte, src *byte)     --- used registers: DI, SI, AX
//TEXT ·copy12(SB),NOSPLIT,$0-16
//MOVQ   dst+0(FP), DI
//MOVQ   src+8(FP), SI
//MOVQ   0(SI),     AX
//MOVQ   AX,        0(DI)
//MOVL   8(SI),     AX
//MOVL   AX,        8(DI)
//RET

////func copy12(dst *byte, src *byte)     --- used registers: DI, SI, AX
//TEXT ·copy12(SB),NOSPLIT,$0-16
//MOVQ   dst+0(FP), DI
//MOVQ   src+8(FP), SI
//MOVQ   0(SI),     AX
//MOVQ   AX,        0(DI)
//MOVL   8(SI),     AX
//MOVL   AX,        8(DI)
//RET

//TEXT ·xor16(SB),NOSPLIT,$0-24
//
//MOVQ    dst+0(FP), AX
//MOVQ    src1+8(FP), BX
//MOVQ    src2+16(FP), CX
//
//VMOVDQU32   (BX), X1
//VMOVDQU32   (CX), X2
//VPXORD      X1, X2, X0
//
//VMOVDQU32   X0, (AX)
//
//RET

//TEXT ·fillCounterX(SB), NOSPLIT, $40-24
//MOVQ src+8(FP), DI
//ADDQ $12, DI
//makeUint32(DI,SI)
//SUBQ $12, DI
//MOVL count+16(FP), AX
//ADDL SI, AX
//ADDL $1, AX
//MOVL blockNum+20(FP), BX
//MOVQ dst+0(FP), CX
//INCL BX
//
//start:
//DECL BX
//JZ done
//fillSingleBlockAsm(CX, DI, AX, DX)
////ADDQ $16, CX
//ADDL $1, AX
//JMP start
//
//done:
//RET

//TEXT ·xor32(SB),NOSPLIT,$0-24
//
//MOVQ    dst+0(FP), AX
//MOVQ    src1+8(FP), BX
//MOVQ    src2+16(FP), CX
//
//VMOVDQU32   (BX), Y1
//VMOVDQU32   (CX), Y2
//VPXORD      Y1, Y2, Y0
//
//VMOVDQU32   Y0, (AX)
//
//RET


////func xor64(dst *byte, src1 *byte, src2 *byte)
//TEXT ·xor64(SB),NOSPLIT,$0-24
//
//MOVQ    dst+0(FP), AX
//MOVQ    src1+8(FP), BX
//MOVQ    src2+16(FP), CX
//
//VMOVDQU32   (BX), Z1
//VMOVDQU32   (CX), Z2
//VPXORD      Z1, Z2, Z0
//
//VMOVDQU32   Z0, (AX)
//
//RET

//TEXT ·xor128(SB),NOSPLIT,$0-24
//
//MOVQ    dst+0(FP), AX
//MOVQ    src1+8(FP), BX
//MOVQ    src2+16(FP), CX
//
//VMOVDQU32   (BX), Z1
//VMOVDQU32   64(BX), Z4
//
//VMOVDQU32   (CX), Z2
//VMOVDQU32   64(CX), Z5
//
//VPXORD      Z1, Z2, Z0
//VPXORD      Z4, Z5, Z3
//
//VMOVDQU32   Z0, (AX)
//VMOVDQU32   Z3, 64(AX)
//
//RET

////func xor256(dst *byte, src1 *byte, src2 *byte)
//TEXT ·xor256(SB),NOSPLIT,$0-24
//
//MOVQ    dst+0(FP), AX
//MOVQ    src1+8(FP), BX
//MOVQ    src2+16(FP), CX
//
//VMOVDQU32   (BX), Z1
//VMOVDQU32   64(BX), Z4
//VMOVDQU32   128(BX), Z7
//VMOVDQU32   192(BX), Z10
//
//VMOVDQU32   (CX), Z2
//VMOVDQU32   64(CX), Z5
//VMOVDQU32   128(CX), Z8
//VMOVDQU32   192(CX), Z11
//
//VPXORD      Z1, Z2, Z0
//VPXORD      Z4, Z5, Z3
//VPXORD      Z7, Z8, Z6
//VPXORD      Z10, Z11, Z9
//
//VMOVDQU32   Z0, (AX)
//VMOVDQU32   Z3, 64(AX)
//VMOVDQU32   Z6, 128(AX)
//VMOVDQU32   Z9, 192(AX)
//
//RET

//#define gHashBlocks(H, tag, data, count,temp1,temp2)  \
//VMOVDQU32   (H), VxH     \
//VMOVDQU32   (tag), VxTag \
//loadMasks()              \
//MOVQ	            $GCM_POLY<>(SB), temp1   \
//VBROADCASTI32X2     (temp1), VzReduce        \
//reverseBits(VxH, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)   \
//reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)  \
//VPSRLDQ     $8, VxH, VxHs      \
//VPXORD      VxH, VxHs, VxHs    \
//CMPQ        count, $8           \
//JL          loopBy1             \
//MOVQ        $SHUFFLE_X_LANES<>(SB), temp1   \
//VMOVDQU32   (temp1), VzIcount               \
//MOVQ        $MERGE_H01<>(SB), temp1         \
//MOVQ        $MERGE_H23<>(SB), temp2         \
//VMOVDQU32   (temp1), VyIcountH01            \
//VMOVDQU32   (temp2), VzIcountH23            \
//MOVQ        $0b00001100, temp1              \
//MOVQ        $0b11110000, temp2              \
//KMOVW       temp1, MASK_Mov0_1              \
//KMOVW       temp2, MASK_Mov01_23            \
//mul(VxH, VxHs, VxH, VxLow, VxMid, VxHigh, T0x)  \
//reduce(U1x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x) \
//mul(VxH, VxHs, U1x, VxLow, VxMid, VxHigh, T0x)  \
//reduce(U2x, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x) \
//mul(VxH, VxHs, U2x, VxLow, VxMid, VxHigh, T0x)   \
//reduce(VxH4, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x) \
//VPERMQ      U2y, VyIcountH01, MASK_Mov0_1, VyH4      \
//VPERMQ      VyH, VyIcountH01, MASK_Mov0_1, U1y       \
//VPERMQ      U1z, VzIcountH23, MASK_Mov01_23, VzH4    \
//VPSRLDQ     $8, VzH4, VzH4s                          \
//VPXORD      VzH4, VzH4s, VzH4s                       \
//JMP loopBy4   \
//
//
//loopBy4:
//load4X()
//VPXORD     VzTag, VzDat, VzDat
//mul(VzH4, VzH4s, VzDat, VzLow, VzMid, VzHigh, T0z)
//reduce(VzTag, VzReduce, VzLow, VzMid, VzHigh, T0z, T1z, T2z, T3z)
//VPERMQ      $0b01001110, VzTag, T0z
//VPXORD      VzTag, T0z, T0z
//VPERMQ      T0z, VzIcount, T1z
//VPXORD      T0x, T1x, VxTag
//SUBQ        $4, count
//CMPQ        count, $3
//JG          loopBy4
//CMPQ        count, $0
//JE          blocksEnd
//JMP loopBy1
//
//
//loopBy1:
//load1X()
//VPXORD     VxTag, VxDat, VxDat
//mul(VxH, VxHs, VxDat, VxLow, VxMid, VxHigh, T0x)
//reduce(VxTag, VxReduce, VxLow, VxMid, VxHigh, T0x, T1x, T2x, T3x)
//SUBQ        $1, count
//CMPQ        count, $0
//JG          loopBy1
//JMP blocksEnd
//
//blocksEnd:
//reverseBits(VxTag, VxAndMask, VxHigherMask, VxLowerMask, T1x, T2x)
//VMOVDQU32   VxTag, (tag)
//


