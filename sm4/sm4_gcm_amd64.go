// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64

package sm4

func (g *sm4GcmAsm) Seal(dst, nonce, plaintext, additionalData []byte) []byte {
	if len(nonce) != g.nonceSize {
		panic("crypto/cipher: incorrect nonce length given to GCM")
	}
	if uint64(len(plaintext)) > ((1<<32)-2)*BlockSize {
		panic("crypto/cipher: message too large for GCM")
	}

	var temp [2*BlockSize] byte
	//temp:  H, TMask, J0, tag, counter, tmp, CNT-256, tmp-256
	ret := ensureCapacity(dst, len(plaintext)+g.tagSize)
	sealAsm(&g.roundKeys[0], g.tagSize, &ret[len(dst)], nonce, plaintext, additionalData, &temp[0])
	return ret
}

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
	var temp [2*BlockSize] byte

	ret := ensureCapacity(dst, len(ciphertext)-g.tagSize)

	var tagMatch int
	if ret != nil {
		tagMatch = openAsm(&g.roundKeys[0], g.tagSize,&ret[len(dst)], nonce, ciphertext, additionalData, &temp[0])
	}else{
		tagMatch = openAsm(&g.roundKeys[0], g.tagSize,nil, nonce, ciphertext, additionalData, &temp[0])
	}

	if tagMatch!=0x1 {
		return nil, errOpen
	}
	return ret, nil
}

func ensureCapacity(array []byte, asked int) (head []byte) {
	res := needExpand(array, asked)
	arrayLen := len(array)
	if res == 0{
		head = array
	}else{
		head = make([]byte,arrayLen+asked)
		if arrayLen!=0 {
			copyAsm(&head[0], &array[0], arrayLen)
		}
	}
	return
}

//go:noescape
func needExpand(array []byte, asked int) int

//go:noescape
func sealAsm(roundKeys *uint32, tagSize int, dst *byte, nonce []byte, plaintext []byte, additionalData []byte, temp *byte)

//go:noescape
func openAsm(roundKeys *uint32, tagSize int,dst *byte, nonce []byte, ciphertext []byte, additionalData []byte, temp *byte) int




