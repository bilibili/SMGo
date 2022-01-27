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

// reduce turns j into 0 or 1 based on its range according to the SM3 standard spec
// caller must ensure j >=0 && j <= 63, otherwise return value is undefined
// let's do this branching free
func reduce(j int) uint32 {return 1- uint32(j-16)>>31}

func ff0(x, y, z uint32) uint32 {return x ^ y ^ z}
func ff1(x, y, z uint32) uint32 {return (x&y) | (x&z) | (y&z)}
var ffs = []func (x, y, z uint32) uint32 {ff0, ff1}
func ff(j int) func (x, y, z uint32) uint32 {return ffs[reduce(j)]}

var gg0 = ff0
func gg1(x, y, z uint32) uint32 {return (x&y) | (^x & z)}
var ggs = []func (x, y, z uint32) uint32 {gg0, gg1}
func gg(j int) func (x, y, z uint32) uint32 {return ggs[reduce(j)]}

func p0(x uint32) uint32 {return x ^ utils.RotateLeft(x, 9) ^ utils.RotateLeft(x, 17)}
func p1(x uint32) uint32 {return x ^ utils.RotateLeft(x, 15) ^ utils.RotateLeft(x, 23)}

var tts = []uint32 {t0, t1}
func tt(j int) uint32 {return tts[reduce(j)]}

// msg must be in 64 bytes
func expand(msg []byte, w *[68]uint32, wPrime *[64]uint32) {
	for i:=0; i<=15; i++ {
		w[i] = binary.BigEndian.Uint32(msg[4*i : 4*i + 4])
		//fmt.Printf("w[%d]: 0x%x\n", i, w[i])
	}
	for j:=16; j<=67; j++ {
		w[j] = p1(w[j-16] ^ w[j-9] ^ utils.RotateLeft(w[j-3], 15)) ^ utils.RotateLeft(w[j-13], 7) ^ w[j-6]
		//fmt.Printf("w[%d]: 0x%x\n", j, w[j])
	}
	for j:=0; j<=63; j++ {
		wPrime[j] = w[j] ^ w[j+4]
		//fmt.Printf("w'[%d]: 0x%x\n", j, wPrime[j])
	}
}

// msg must be in 64 bytes
func (sm3 *SM3) cf(msg []byte) {
	a, b, c, d, e, f, g, h := sm3.h[0], sm3.h[1], sm3.h[2], sm3.h[3], sm3.h[4],sm3.h[5], sm3.h[6], sm3.h[7]

	var w [68]uint32
	var wPrime [64]uint32
	expand(msg[:], &w, &wPrime)

	for j:=0; j<=63; j++ {
		alr12 := utils.RotateLeft(a, 12)
		ss1 := utils.RotateLeft(alr12 + e + utils.RotateLeft(tt(j), j), 7)
		ss2 := ss1 ^ alr12
		tt1 := ff(j)(a, b, c) + d + ss2 + wPrime[j]
		tt2 := gg(j)(e, f, g) + h + ss1 + w[j]
		d = c
		c = utils.RotateLeft(b, 9)
		b = a
		a = tt1
		h = g
		g = utils.RotateLeft(f, 19)
		f = e
		e = p0(tt2)

		//fmt.Printf("j=%d\t\t%x %x %x %x %x %x %x %x \n", j, a, b, c, d, e, f, g, h)
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