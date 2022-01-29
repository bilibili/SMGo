// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2011 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

package sm4

import (
	"crypto/cipher"
	"encoding/binary"
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

// NewCipher security warning: this function is provided as part of cipher.Block spec.
// The expanded key could be left in heap memory after use, or copied around by GC or OS.
// Unfortunately *automatic* destroying the expanded key is rather complicated in Go.
// See https://github.com/golang/go/issues/18645
// Also see https://github.com/awnumar/memguard
func NewCipher(key []byte) (cipher.Block, error) {
	k := len(key)
	if k != blockSize {
		return nil, KeySizeError(k)
	}

	sm4 := new(sm4Cipher)
	keyExpansion(key, &sm4.expandedKey)
	return sm4, nil
}

func (sm4 *sm4Cipher) Encrypt(dst, src []byte) {
	crytoBlock(src[:blockSize], dst[:blockSize], &sm4.expandedKey, 1)
}

func (sm4 *sm4Cipher) Decrypt(dst, src []byte) {
	crytoBlock(src[:blockSize], dst[:blockSize], &sm4.expandedKey, 0)
}

//func transT(a uint32) uint32 {
//	b := tau(a)
//	return b ^ (b<<2 | b >>30) ^ (b<<10 | b>>22) ^ (b<<18 | b>>14) ^ (b<<24 | b>>8)
//}
func transTPrime(a uint32) uint32 {
	b := tau(a)
	return b ^ (b<<13 | b>>19) ^ (b<<23 | b>>9)
}

func tau(a uint32) uint32 {
	a0, a1, a2, a3 := 0xff&(a>>24), 0xff&(a>>16), 0xff&(a>>8), 0xff&(a)
	b0, b1, b2, b3 := sbox[a0], sbox[a1], sbox[a2], sbox[a3]
	return uint32(b0)<<24 | uint32(b1)<<16 | uint32(b2)<<8 | uint32(b3)
}

func crytoBlock(x, y []byte, rk *[32]uint32, encryption int) {
	rkIdx := 31 * (1 - encryption) // branching free trick
	rkInc := encryption<<1 - 1
	var t uint32
	var z [4]uint32
	z[0] = binary.BigEndian.Uint32(x[0:4])
	z[1] = binary.BigEndian.Uint32(x[4:8])
	z[2] = binary.BigEndian.Uint32(x[8:12])
	z[3] = binary.BigEndian.Uint32(x[12:16])

	// using notation of GMT 0002-2012, in each round we need to compute
	// L(b0 || b1 || b2 || b3)
	// = L(sbox[a0] || sbox[a1] || sbox[a2] || sbox[a3])
	// = L(sbox[a0]<<24 ^ sbox[a1]<<16 ^ sbox[a2]<<8 ^ sbox[a3]) (assuming type width is expanded automatically)
	// = L(sbox[a0]<<24) ^ L(sbox[a1]<<16) ^ L(sbox[a2]<<8) ^ L(sbox[a3])
	// we then put L(.<<24) into sbox0, L(.<<16) into sbox1, and so on.
	// Generators are put into test function Test_DeriveSboxes

	//for i:=0; i<8; i++ {
	// loop is unrolled for performance reasons (10+%). To recover the looping, simply keep the top most 4 lines within the loop of 8 iterations.
	//	t = xx[1] ^ xx[2] ^ xx[3] ^ rk[rkIdx]; xx[0] ^= sbox0[0xff&(t>>24)] ^ sbox1[0xff&(t>>16)] ^ sbox2[0xff&(t>>8)] ^ sbox3[0xff&(t)]; rkIdx += rkInc
	//	t = xx[2] ^ xx[3] ^ rk[rkIdx] ^ xx[0]; xx[1] ^= sbox0[0xff&(t>>24)] ^ sbox1[0xff&(t>>16)] ^ sbox2[0xff&(t>>8)] ^ sbox3[0xff&(t)]; rkIdx += rkInc
	//	t = xx[3] ^ rk[rkIdx] ^ xx[0] ^ xx[1]; xx[2] ^= sbox0[0xff&(t>>24)] ^ sbox1[0xff&(t>>16)] ^ sbox2[0xff&(t>>8)] ^ sbox3[0xff&(t)]; rkIdx += rkInc
	//	t = rk[rkIdx] ^ xx[0] ^ xx[1] ^ xx[2]; xx[3] ^= sbox0[0xff&(t>>24)] ^ sbox1[0xff&(t>>16)] ^ sbox2[0xff&(t>>8)] ^ sbox3[0xff&(t)]; rkIdx += rkInc
	//}
	// 8 identical blocks of 4-liners below
	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc

	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc

	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc

	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc

	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc

	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc

	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc

	t = z[1] ^ z[2] ^ z[3] ^ rk[rkIdx]; z[0] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[2] ^ z[3] ^ rk[rkIdx] ^ z[0]; z[1] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = z[3] ^ rk[rkIdx] ^ z[0] ^ z[1]; z[2] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	t = rk[rkIdx] ^ z[0] ^ z[1] ^ z[2]; z[3] ^= s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]; rkIdx += rkInc
	//}

	binary.BigEndian.PutUint32(y[0:4], z[3])
	binary.BigEndian.PutUint32(y[4:8], z[2])
	binary.BigEndian.PutUint32(y[8:12], z[1])
	binary.BigEndian.PutUint32(y[12:16], z[0])
}
func keyExpansion(mk []byte, rk *[32]uint32) {
	var k [36]uint32
	var mks [4] uint32
	byte16ToUint32(mk[:], mks[:])
	k[0], k[1], k[2], k[3] = mks[0]^fk0, mks[1]^fk1, mks[2]^fk2, mks[3]^fk3
	for i := 0; i < 32; i++ {
		// FIXME constant time implementation for the sbox lookup
		k[i+4] = k[i] ^ transTPrime(k[i+1]^k[i+2]^k[i+3]^ck[i])
		rk[i] = k[i+4]
	}
}
func byte16ToUint32(bytes []byte, uints []uint32) {
	for i := 0; i < 4; i++ {
		uints[i] = binary.BigEndian.Uint32(bytes[i<<2 : i<<2+4])
	}
}