// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2011 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

package sm4

import (
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

func BenchmarkSm4Cipher_Encrypt_16(b *testing.B) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")

	sm4, err := NewCipher(key)
	if err != nil {
		b.Fail()
	}

	cipher := make([]byte, 16)
	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm4.Encrypt(cipher, plain)
	}
}

func BenchmarkSm4Cipher_Encrypt_64(b *testing.B) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")

	sm4, err := NewCipher(key)
	if err != nil {
		b.Fail()
	}

	cipher := make([]byte, 16)
	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm4.Encrypt(cipher, plain)
	}
}