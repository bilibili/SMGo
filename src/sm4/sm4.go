// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2011 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

package sm4

import (
	"crypto/cipher"
	"encoding/binary"
	"smgo/utils"
	"strconv"
)

type sm4Cipher struct {
	expandedKey [32]uint32
}

type KeySizeError int
func (k KeySizeError) Error() string {
	return "crypto/sm4: invalid key size " + strconv.Itoa(int(k))
}

func (sm4 *sm4Cipher) BlockSize() int {return blockSize}

func NewCipher(key []byte) (cipher.Block, error) {
	k := len(key)
	if k != blockSize {
		return nil, KeySizeError(k)
	}

	sm4 := new(sm4Cipher)
	expand(key, &sm4.expandedKey)
	return sm4, nil
}

func (sm4 *sm4Cipher) Encrypt(dst, src []byte) {
	crytoBlock(src, dst, &sm4.expandedKey, 1)
}

func (sm4 *sm4Cipher) Decrypt(dst, src []byte) {
	crytoBlock(src, dst, &sm4.expandedKey, 0)
}

func roundFunc(x0, x1, x2, x3, rk uint32) uint32 {return x0 ^ transT(x1 ^ x2 ^ x3 ^ rk)}
func transT(a uint32) uint32 {
	b := transTau(byte(a>>24), byte(a>>16), byte(a>>8), byte(a))
	return b ^ utils.RotateLeft(b, 2) ^utils.RotateLeft(b, 10) ^ utils.RotateLeft(b, 18) ^ utils.RotateLeft(b, 24)
}
func transTPrime(a uint32) uint32 {
	b := transTau(byte(a>>24), byte(a>>16), byte(a>>8), byte(a))
	return b ^ utils.RotateLeft(b, 13) ^ utils.RotateLeft(b, 23)
}

// FIXME constant time implementation for the sbox lookup
func transTau(a0, a1, a2, a3 byte) uint32 {
	b0, b1, b2, b3 := sbox[a0], sbox[a1], sbox[a2], sbox[a3]
	return uint32(b3) | uint32(b2)<<8 | uint32(b1)<<16 | uint32(b0)<<24
}

func crytoBlock(x, y []byte, rk *[32]uint32, encryption int) {
	if len(x) < blockSize {
		panic("crypto/sm4: input not full block")
	}
	if len(y) < blockSize {
		panic("crypto/sm4: output not full block")
	}

	var xx [36] uint32
	byte16ToUint32(x, xx[0:4])
	for i:=0; i<32; i++ {
		rkIdx := i * encryption + (31 - i) * (1 - encryption) // branching free trick
		xx[i+4] = roundFunc(xx[i], xx[i+1], xx[i+2], xx[i+3], rk[rkIdx])
	}
	binary.BigEndian.PutUint32(y[0:], xx[35])
	binary.BigEndian.PutUint32(y[4:], xx[34])
	binary.BigEndian.PutUint32(y[8:], xx[33])
	binary.BigEndian.PutUint32(y[12:], xx[32])
}
func expand(mk []byte, rk *[32]uint32) {
	var k [36]uint32
	var mks [4] uint32
	byte16ToUint32(mk[:], mks[:])
	k[0], k[1], k[2], k[3] = mks[0]^fk0, mks[1]^fk1, mks[2]^fk2, mks[3]^fk3
	for i := 0; i < 32; i++ {
		k[i+4] = k[i] ^ transTPrime(k[i+1]^k[i+2]^k[i+3]^ck[i])
		rk[i] = k[i+4]
	}
}
func byte16ToUint32(bytes []byte, uints []uint32) {
	for i := 0; i < 4; i++ {
		uints[i] = binary.BigEndian.Uint32(bytes[i*4 : i*4+4])
	}
}