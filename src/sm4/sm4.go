// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

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

	return newCipher(key)
}

func newCipherGeneric(key []byte) (cipher.Block, error) {
	sm4 := sm4Cipher{}
	expandKey(key, &sm4.expandedKey)
	return &sm4, nil
}

func (sm4 *sm4Cipher) Encrypt(dst, src []byte) {
	cryptoBlock(src[:blockSize], dst[:blockSize], &sm4.expandedKey, 1)
}

func (sm4 *sm4Cipher) Decrypt(dst, src []byte) {
	cryptoBlock(src[:blockSize], dst[:blockSize], &sm4.expandedKey, 0)
}

func encryptX2(sm4 *sm4Cipher, dst, src []byte) {
	cryptoBlockX2(src[:blockSize<<1], dst[:blockSize<<1], &sm4.expandedKey, 1)
}

func decryptX2(sm4 *sm4Cipher, dst, src []byte) {
	cryptoBlockX2(src[:blockSize<<1], dst[:blockSize<<1], &sm4.expandedKey, 0)
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

func cryptoBlock(x, y []byte, rk *[32]uint32, encryption int) {
	rkIdx := 31 * (1 - encryption) // branching free trick
	rkInc := encryption<<1 - 1
	var t uint32
	z0 := binary.BigEndian.Uint32(x[0:4])
	z1 := binary.BigEndian.Uint32(x[4:8])
	z2 := binary.BigEndian.Uint32(x[8:12])
	z3 := binary.BigEndian.Uint32(x[12:16])

	//for i:=0; i<8; i++ {
	//	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	//	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	//	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	//	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc
	//}
	// loop is unrolled for performance reasons (10+%).
	// To recover the looping, simply keep the top most 4 lines within the loop of 8 iterations.
	// 8 identical blocks of 4-liners below
	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	t = z1 ^ z2 ^ z3 ^ rk[rkIdx]; z0 ^= ss(t); rkIdx += rkInc
	t = z2 ^ z3 ^ rk[rkIdx] ^ z0; z1 ^= ss(t); rkIdx += rkInc
	t = z3 ^ rk[rkIdx] ^ z0 ^ z1; z2 ^= ss(t); rkIdx += rkInc
	t = rk[rkIdx] ^ z0 ^ z1 ^ z2; z3 ^= ss(t); rkIdx += rkInc

	// last statement could be saved but let's not spoil the beauty of the code
	// besides, compiler probably will do it anyway

	binary.BigEndian.PutUint32(y[0:4], z3)
	binary.BigEndian.PutUint32(y[4:8], z2)
	binary.BigEndian.PutUint32(y[8:12], z1)
	binary.BigEndian.PutUint32(y[12:16], z0)
}

func cryptoBlockX2(x, y []byte, rk *[32]uint32, encryption int) {
	rkIdx := 31 * (1 - encryption) // branching free trick
	rkInc := encryption<<1 - 1

	var z0, z1, z2, z3, t uint64


	z0 = uint64(binary.BigEndian.Uint32(x[0:4]))
	z1 = uint64(binary.BigEndian.Uint32(x[4:8]))
	z2 = uint64(binary.BigEndian.Uint32(x[8:12]))
	z3 = uint64(binary.BigEndian.Uint32(x[12:16]))

	z0 |= uint64(binary.BigEndian.Uint32(x[16:20]))<<32
	z1 |= uint64(binary.BigEndian.Uint32(x[4:8]))<<32
	z2 |= uint64(binary.BigEndian.Uint32(x[8:12]))<<32
	z3 |= uint64(binary.BigEndian.Uint32(x[12:16]))<<32


	for i:=0; i<8; i++ {
		k := uint64(rk[rkIdx])
		k |= k<<32
		t = z1 ^ z2 ^ z3 ^ k
		z0 ^= ssX2(t)
		rkIdx += rkInc

		k = uint64(rk[rkIdx])
		k |= k<<32
		t = z2 ^ z3 ^ k ^ z0
		z1 ^= ssX2(t)
		rkIdx += rkInc

		k = uint64(rk[rkIdx])
		k |= k<<32
		t = z3 ^ k ^ z0 ^ z1
		z2 ^= ssX2(t)
		rkIdx += rkInc

		k = uint64(rk[rkIdx])
		k |= k<<32
		t = k ^ z0 ^ z1 ^ z2
		z3 ^= ssX2(t)
		rkIdx += rkInc
	}

	binary.BigEndian.PutUint32(y[0:4], uint32(z3&0xffffffff))
	binary.BigEndian.PutUint32(y[4:8], uint32(z2&0xffffffff))
	binary.BigEndian.PutUint32(y[8:12], uint32(z1&0xffffffff))
	binary.BigEndian.PutUint32(y[12:16], uint32(z0&0xffffffff))

	binary.BigEndian.PutUint32(y[16:20], uint32(z3>>32))
	binary.BigEndian.PutUint32(y[20:24], uint32(z2>>32))
	binary.BigEndian.PutUint32(y[24:28], uint32(z1>>32))
	binary.BigEndian.PutUint32(y[28:32], uint32(z0>>32))
}


// using notation of GMT 0002-2012, in each round we need to compute
// L(b0 || b1 || b2 || b3)
// = L(sbox[a0] || sbox[a1] || sbox[a2] || sbox[a3])
// = L(sbox[a0]<<24 ^ sbox[a1]<<16 ^ sbox[a2]<<8 ^ sbox[a3]) (assuming type width is expanded automatically)
// = L(sbox[a0]<<24) ^ L(sbox[a1]<<16) ^ L(sbox[a2]<<8) ^ L(sbox[a3])
// we then put L(.<<24) into s0, L(.<<16) into s1, and so on.
// Generators are put into test function Test_DeriveSboxes
func ss(t uint32) uint32 {
	return s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]
}

func ssX2(t uint64) uint64 {
	lo := s0[0xff&(t>>24)] ^ s1[0xff&(t>>16)] ^ s2[0xff&(t>>8)] ^ s3[0xff&(t)]
	hi := s0[0xff&(t>>56)] ^ s1[0xff&(t>>48)] ^ s2[0xff&(t>>40)] ^ s3[0xff&(t>>32)]

	return uint64(hi)<<32 | uint64(lo)
}

func expandKey(mk []byte, rk *[32]uint32) {
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
		uints[i] = binary.BigEndian.Uint32(bytes[i<<2 : i<<2+4])
	}
}