// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2011 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

package sm3

import (
	"encoding/binary"
	"hash"
	"smgo/utils"
)

type SM3 struct {
	h     [8]uint32
	x     [64]byte
	nx    int
	len   uint64
}

const (
	iv0 = 0x7380166f
	iv1 = 0x4914b2b9
	iv2 = 0x172442d7
	iv3 = 0xda8a0600
	iv4 = 0xa96f30bc
	iv5 = 0x163138aa
	iv6 = 0xe38dee4d
	iv7 = 0xb0fb0e4e
	t0 = 0x79cc4519
	t1 = 0x7a879d8a
	hashSize = 32
	blockSize = 64
	maxTail = 448/8
)

func New() hash.Hash {
	sm3 := new(SM3)
	sm3.Reset()
	return sm3
}

func (sm3 *SM3) Reset() {
	sm3.h[0] = iv0
	sm3.h[1] = iv1
	sm3.h[2] = iv2
	sm3.h[3] = iv3
	sm3.h[4] = iv4
	sm3.h[5] = iv5
	sm3.h[6] = iv6
	sm3.h[7] = iv7

	sm3.nx = 0
	sm3.len = 0
}

// Write just follows the GoLand standard library convention
func (sm3 *SM3) Write(data []byte) (n int, err error) {
	n = len(data)
	sm3.len += uint64(n)

	if sm3.nx > 0 {
		count := copy(sm3.x[sm3.nx:], data)
		sm3.nx += count
		data = data[count:]

		if sm3.nx + 1 == blockSize {
			sm3.cf(sm3.x[:])
			sm3.nx = 0
		}
	}

	for len(data) >= 64 {
		sm3.cf(data[:64])
		data = data[64:]
	}

	sm3.nx = copy(sm3.x[sm3.nx:], data)

	return
}

// Sum just follows the GoLand standard library convention
func (sm3 *SM3) Sum(in []byte) []byte {
	ret := *sm3 // copy so that writer can keep writing and summing, however, be wary of the data slice TODO
	hash := ret.checkSum()
	return append(in, hash[:]...)
}

// SumSM3 is a convenience function
func SumSM3(data []byte) [hashSize]byte {
	var sm3 SM3
	sm3.Reset()
	sm3.Write(data)
	return sm3.checkSum()
}

func (sm3 *SM3) Size() int {return hashSize}
func (sm3 *SM3) BlockSize() int {return blockSize}

func ff0(x, y, z uint32) uint32 {return x ^ y ^ z}
func ff1(x, y, z uint32) uint32 {return (x&y) | (x&z) | (y&z)}

func gg1(x, y, z uint32) uint32 {return (x&y) | (^x & z)}

func p0(x uint32) uint32 {return x ^ utils.RotateLeft(x, 9) ^ utils.RotateLeft(x, 17)}
func p1(x uint32) uint32 {return x ^ utils.RotateLeft(x, 15) ^ utils.RotateLeft(x, 23)}

// msg must be in 64 bytes
func expand(msg []byte, w *[68]uint32) {
	for i:=0; i<=15; i++ {
		w[i] = binary.BigEndian.Uint32(msg[i<<2 : i<<2 + 4])
	}
	for j:=16; j<=20; j++ {
		w[j] = p1(w[j-16] ^ w[j-9] ^ utils.RotateLeft(w[j-3], 15)) ^ utils.RotateLeft(w[j-13], 7) ^ w[j-6]
	}
}

// msg must be in 64 bytes
func (sm3 *SM3) cf(msg []byte) {
	a, b, c, d, e, f, g, h := sm3.h[0], sm3.h[1], sm3.h[2], sm3.h[3], sm3.h[4],sm3.h[5], sm3.h[6], sm3.h[7]

	var w [68]uint32
	expand(msg[0:64], &w)

	for j:=0; j<=15; j++ {
		alr12 := utils.RotateLeft(a, 12)
		ss1 := utils.RotateLeft(alr12 + e + utils.RotateLeft(t0, j), 7)
		tt2 := ff0(e, f, g) + h + ss1 + w[j]
		ss2 := ss1 ^ alr12
		tt1 := ff0(a, b, c) + d + ss2 + (w[j]^w[j+4])
		d, c = c, utils.RotateLeft(b, 9)
		b, a, h = a, tt1, g
		g, f, e = utils.RotateLeft(f, 19), e, p0(tt2)
	}
	for j:=16; j<=63; j++ {
		alr12 := utils.RotateLeft(a, 12)
		ss1 := utils.RotateLeft(alr12 + e + utils.RotateLeft(t1, j), 7)
		tt2 := gg1(e, f, g) + h + ss1 + w[j]
		ss2 := ss1 ^ alr12
		w[j+4] = p1(w[j+4-16] ^ w[j+4-9] ^ utils.RotateLeft(w[j+4-3], 15)) ^ utils.RotateLeft(w[j+4-13], 7) ^ w[j+4-6]
		tt1 := ff1(a, b, c) + d + ss2 + (w[j]^w[j+4])
		d, c = c, utils.RotateLeft(b, 9)
		b, a, h = a, tt1, g
		g, f, e = utils.RotateLeft(f, 19), e, p0(tt2)
	}

	sm3.h[0] ^= a
	sm3.h[1] ^= b
	sm3.h[2] ^= c
	sm3.h[3] ^= d
	sm3.h[4] ^= e
	sm3.h[5] ^= f
	sm3.h[6] ^= g
	sm3.h[7] ^= h
}

func (sm3 *SM3) checkSum() [hashSize]byte {
	var tmp [blockSize]byte
	pos := sm3.nx

	copy(tmp[:], sm3.x[0 : pos])
	tmp[pos] = 1 << 7
	pos++

	if pos + 1 > maxTail {
		for i:=pos; i<blockSize; i++ {
			tmp[i] = 0
		}
		sm3.cf(tmp[:])
		pos = 0
	}
	for i:=pos; i<maxTail; i++ {
		tmp[i] = 0
	}
	binary.BigEndian.PutUint64(tmp[maxTail:], sm3.len<<3)
	sm3.cf(tmp[:])

	var out [hashSize]byte
	for i:=0; i<8; i++ {
		binary.BigEndian.PutUint32(out[4*i:], sm3.h[i])
	}

	return out
}