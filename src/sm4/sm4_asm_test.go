package sm4

import (
	"encoding/hex"
	"fmt"
	. "github.com/klauspost/cpuid/v2"
	"reflect"
	"testing"
)

func Test_newCipher(t *testing.T) {
	fmt.Printf("AESNI: %t\n", CPU.Supports(AESNI))
	fmt.Printf("AVX512: %t\n", CPU.Supports(AVX512F))
	fmt.Printf("GFNI: %t\n", CPU.Supports(GFNI))
	fmt.Printf("SM3: %t\n", CPU.Supports(SM3))
	fmt.Printf("SM4: %t\n", CPU.Supports(SM4))
	fmt.Printf("AESARM: %t\n", CPU.Supports(AESARM))
	fmt.Printf("PMULL: %t\n", CPU.Supports(PMULL)) // polynomial multiplication, for GCM
	fmt.Println(CPU.FeatureSet())
}

func Test_encryptCrossBlock(t *testing.T) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210681edf34d206965e86b3e94f536e4246f324184f3c8892b72bdc9d7c612919dece4dd6b81f6de992a830daab1f008028")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	expected, _ := hex.DecodeString("681edf34d206965e86b3e94f536e4246f324184f3c8892b72bdc9d7c612919dece4dd6b81f6de992a830daab1f00802836d33f04088dae09b94bbf39f0209d29")

	cipher := make([]byte, 64)

	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	cryptoBlockAsmX4(&sm4.enc[0], &cipher[0], &plain[0])
	fmt.Printf("Result: %x\nExpected: %x\n", cipher, expected)
	if !reflect.DeepEqual(cipher, expected) {
		t.Fail()
	}
}

func Test_encryptBlockAsmX4(t *testing.T) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	expected, _ := hex.DecodeString("681edf34d206965e86b3e94f536e4246681edf34d206965e86b3e94f536e4246681edf34d206965e86b3e94f536e4246681edf34d206965e86b3e94f536e4246")

	cipher := make([]byte, 64)

	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	cryptoBlockAsmX4(&sm4.enc[0], &cipher[0], &plain[0])
	fmt.Printf("Result: %x\nExpected: %x\n", cipher, expected)
	if !reflect.DeepEqual(cipher, expected) {
		t.Fail()
	}
}

func Test_encryptBlockAsm(t *testing.T) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	expected, _ := hex.DecodeString("681edf34d206965e86b3e94f536e4246")

	cipher := make([]byte, 16)

	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	cryptoBlockAsm(&sm4.enc[0], &cipher[0], &plain[0])
	fmt.Printf("Result: %x\nExpected: %x\n", cipher, expected)
	if !reflect.DeepEqual(cipher, expected) {
		t.Fail()
	}

	expected, _ = hex.DecodeString("595298c7c6fd271f0402f804c33d3f66")
	// 示例2，加密1000000次
	inter := make([]byte, 16)
	copy(inter, plain)
	for i:=0; i<1000000; i++ {
		cryptoBlockAsm(&sm4.enc[0], &cipher[0], &inter[0])
		copy(inter, cipher)
	}

	if !reflect.DeepEqual(expected, cipher) {
		fmt.Printf("output: %x\n", cipher)
		t.Fail()
	}

}

func Benchmark_encryptBlockAsmX1(b *testing.B) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	dst := make([]byte, 16)
	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(16)
	for i:=0; i<b.N; i++ {
		cryptoBlockAsm(&sm4.enc[0], &dst[0], &plain[0])
	}
}

func Benchmark_encryptBlockAsmX4(b *testing.B) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	dst := make([]byte, 64)
	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(64)
	for i:=0; i<b.N; i++ {
		cryptoBlockAsmX4(&sm4.enc[0], &dst[0], &plain[0])
	}
}

func Test_printDataBlock(t *testing.T) {
	for i:=0; i<32; i++ {
		fmt.Printf("DATA SBox<>+0x%02x(SB)/8, $0x", i*8)
		for j:=0; j<8; j++ {
			fmt.Printf("%02x", sbox[i*8 + 7 - j])
		}
		fmt.Println()
	}
}