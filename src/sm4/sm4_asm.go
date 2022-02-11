// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64 || arm64

package sm4

import (
	"crypto/cipher"
)

type sm4CipherAsm struct {
	sm4Cipher
}

//var supportsSM4 = CPU.Supports(SM4)
//var supportsAES = CPU.Supports(AESNI) || CPU.Supports(AESARM)
var supportsAES = false // let's worry about key expansion later FIXME

func newCipher(key []byte) (cipher.Block, error) {
	if !supportsAES {
		return newCipherGeneric(key)
	}

	sm4 := sm4CipherAsm{}
	expandKeyAsm(&key[0], &sm4.expandedKey[0])
	return &sm4, nil
}

func (sm4 *sm4CipherAsm) BlockSize() int {return blockSize}

//go:noescape
func expandKeyAsm(key *byte, rk *uint32)

//go:noescape
func encryptBlockAsm(rk *uint32, dst, src *byte)

//go:noescape
func decryptBlockAsm(rk *uint32, dst, src *byte)

func (sm4 *sm4CipherAsm) Encrypt(dst, src []byte) {
	if len(src) < blockSize {
		panic("sm4: input not full block")
	}
	if len(dst) < blockSize {
		panic("sm4: output not full block")
	}
	encryptBlockAsm(&sm4.expandedKey[0], &dst[0], &src[0])
}

func (sm4 *sm4CipherAsm) Decrypt(dst, src []byte) {
	if len(src) < blockSize {
		panic("sm4: input not full block")
	}
	if len(dst) < blockSize {
		panic("sm4: output not full block")
	}
	decryptBlockAsm(&sm4.expandedKey[0], &dst[0], &src[0])
}
