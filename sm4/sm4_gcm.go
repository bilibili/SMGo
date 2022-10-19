// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64 || arm64

package sm4

import (
	"crypto/cipher"
	"crypto/subtle"
	"encoding/binary"
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

	// using notations from NIST SP 800-38D, section 7.1
	var H, TMask, J0, tag [BlockSize]byte
	g.cipher.Encrypt(H[:], H[:])
	g.calculateFirstCounter(nonce, J0[:], H[:])
	g.cipher.Encrypt(TMask[:], J0[:])

	ret, out := ensureCapacity(dst, len(plaintext)+g.tagSize)
	g.cryptoBlocks(g.roundKeys, out, plaintext, J0[:])
	g.gHashUpdate(H[:], tag[:], additionalData)
	g.gHashUpdate(H[:], tag[:], out[:len(plaintext)])
	g.gHashFinish(H[:], tag[:], uint64(len(additionalData)), uint64(len(plaintext)))
	xor16(&tag[0], &tag[0], &TMask[0])
	copy(out[len(plaintext):], tag[:g.tagSize])

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

	tag := ciphertext[len(ciphertext)-g.tagSize:]
	ciphertext = ciphertext[:len(ciphertext)-g.tagSize]

	var H, J0, TMask [BlockSize]byte
	g.cipher.Encrypt(H[:], H[:])
	g.calculateFirstCounter(nonce, J0[:], H[:])
	g.cipher.Encrypt(TMask[:], J0[:])

	var expectedTag [BlockSize]byte
	g.gHashUpdate(H[:], expectedTag[:], additionalData)
	g.gHashUpdate(H[:], expectedTag[:], ciphertext)
	g.gHashFinish(H[:], expectedTag[:], uint64(len(additionalData)), uint64(len(ciphertext)))
	xor16(&expectedTag[0], &expectedTag[0], &TMask[0])

	if subtle.ConstantTimeCompare(expectedTag[:g.tagSize], tag) != 1 {
		return nil, errOpen
	}

	ret, out := ensureCapacity(dst, len(ciphertext))
	g.cryptoBlocks(g.roundKeys, out, ciphertext, J0[:])

	return ret, nil
}

func (g *sm4GcmAsm) NonceSize() int {
	return g.nonceSize
}

func (g *sm4GcmAsm) Overhead() int {
	return g.tagSize
}

/*func (g *sm4GcmAsm) calculateFirstCounter(nonce []byte, counter []byte, H []byte) {
	if len(nonce) == gcmStandardNonceSize {
		copy(counter[:], nonce)
		counter[BlockSize-1] = 1
	} else {
		g.gHashUpdate(H[:], counter[:], nonce)
		g.gHashFinish(H[:], counter[:], uint64(0), uint64(len(nonce)))
	}
}*/

func (g *sm4GcmAsm) calculateFirstCounter(nonce []byte, counter []byte, H []byte){
	if len(nonce) == gcmStandardNonceSize {
		makeCounter(&counter[0], &nonce[0])
	} else {
		g.gHashUpdate(H[:], counter[:], nonce)
		g.gHashFinish(H[:], counter[:], uint64(0), uint64(len(nonce)))
	}
}

/*func ensureCapacity(array []byte, asked int) (head, tail []byte) {
	remaining := cap(array) - len(array)
	if remaining >= asked {
		head = array
	} else {
		head = make([]byte, len(array)+asked)
		copy(head, array)
	}
	tail = head[len(array):]
	return
}*/

func ensureCapacity(array []byte, asked int) (head, tail []byte) {
	arrayLen := len(array)
	remaining := cap(array) - arrayLen
	if remaining >= asked {
		head = array
	} else {
		head = make([]byte, arrayLen+asked)
		copy(head, array)
	}
	tail = head[arrayLen:]
	return
}

func (g *sm4GcmAsm) gHashUpdate(H, tag, in []byte) {
	l := len(in)
	if l >= BlockSize {
		gHashBlocks(&H[0], &tag[0], &in[0], l>>4)
	}

	r := l & 15
	if r != 0 {
		var tmp [BlockSize]byte
		copy(tmp[:], in[l-r:]) // zero padding from right
		gHashBlocks(&H[0], &tag[0], &tmp[0], 1)
	}
}

func (g *sm4GcmAsm) gHashFinish(H, tag []byte, aadLen, plainLen uint64) { // length in bytes
	var tmp [BlockSize]byte
	binary.BigEndian.PutUint64(tmp[:8], aadLen<<3)
	binary.BigEndian.PutUint64(tmp[8:], plainLen<<3)

	gHashBlocks(&H[0], &tag[0], &tmp[0], 1) // length in bits
}

func (g *sm4GcmAsm) cryptoBlocks(roundKeys []uint32, out, in, preCounter []byte) {
	var counter, tmp [256]byte
	cryptoBlocksAsm(&roundKeys[0], &out[0], in, &preCounter[0], &counter[0], &tmp[0])

	//l := len(in)
	//remainder := l & 0x0f // if plaintext length is not of multiples of 16 bytes
	//blocks := l >> 4
	//
	//blocks256 := blocks >> 4
	//var blockCount uint32 = 0
	//for i := 0; i < blocks256; i++ {
	//	var counter, tmp [256]byte
	//	fillCounter256(counter[:], preCounter, blockCount)
	//	//out may overlap or reuse plaintext so use tmp here
	//	cryptoBlockAsmX16(&roundKeys[0], &tmp[0], &counter[0])
	//	xor256(&out[0], &tmp[0], &in[0])
	//	out = out[256:]
	//	in = in[256:]
	//	blockCount += 16
	//}
	//blocks -= int(blockCount)
	//
	//if blocks&8 != 0 {
	//	var counter, tmp [128]byte
	//	fillCounter128(counter[:], preCounter, blockCount)
	//	cryptoBlockAsmX8(&roundKeys[0], &tmp[0], &counter[0])
	//	xor128(&out[0], &tmp[0], &in[0])
	//	out = out[128:]
	//	in = in[128:]
	//	blockCount += 8
	//	blocks -= 8
	//}
	//
	//if blocks&4 != 0 {
	//	var counter, tmp [64]byte
	//	fillCounter64(counter[:], preCounter, blockCount)
	//	cryptoBlockAsmX4(&roundKeys[0], &tmp[0], &counter[0])
	//	xor64(&out[0], &tmp[0], &in[0])
	//	out = out[64:]
	//	in = in[64:]
	//	blockCount += 4
	//	blocks -= 4
	//}
	//
	//if blocks&2 != 0 {
	//	var counter, tmp [32]byte
	//	fillCounter32(counter[:], preCounter, blockCount)
	//	cryptoBlockAsmX2(&roundKeys[0], &tmp[0], &counter[0])
	//	xor32(&out[0], &tmp[0], &in[0])
	//	out = out[32:]
	//	in = in[32:]
	//	blockCount += 2
	//	blocks -= 2
	//}
	//
	//if blocks&1 != 0 {
	//	var counter, tmp [16]byte
	//	fillCounter16(counter[:], preCounter, blockCount)
	//	cryptoBlockAsm(&roundKeys[0], &tmp[0], &counter[0])
	//	xor16(&out[0], &tmp[0], &in[0])
	//	out = out[16:]
	//	in = in[16:]
	//	blockCount += 1
	//	blocks -= 1
	//}
	//
	//if remainder > 0 {
	//	var counter, tmp [16]byte
	//	fillCounter16(counter[:], preCounter, blockCount)
	//	cryptoBlockAsm(&roundKeys[0], &tmp[0], &counter[0])
	//	for i := 0; i < remainder; i++ {
	//		out[i] = tmp[i] ^ in[i]
	//	}
	//}
}

func fillCounter256(dst, src []byte, count uint32) {
	//c := binary.BigEndian.Uint32(src[12:]) + count + 1
	//fillSingleBlock(dst, src, c)
	//fillSingleBlock(dst[16:], src, c+1)
	//fillSingleBlock(dst[32:], src, c+2)
	//fillSingleBlock(dst[48:], src, c+3)
	//fillSingleBlock(dst[64:], src, c+4)
	//fillSingleBlock(dst[80:], src, c+5)
	//fillSingleBlock(dst[96:], src, c+6)
	//fillSingleBlock(dst[112:], src, c+7)
	//fillSingleBlock(dst[128:], src, c+8)
	//fillSingleBlock(dst[144:], src, c+9)
	//fillSingleBlock(dst[160:], src, c+10)
	//fillSingleBlock(dst[176:], src, c+11)
	//fillSingleBlock(dst[192:], src, c+12)
	//fillSingleBlock(dst[208:], src, c+13)
	//fillSingleBlock(dst[224:], src, c+14)
	//fillSingleBlock(dst[240:], src, c+15)
	fillCounterX(&dst[0], &src[0], count, 16)
}

func fillCounter128(dst, src []byte, count uint32) {
	//c := binary.BigEndian.Uint32(src[12:]) + count + 1
	//fillSingleBlock(dst, src, c)
	//fillSingleBlock(dst[16:], src, c+1)
	//fillSingleBlock(dst[32:], src, c+2)
	//fillSingleBlock(dst[48:], src, c+3)
	//fillSingleBlock(dst[64:], src, c+4)
	//fillSingleBlock(dst[80:], src, c+5)
	//fillSingleBlock(dst[96:], src, c+6)
	//fillSingleBlock(dst[112:], src, c+7)
	fillCounterX(&dst[0], &src[0], count, 8)
}

func fillCounter64(dst, src []byte, count uint32) {
	/*c := binary.BigEndian.Uint32(src[12:]) + count + 1
	fillSingleBlock(dst, src, c)
	fillSingleBlock(dst[16:], src, c+1)
	fillSingleBlock(dst[32:], src, c+2)
	fillSingleBlock(dst[48:], src, c+3)*/
	fillCounterX(&dst[0], &src[0], count, 4)
}

func fillCounter32(dst, src []byte, count uint32) {
	//c := binary.BigEndian.Uint32(src[12:]) + count + 1
	//fillSingleBlock(dst, src, c)
	//fillSingleBlock(dst[16:], src, c+1)
	fillCounterX(&dst[0], &src[0], count, 2)
}

func fillCounter16(dst, src []byte, count uint32) {
	///*c := binary.BigEndian.Uint32(src[12:]) + count + 1*/
	//c := makeUint32(&src[12]) + count + 1
	//fillSingleBlock(dst, src, c)
	fillCounterX(&dst[0], &src[0], count, 1)
}

func fillSingleBlock(dst, src []byte, count uint32) {
	/*copy12(&dst[0],&src[0])
	putUint32(&dst[12],count)*/
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
func makeUint32(b *byte) uint32

//go:noescape
func fillSingleBlockAsm(dst *byte, src *byte, count uint32)

//go:noescape
func fillCounterX(dst *byte, src *byte, count uint32, blockNum uint32)

//go:noescape
func cryptoBlocksAsm(roundKeys *uint32, out *byte, in []byte, preCounter *byte, counter *byte, tmp *byte)

//go:noescape
func xorAsm(src1 *byte, src2 *byte, len int32, dst *byte) int32
