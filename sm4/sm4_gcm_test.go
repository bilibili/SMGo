// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64 || arm64

package sm4

import (
	"crypto/cipher"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"reflect"
	"testing"
)

func Test_xor256(t *testing.T) {
	testXor(xor256, 256, t)
}

func Test_xor128(t *testing.T) {
	testXor(xor128, 128, t)
}

func Test_xor64(t *testing.T) {
	testXor(xor64, 64, t)
}

func Test_xor32(t *testing.T) {
	testXor(xor32, 32, t)
}

func Test_xor16(t *testing.T) {
	testXor(xor16, 16, t)
}

func testXor(xorFunc func(*byte, *byte, *byte), count int, t *testing.T) {
	dst := make([]byte, count)
	dstAlternative := make([]byte, count)
	src1 := make([]byte, count)
	src2 := make([]byte, count)

	rand.Read(src1)
	rand.Read(src2)

	for i := 0; i < count; i++ {
		dstAlternative[i] = src1[i] ^ src2[i]
	}

	xorFunc(&dst[0], &src1[0], &src2[0])

	if !reflect.DeepEqual(dst, dstAlternative) {
		t.Fail()
	}
}

var aesGCMTests = []struct {
	key, nonce, plaintext, aad string
	tagSize                    int
}{
	{
		"0123456789abcdeffedcba9876543210",
		"0123456789ab0123456789ab",
		"0123456789abcdeffedcba9876543210",
		"0123456789abcdeffedcba9876543210",
		16,
	},
	{
		"0123456789abcdeffedcba9876543210",
		"0123456789ab0123456789abAAAA", // non-standard nonce size
		"0123456789abcdeffedcba9876543210",
		"0123456789abcdeffedcba9876543210",
		16,
	},
	{
		"0123456789abcdeffedcba9876543210",
		"0123456789ab0123456789ab",
		"0123456789abcdeffedcba9876543210",
		"0123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210AAA", // long & non-16X long aad
		16,
	},
	{
		"0123456789abcdeffedcba9876543210",
		"0123456789ab0123456789ab",
		"0123456789abcdeffedcba9876543210",
		"", // empty aad
		16,
	},
	{
		"0123456789abcdeffedcba9876543210",
		"0123456789ab0123456789ab",
		"0123456789abcdeffedcba9876543210AAAAAA", // non-full plain block
		"0123456789abcdeffedcba9876543210",
		16,
	},
	{
		"0123456789abcdeffedcba9876543210",
		"0123456789ab0123456789ab",
		"0123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210AAAAAA", // long & non-full plain block
		"0123456789abcdeffedcba9876543210",
		16,
	},
	{
		"0123456789abcdeffedcba9876543210",
		"0123456789ab0123456789ab",
		"0123456789abcdeffedcba9876543210",
		"0123456789abcdeffedcba9876543210",
		15,
	},
}

func Test_sm4GcmAsm_Seal(t *testing.T) {
	a:=[]byte{0x9, 0x7}
	b:=[]byte{0xc, 0x5}
	xorAsm(&a[0],&b[0], 2, &a[0])
	fmt.Println(a)

	for i, test := range aesGCMTests {
		key, _ := hex.DecodeString(test.key)
		nonce, _ := hex.DecodeString(test.nonce)
		src, _ := hex.DecodeString(test.plaintext)
		aad, _ := hex.DecodeString(test.aad)

		var gcmGo, gcmAsm cipher.AEAD

		sm4Go, _ := newCipherGeneric(key)
		if len(nonce) != gcmStandardNonceSize {
			gcmGo, _ = cipher.NewGCMWithNonceSize(sm4Go, len(nonce))
		} else if test.tagSize != 16 {
			gcmGo, _ = cipher.NewGCMWithTagSize(sm4Go, test.tagSize)
		} else {
			gcmGo, _ = cipher.NewGCM(sm4Go)
		}
		expected := gcmGo.Seal(nil, nonce, src, aad)

		sm4Asm, _ := NewCipher(key)
		if len(nonce) != gcmStandardNonceSize {
			gcmAsm, _ = cipher.NewGCMWithNonceSize(sm4Asm, len(nonce))
		} else if test.tagSize != 16 {
			gcmAsm, _ = cipher.NewGCMWithTagSize(sm4Asm, test.tagSize)
		} else {
			gcmAsm, _ = cipher.NewGCM(sm4Asm)
		}
		dst := gcmAsm.Seal(nil, nonce, src, aad)

		fmt.Printf("test case #%d\n%X\n", i, expected)

		if !reflect.DeepEqual(dst, expected) {
			fmt.Printf("failed test case #%d\n%X\n%X\n", i, dst, expected)
			t.Fail()
		}else{
			fmt.Printf("success test case #%d\n%X\n%X\n", i, dst, expected)
		}

		asm2Go, e1 := gcmGo.Open(nil, nonce, dst, aad)
		go2Asm, e2 := gcmAsm.Open(nil, nonce, expected, aad)

		if e1 != nil || e2 != nil {
			t.Fail()
		}

		if !reflect.DeepEqual(go2Asm, src) || !reflect.DeepEqual(asm2Go, src) {

			t.Fail()
		}else{
			fmt.Println("success")
		}
	}
}

func Test_sm4GcmAsm_SealXN(t *testing.T) {
	for blocks := 1; blocks < 100; blocks++ {
		key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")

		src := make([]byte, 16*blocks)
		if blocks == 0 {
			src = nil
		}
		rand.Read(src)

		nonce := make([]byte, 12)
		aad := make([]byte, 16)
		rand.Read(nonce)
		rand.Read(aad)

		sm4Go, _ := newCipherGeneric(key)
		gcmGo, _ := cipher.NewGCM(sm4Go)
		expected := gcmGo.Seal(nil, nonce, src, aad)

		sm4Asm, _ := NewCipher(key)
		gcmAsm, _ := cipher.NewGCM(sm4Asm)
		dst := gcmAsm.Seal(nil, nonce, src, aad)

		if !reflect.DeepEqual(dst, expected) {
			fmt.Printf("#%d\n%X\n%X\n", blocks, dst, expected)
			t.Fail()
		}

		asm2Go, e1 := gcmGo.Open(nil, nonce, dst, aad)
		go2Asm, e2 := gcmAsm.Open(nil, nonce, expected, aad)

		if e1 != nil {
			fmt.Println(blocks)
			fmt.Println(e1.Error())
			t.Fail()
		}
		if e2 != nil {
			fmt.Println(blocks)
			fmt.Println(e2.Error())
			t.Fail()
		}

		if !reflect.DeepEqual(go2Asm, src) || !reflect.DeepEqual(asm2Go, src) {
			fmt.Println(blocks)
			fmt.Printf("go2Asm %x\nasm2Go %x\n", go2Asm, asm2Go)
			t.Fail()
		}
	}
}

func Test_sm4GcmAsm_Seal_Random(t *testing.T) {
	for i := 0; i < 1000; i++ {
		key := make([]byte, 16)
		src := make([]byte, 16)
		nonce := make([]byte, 12)
		aad := make([]byte, 16)

		rand.Read(key)
		rand.Read(src)
		rand.Read(nonce)
		rand.Read(aad)

		sm4Go, _ := newCipherGeneric(key)
		gcmGo, _ := cipher.NewGCM(sm4Go)
		expected := gcmGo.Seal(nil, nonce, src, aad)

		sm4Asm, _ := NewCipher(key)
		gcmAsm, _ := cipher.NewGCM(sm4Asm)
		dst := gcmAsm.Seal(nil, nonce, src, aad)

		if !reflect.DeepEqual(dst, expected) {
			fmt.Println("fail")
			fmt.Printf("#%d\n%X\n%X\n", i, dst, expected)
			t.Fail()
		}else{
			fmt.Println("success")
		}

		asm2Go, e1 := gcmGo.Open(nil, nonce, dst, aad)
		go2Asm, e2 := gcmAsm.Open(nil, nonce, expected, aad)

		if e1 != nil || e2 != nil {
			t.Fail()
		}

		if !reflect.DeepEqual(go2Asm, src) || !reflect.DeepEqual(asm2Go, src) {
			t.Fail()
		}
	}
}

// test against test case 2 of the Appendix B
// of https://csrc.nist.rip/groups/ST/toolkit/BCM/documents/proposedmodes/gcm/gcm-revised-spec.pdf
func Test_GcmRevisedSpec(t *testing.T) {
	H, _ := hex.DecodeString("66e94bd4ef8a2c3b884cfa59ca342b2e")
	C, _ := hex.DecodeString("0388dace60b6a392f328c2b971b2fe78")
	expected, _ := hex.DecodeString("5e2ec746917062882c85b0685353deb7") // X1 from test case 2
	tag := make([]byte, 16)

	gHashBlocks(&H[0], &tag[0], &C[0], 1)
	if !reflect.DeepEqual(expected, tag) {
		fmt.Printf("%X\n%X\n", tag, expected)
		t.Fail()
	}
}

func Test_MultiplyByUnit(t *testing.T) {
	H, _ := hex.DecodeString("80000000000000000000000000000000")
	C, _ := hex.DecodeString("0388dace60b6a392f328c2b971b2fe78")
	expected, _ := hex.DecodeString("0388dace60b6a392f328c2b971b2fe78") // X1 from test case 2
	tag := make([]byte, 16)

	gHashBlocks(&H[0], &tag[0], &C[0], 1)
	fmt.Printf("%X\n%X\n", tag, expected)
	if !reflect.DeepEqual(expected, tag) {
		t.Fail()
	}
}

func Benchmark_sm4GcmAsm_SealX16(b *testing.B) {
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	src := make([]byte, 256)
	nonce, _ := hex.DecodeString("0123456789ab0123456789ab")
	aad, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	dst := make([]byte, 256+16)

	sm4Asm, _ := NewCipher(key)
	gcmAsm, _ := cipher.NewGCM(sm4Asm)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(256)
	for i := 0; i < b.N; i++ {
		gcmAsm.Seal(dst, nonce, src, aad)
	}
}

func Benchmark_sm4GcmAsm_Seal_16(b *testing.B) {
	benchSeal(16, b)
}

func Benchmark_sm4GcmAsm_Seal_64(b *testing.B) {
	benchSeal(64, b)
}

func Benchmark_sm4GcmAsm_Seal_128(b *testing.B) {
	benchSeal(128, b)
}

func Benchmark_sm4GcmAsm_Seal_256(b *testing.B) {
	benchSeal(256, b)
}

func Benchmark_sm4GcmAsm_Seal_1024(b *testing.B) {
	benchSeal(1024, b)
}

func Benchmark_sm4GcmAsm_Seal_8192(b *testing.B) {
	benchSeal(8192, b)
}

func Benchmark_sm4GcmAsm_Seal_16384(b *testing.B) {
	benchSeal(16384, b)
}

func benchSeal(count int, b *testing.B) {
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	src := make([]byte, count)
	nonce, _ := hex.DecodeString("0123456789ab0123456789ab")
	aad, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	dst := make([]byte, count+16)

	sm4Asm, _ := NewCipher(key)
	gcmAsm, _ := cipher.NewGCM(sm4Asm)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(int64(count))
	for i := 0; i < b.N; i++ {
		gcmAsm.Seal(dst, nonce, src, aad)
	}
}

func Benchmark_sm4GcmAsm_gHash_16(b *testing.B) {
	benchGHash(16, b)
}

func Benchmark_sm4GcmAsm_gHash_64(b *testing.B) {
	benchGHash(64, b)
}

func Benchmark_sm4GcmAsm_gHash_128(b *testing.B) {
	benchGHash(128, b)
}

func Benchmark_sm4GcmAsm_gHash_256(b *testing.B) {
	benchGHash(256, b)
}

func Benchmark_sm4GcmAsm_gHash_1024(b *testing.B) {
	benchGHash(1024, b)
}

func Benchmark_sm4GcmAsm_gHash_8192(b *testing.B) {
	benchGHash(8192, b)
}

func Benchmark_sm4GcmAsm_gHash_16384(b *testing.B) {
	benchGHash(16384, b)
}

func benchGHash(count int, b *testing.B) {
	src := make([]byte, count)
	H, _ := hex.DecodeString("66e94bd4ef8a2c3b884cfa59ca342b2e")
	tag := make([]byte, 16)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(int64(count))
	for i := 0; i < b.N; i++ {
		gHashBlocks(&H[0], &tag[0], &src[0], count>>4)
	}
}
