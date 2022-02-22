// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

package sm4

import (
	"crypto/cipher"
	"encoding/binary"
	"strconv"
)

type sm4Cipher struct {
	enc [32]uint32
	dec [32]uint32
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
	expandKey(key, &sm4.enc, &sm4.dec)
	return &sm4, nil
}

func (sm4 *sm4Cipher) Encrypt(dst, src []byte) {
	cryptoBlock(src[:blockSize], dst[:blockSize], &sm4.enc)
}

func (sm4 *sm4Cipher) Decrypt(dst, src []byte) {
	cryptoBlock(src[:blockSize], dst[:blockSize], &sm4.dec)
}

func encryptX2(sm4 *sm4Cipher, dst, src []byte) {
	cryptoBlockX2(src[:blockSize<<1], dst[:blockSize<<1], &sm4.enc)
}

func decryptX2(sm4 *sm4Cipher, dst, src []byte) {
	cryptoBlockX2(src[:blockSize<<1], dst[:blockSize<<1], &sm4.dec)
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

func cryptoBlock(x, y []byte, rk *[32]uint32) {
	var t uint32
	z0 := binary.BigEndian.Uint32(x[0:4])
	z1 := binary.BigEndian.Uint32(x[4:8])
	z2 := binary.BigEndian.Uint32(x[8:12])
	z3 := binary.BigEndian.Uint32(x[12:16])

	//for i:=0; i<8; i++ {
	//	t = z1 ^ z2 ^ z3 ^ rk[i<<2  ]; z0 ^= ss(t)
	//	t = z2 ^ z3 ^ rk[i<<2+1] ^ z0; z1 ^= ss(t)
	//	t = z3 ^ rk[i<<2+2] ^ z0 ^ z1; z2 ^= ss(t)
	//	t = rk[i<<2+3] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)
	//}

	t = z1 ^ z2 ^ z3 ^ rk[0]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[1] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[2] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[3] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	t = z1 ^ z2 ^ z3 ^ rk[4]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[5] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[6] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[7] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	t = z1 ^ z2 ^ z3 ^ rk[8]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[9] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[10] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[11] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	t = z1 ^ z2 ^ z3 ^ rk[12]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[13] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[14] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[15] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	t = z1 ^ z2 ^ z3 ^ rk[16]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[17] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[18] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[19] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	t = z1 ^ z2 ^ z3 ^ rk[20]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[21] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[22] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[23] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	t = z1 ^ z2 ^ z3 ^ rk[24]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[25] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[26] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[27] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	t = z1 ^ z2 ^ z3 ^ rk[28]; z0 ^= ss(t)
	t = z2 ^ z3 ^ rk[29] ^ z0; z1 ^= ss(t)
	t = z3 ^ rk[30] ^ z0 ^ z1; z2 ^= ss(t)
	t = rk[31] ^ z0 ^ z1 ^ z2; z3 ^= ss(t)

	binary.BigEndian.PutUint32(y[0:4], z3)
	binary.BigEndian.PutUint32(y[4:8], z2)
	binary.BigEndian.PutUint32(y[8:12], z1)
	binary.BigEndian.PutUint32(y[12:16], z0)
}

func cryptoBlockX2(x, y []byte, rk *[32]uint32) {
	var z0, z1, z2, z3, t, k uint64

	z0 = uint64(binary.BigEndian.Uint32(x[0:4]))
	z1 = uint64(binary.BigEndian.Uint32(x[4:8]))
	z2 = uint64(binary.BigEndian.Uint32(x[8:12]))
	z3 = uint64(binary.BigEndian.Uint32(x[12:16]))

	z0 |= uint64(binary.BigEndian.Uint32(x[16:20]))<<32
	z1 |= uint64(binary.BigEndian.Uint32(x[20:24]))<<32
	z2 |= uint64(binary.BigEndian.Uint32(x[24:28]))<<32
	z3 |= uint64(binary.BigEndian.Uint32(x[28:32]))<<32

	//for i:=0; i<8; i++ {
	//	k = uint64(rk[i<<2  ]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	//	k = uint64(rk[i<<2+1]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	//	k = uint64(rk[i<<2+2]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	//	k = uint64(rk[i<<2+3]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)
	//}

	k = uint64(rk[0]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[1]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[2]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[3]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

	k = uint64(rk[4]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[5]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[6]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[7]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

	k = uint64(rk[8]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[9]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[10]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[11]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

	k = uint64(rk[12]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[13]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[14]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[15]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

	k = uint64(rk[16]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[17]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[18]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[19]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

	k = uint64(rk[20]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[21]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[22]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[23]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

	k = uint64(rk[24]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[25]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[26]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[27]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

	k = uint64(rk[28]); k |= k<<32; t = z1 ^ z2 ^ z3 ^ k; z0 ^= ssX2(t)
	k = uint64(rk[29]); k |= k<<32; t = z2 ^ z3 ^ k ^ z0; z1 ^= ssX2(t)
	k = uint64(rk[30]); k |= k<<32; t = z3 ^ k ^ z0 ^ z1; z2 ^= ssX2(t)
	k = uint64(rk[31]); k |= k<<32; t = k ^ z0 ^ z1 ^ z2; z3 ^= ssX2(t)

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

func expandKey(mk []byte, enc, dec *[32]uint32) {
	var k0, k1, k2, k3 uint32
	var mks [4] uint32
	byte16ToUint32(mk[:], mks[:])
	k0, k1, k2, k3 = mks[0]^fk0, mks[1]^fk1, mks[2]^fk2, mks[3]^fk3
	for i := 0; i < 32;  {
		k0 ^= transTPrime(k1^k2^k3^ck[i]); enc[i] = k0; dec[31-i] = k0; i++
		k1 ^= transTPrime(k2^k3^k0^ck[i]); enc[i] = k1; dec[31-i] = k1; i++
		k2 ^= transTPrime(k3^k0^k1^ck[i]); enc[i] = k2; dec[31-i] = k2; i++
		k3 ^= transTPrime(k0^k1^k2^ck[i]); enc[i] = k3; dec[31-i] = k3; i++
	}
}
func byte16ToUint32(bytes []byte, uints []uint32) {
	for i := 0; i < 4; i++ {
		uints[i] = binary.BigEndian.Uint32(bytes[i<<2 : i<<2+4])
	}
}