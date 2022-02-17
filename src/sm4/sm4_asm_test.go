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

func Test_encryptBlockAsmProto(t *testing.T) {
	src := make([]byte, 16)
	dst := make([]byte, 16)
	rk := make([]uint32, 32)

	for i:=0; i<16; i++ {
		//src[i] = byte(i)
	}
	src[4] = 0x1
	src[5] = 0x2
	src[6] = 0x3
	src[7] = 0xff


	encryptBlockAsm(&rk[0], &dst[0], &src[0])
	fmt.Printf("%x\n", dst)
}

func Test_encryptBlockAsm(t *testing.T) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	expected, _ := hex.DecodeString("681edf34d206965e86b3e94f536e4246")

	cipher := make([]byte, 16)

	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	encryptBlockAsm(&sm4.enc[0], &cipher[0], &plain[0])
	fmt.Printf("Result: %x\nExpected: %x\n", cipher, expected)
	if !reflect.DeepEqual(cipher, expected) {
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

func Benchmark_encryptBlockAsm(b *testing.B) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	dst := make([]byte, 16)
	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(16)
	for i:=0; i<b.N; i++ {
		encryptBlockAsm(&sm4.enc[0], &dst[0], &plain[0])
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