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
	crytoBlock(src, dst, &sm4.expandedKey, true)
}

func (sm4 *sm4Cipher) Decrypt(dst, src []byte) {
	crytoBlock(src, dst, &sm4.expandedKey, false)
}

func roundFunc(x0, x1, x2, x3, rk uint32) uint32 {return x0 ^ transform(x1 ^ x2 ^ x3 ^ rk, transL)}
func transform(a uint32, f func (uint32) uint32) uint32 {
	var aa [4]byte
	binary.BigEndian.PutUint32(aa[:], a)
	b0, b1, b2, b3 := transTau(aa[0], aa[1], aa[2], aa[3])
	b := binary.BigEndian.Uint32([]byte{b0, b1, b2, b3})
	return f(b)
}

// FIXME constant time implementation for the sbox lookup
func transTau(a0, a1, a2, a3 byte) (b0, b1, b2, b3 byte) {return sbox[a0], sbox[a1], sbox[a2], sbox[a3]}

func transL(b uint32) uint32 {return b ^ utils.RotateLeft(b, 2) ^utils.RotateLeft(b, 10) ^ utils.RotateLeft(b, 18) ^ utils.RotateLeft(b, 24)}
func transLPrime(b uint32) uint32 {return b ^ utils.RotateLeft(b, 13) ^ utils.RotateLeft(b, 23)}
func crytoBlock(x, y []byte, rk *[32]uint32, encryption bool) {
	if len(x) < blockSize {
		panic("crypto/sm4: input not full block")
	}
	if len(y) < blockSize {
		panic("crypto/sm4: output not full block")
	}

	var xx [36] uint32
	byte16ToUint32(x, xx[0:4])
	for i:=0; i<32; i++ {
		rkIdx := i
		if !encryption {
			rkIdx = 31 - i
		}
		xx[i+4] = roundFunc(xx[i], xx[i+1], xx[i+2], xx[i+3], rk[rkIdx])
		//fmt.Printf("K[%2d]: %8x\t", i+4, xx[i+4])
		//if (i+1)&7 == 0 {fmt.Println()}
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
		k[i+4] = k[i] ^ transform(k[i+1]^k[i+2]^k[i+3]^ck[i], transLPrime)
		rk[i] = k[i+4]
		//fmt.Printf("rk[%2d]: %8x\t", i, rk[i])
		//if (i+1)&7 == 0 {fmt.Println()}
	}
}
func byte16ToUint32(bytes []byte, uints []uint32) {
	for i := 0; i < 4; i++ {
		uints[i] = binary.BigEndian.Uint32(bytes[i*4 : i*4+4])
	}
}