// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2011 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

package sm4

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"reflect"
	"testing"
)

func Test_sample1(t *testing.T) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	expected, _ := hex.DecodeString("681edf34d206965e86b3e94f536e4246")

	sm4, err := NewCipher(key)
	if err != nil {
		t.Fail()
	}

	cipher := make([]byte, 16)
	sm4.Encrypt(cipher, plain)

	if !reflect.DeepEqual(expected, cipher) {
		fmt.Printf("output: %x\n", cipher)
		t.Fail()
	}

	decrypted := make([]byte, 16)
	sm4.Decrypt(decrypted, cipher)

	if !reflect.DeepEqual(decrypted, plain) {
		fmt.Printf("decrypted: %x\n", decrypted)
		t.Fail()
	}

	expected, _ = hex.DecodeString("595298c7c6fd271f0402f804c33d3f66")
	// 示例2，加密1000000次
	inter := make([]byte, 16)
	copy(inter, plain)
	for i:=0; i<1000000; i++ {
		sm4.Encrypt(cipher, inter)
		copy(inter, cipher)
	}

	if !reflect.DeepEqual(expected, cipher) {
		fmt.Printf("output: %x\n", cipher)
		t.Fail()
	}
}

func Test_DeriveSboxes(t *testing.T) {
	var out0, out1, out2, out3 [256]uint32
	for i:=0; i<256; i++ {
		x := uint32(sbox[i])
		out0[i] = l(x<<24)
		out1[i] = l(x<<16)
		out2[i] = l(x<<8)
		out3[i] = l(x)
	}

	printsbox(0, out0)
	printsbox(1, out1)
	printsbox(2, out2)
	printsbox(3, out3)
}

func l(b uint32) uint32 {
	return b ^ (b<<2 | b >>30) ^ (b<<10 | b>>22) ^ (b<<18 | b>>14) ^ (b<<24 | b>>8)
}

func printsbox(idx int, out [256]uint32) {
	fmt.Printf("var sbox%d = [256]uint32 {\n", idx)
	for i := 0; i < 256; i++ {
		fmt.Printf("\t0x%08x,", out[i])
		if (i+1)&15 == 0 {
			fmt.Println()
		}
	}
	fmt.Println("}")
}

func BenchmarkSm4Cipher_Encrypt_16(b *testing.B) {
	bench(b, 16)
}

func BenchmarkSm4Cipher_Encrypt_64(b *testing.B) {
	bench(b, 64)
}

func BenchmarkSm4Cipher_Encrypt_256(b *testing.B) {
	bench(b, 256)
}

func BenchmarkSm4Cipher_Encrypt_1024(b *testing.B) {
	bench(b, 1024)
}

func BenchmarkSm4Cipher_Encrypt_8192(b *testing.B) {
	bench(b, 8192)
}

func BenchmarkSm4Cipher_Encrypt_16384(b *testing.B) {
	bench(b, 16384)
}

func bench(b *testing.B, n int) {
	plain := make([]byte, n)
	rand.Read(plain)
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")

	sm4, err := NewCipher(key)
	if err != nil {
		b.Fail()
	}

	cipher := make([]byte, n)
	b.SetBytes(int64(n))
	inner := n / 16
	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		for j:=0; j<inner; j++ {
			sm4.Encrypt(cipher[16*j:], plain[16*j:])
		}
	}
}