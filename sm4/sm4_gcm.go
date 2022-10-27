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
	res := needExpandAsm(array, asked)
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

func fillCounter256(dst, src []byte, count uint32) {
	fillCounterX(&dst[0], &src[0], count, 16)
}

func fillCounter128(dst, src []byte, count uint32) {
	fillCounterX(&dst[0], &src[0], count, 8)
}

func fillCounter64(dst, src []byte, count uint32) {
	fillCounterX(&dst[0], &src[0], count, 4)
}

func fillCounter32(dst, src []byte, count uint32) {
	fillCounterX(&dst[0], &src[0], count, 2)
}

func fillCounter16(dst, src []byte, count uint32) {
	fillCounterX(&dst[0], &src[0], count, 1)
}

func fillSingleBlock(dst, src []byte, count uint32) {
	fillSingleBlockAsm(&dst[0],&src[0],count)
}

//go:noescape
func gHashBlocks(H *byte, tag *byte, data *byte, count int)

//go:noescape
func xor256(dst *byte, src1 *byte, src2 *byte)

//go:noescape
func xor128(dst *byte, src1 *byte, src2 *byte)

//go:noescape
func xor64(dst *byte, src1 *byte, src2 *byte)

//go:noescape
func xor32(dst *byte, src1 *byte, src2 *byte)

//go:noescape
func xor16(dst *byte, src1 *byte, src2 *byte)

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
func needExpandAsm(array []byte, asked int) int

//go:noescape
func sealAsm(roundKeys *uint32, tagSize int, dst []byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte) []byte

//go:noescape
func constantTimeCompareAsm(x *byte, y *byte, l int) int32

//go:noescape
func openAsm(roundKeys *uint32, tagSize int,dst []byte, nonce []byte, ciphertext []byte, additionalData []byte, temp *byte) ([]byte, int32)














