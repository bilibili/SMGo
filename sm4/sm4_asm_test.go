package sm4

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	. "github.com/klauspost/cpuid/v2"
	"reflect"
	"testing"
)

func Test_newCipher(t *testing.T) {
	fmt.Printf("GFNI: %t\n", CPU.Supports(GFNI))
	fmt.Printf("AVX512F: %t\n", CPU.Supports(AVX512F))
	fmt.Printf("AVX512VL: %t\n", CPU.Supports(AVX512VL))
	fmt.Printf("AVX512DQ: %t\n", CPU.Supports(AVX512DQ))
	fmt.Printf("AVX: %t\n", CPU.Supports(AVX))
	fmt.Printf("SSE3: %t\n", CPU.Supports(SSE3))
	fmt.Printf("SSE2: %t\n", CPU.Supports(SSE2))
	fmt.Printf("VPCLMULQDQ: %t\n", CPU.Supports(VPCLMULQDQ))
	fmt.Printf("SM3: %t\n", CPU.Supports(SM3))
	fmt.Printf("SM4: %t\n", CPU.Supports(SM4))
	fmt.Printf("AESARM: %t\n", CPU.Supports(AESARM))
	fmt.Printf("PMULL: %t\n", CPU.Supports(PMULL)) // polynomial multiplication, for GCM
}

func Test_encryptCrossBlockX4(t *testing.T) {
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

func Test_encryptCrossBlockX8(t *testing.T) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba9876543210681edf34d206965e86b3e94f536e4246f324184f3c8892b72bdc9d7c612919dece4dd6b81f6de992a830daab1f00802836d33f04088dae09b94bbf39f0209d295df3683cfdb6e4574fc5a43b9b8a3e1af189be7d529ce65f3c8bcfac9943dc62b2ce8a0c7304f37675dc627f51022963")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	expected, _ := hex.DecodeString("681edf34d206965e86b3e94f536e4246f324184f3c8892b72bdc9d7c612919dece4dd6b81f6de992a830daab1f00802836d33f04088dae09b94bbf39f0209d295df3683cfdb6e4574fc5a43b9b8a3e1af189be7d529ce65f3c8bcfac9943dc62b2ce8a0c7304f37675dc627f51022963cd4ca27a861b064e39a0c047501aad6c")

	cipher := make([]byte, 128)

	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	cryptoBlockAsmX8(&sm4.enc[0], &cipher[0], &plain[0])
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

func Test_encryptBlockAsmX2(t *testing.T) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	expected, _ := hex.DecodeString("681edf34d206965e86b3e94f536e4246681edf34d206965e86b3e94f536e4246")

	cipher := make([]byte, 32)

	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	cryptoBlockAsmX2(&sm4.enc[0], &cipher[0], &plain[0])
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
	fmt.Printf("Result:   %x\nExpected: %x\n", cipher, expected)
	if !reflect.DeepEqual(cipher, expected) {
		t.Fail()
	}

	expected, _ = hex.DecodeString("595298c7c6fd271f0402f804c33d3f66")
	// 示例2，加密1000000次
	inter := make([]byte, 16)
	copy(inter, plain)
	for i := 0; i < 1000000; i++ {
		cryptoBlockAsm(&sm4.enc[0], &cipher[0], &inter[0])
		copy(inter, cipher)
	}

	if !reflect.DeepEqual(expected, cipher) {
		fmt.Printf("output: %x\n", cipher)
		t.Fail()
	}

}

func Test_encryptBlockAsmX16(t *testing.T) {
	plainX1, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")

	cipher := make([]byte, 256)
	expected := make([]byte, 256)

	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	plainX16 := make([]byte, 272)
	copy(plainX16, plainX1)
	for i := 0; i < 16; i++ {
		sm4.Encrypt(expected[i*16:], plainX16[i*16:])
		copy(plainX16[(i+1)*16:(i+2)*16], expected[i*16:(i+1)*16])
	}

	cryptoBlockAsmX16(&sm4.enc[0], &cipher[0], &plainX16[0])
	fmt.Printf("Plain:    %x\nResult:   %x\nExpected: %x\n", plainX16, cipher, expected)
	if !reflect.DeepEqual(cipher, expected) {
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
	for i := 0; i < b.N; i++ {
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
	for i := 0; i < b.N; i++ {
		cryptoBlockAsmX4(&sm4.enc[0], &dst[0], &plain[0])
	}
}

func Benchmark_encryptBlockAsmX8(b *testing.B) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	dst := make([]byte, 128)
	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(128)
	for i := 0; i < b.N; i++ {
		cryptoBlockAsmX8(&sm4.enc[0], &dst[0], &plain[0])
	}
}

func Benchmark_encryptBlockAsmX16(b *testing.B) {
	plain, _ := hex.DecodeString("0123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210")
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")
	dst := make([]byte, 256)
	sm4 := sm4Cipher{}
	expandKey(key, &sm4.enc, &sm4.dec)

	b.ResetTimer()
	b.ReportAllocs()
	b.SetBytes(256)
	for i := 0; i < b.N; i++ {
		cryptoBlockAsmX16(&sm4.enc[0], &dst[0], &plain[0])
	}
}

func Test_printDataBlock(t *testing.T) {
	for i := 0; i < 32; i++ {
		fmt.Printf("DATA SBox<>+0x%02x(SB)/8, $0x", i*8)
		for j := 0; j < 8; j++ {
			fmt.Printf("%02x", sbox[i*8+7-j])
		}
		fmt.Println()
	}
}

func Test_printCKeys(t *testing.T) {
	for i := 0; i < 32; i++ {
		fmt.Printf("DATA CK<>+0x%02x(SB)/4, $0x", i*4)
		fmt.Printf("%08x\n", ck[i])
	}
}

func Test_expandKeyAsmZeroKey(t *testing.T) {
	key := make([]byte, 16)

	ref := sm4Cipher{}
	tested := sm4Cipher{}

	expandKey(key, &ref.enc, &ref.dec)
	expandKeyAsm(&key[0], &tested.enc[0], &tested.dec[0])

	if !reflect.DeepEqual(ref.enc, tested.enc) || !reflect.DeepEqual(ref.dec, tested.dec) {
		fmt.Printf("key: %x\n", key)
		fmt.Printf("Go enc: %08x\n   dec: %08x\n", ref.enc, ref.dec)
		fmt.Printf("Asm enc:%08x\n   dec: %08x\n", tested.enc, tested.dec)
		t.Fail()
	}
}

func Test_expandKeyAsmFixedKey(t *testing.T) {
	key, _ := hex.DecodeString("0123456789abcdeffedcba9876543210")

	ref := sm4Cipher{}
	tested := sm4Cipher{}

	expandKey(key, &ref.enc, &ref.dec)
	expandKeyAsm(&key[0], &tested.enc[0], &tested.dec[0])

	if !reflect.DeepEqual(ref.enc, tested.enc) || !reflect.DeepEqual(ref.dec, tested.dec) {
		fmt.Printf("key: %x\n", key)
		fmt.Printf("Go enc: %08x\n   dec: %08x\n", ref.enc, ref.dec)
		fmt.Printf("Asm enc:%08x\n   dec: %08x\n", tested.enc, tested.dec)
		t.Fail()
	}
}

func Test_expandKeyAsmRandomKey(t *testing.T) {
	key := make([]byte, 16)
	rand.Read(key)

	ref := sm4Cipher{}
	tested := sm4Cipher{}

	expandKey(key, &ref.enc, &ref.dec)
	expandKeyAsm(&key[0], &tested.enc[0], &tested.dec[0])

	if !reflect.DeepEqual(ref.enc, tested.enc) || !reflect.DeepEqual(ref.dec, tested.dec) {
		fmt.Printf("key: %x\n", key)
		fmt.Printf("Go enc: %08x\n   dec: %08x\n", ref.enc, ref.dec)
		fmt.Printf("Asm enc:%08x\n   dec: %08x\n", tested.enc, tested.dec)
		t.Fail()
	}
}
