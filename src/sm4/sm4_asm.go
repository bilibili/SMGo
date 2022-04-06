// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64 || arm64

package sm4

import (
	"crypto/cipher"
	. "github.com/klauspost/cpuid/v2"
)

type sm4CipherAsm struct {
	sm4Cipher
}

// no other feature ID could be used to identify ARM64 so AESARM as representative
var candoAsm = CPU.Supports(AESARM) || (CPU.Supports(AVX512F) && CPU.Supports(AVX512DQ) && CPU.Supports(AVX512VL) && CPU.Supports(AVX) && CPU.Supports(GFNI) && CPU.Supports(SSE3) && CPU.Supports(SSE2) && CPU.Supports(VPCLMULQDQ))

func newCipher(key []byte) (cipher.Block, error) {
	if !candoAsm {
		return newCipherGeneric(key)
	}

	sm4 := sm4CipherAsm{}
	expandKeyAsm(&key[0], &sm4.enc[0], &sm4.dec[0])
	return &sm4, nil
}

func (sm4 *sm4CipherAsm) BlockSize() int { return blockSize }

//go:noescape
func expandKeyAsm(key *byte, enc, dec *uint32)

//go:noescape
func cryptoBlockAsm(rk *uint32, dst, src *byte)

//go:noescape
func cryptoBlockAsmX2(rk *uint32, dst, src *byte)

//go:noescape
func cryptoBlockAsmX4(rk *uint32, dst, src *byte)

//go:noescape
func cryptoBlockAsmX8(rk *uint32, dst, src *byte)

func (sm4 *sm4CipherAsm) Encrypt(dst, src []byte) {
	cryptoBlockAsm(&sm4.enc[0], &dst[0], &src[0])
}

func (sm4 *sm4CipherAsm) Decrypt(dst, src []byte) {
	cryptoBlockAsm(&sm4.dec[0], &dst[0], &src[0])
}

func (sm4 *sm4CipherAsm) encryptX4(dst, src []byte) {
	if len(src) < blockSize<<2 {
		panic("sm4: input not 4 full blocks")
	}
	if len(dst) < blockSize<<2 {
		panic("sm4: output not 4 full blocks")
	}
	cryptoBlockAsmX4(&sm4.enc[0], &dst[0], &src[0])
}

func (sm4 *sm4CipherAsm) decryptX4(dst, src []byte) {
	if len(src) < blockSize<<2 {
		panic("sm4: input not 4 full blocks")
	}
	if len(dst) < blockSize<<2 {
		panic("sm4: output not 4 full blocks")
	}
	cryptoBlockAsmX4(&sm4.dec[0], &dst[0], &src[0])
}
