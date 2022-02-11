package sm4

import (
	"fmt"
	. "github.com/klauspost/cpuid/v2"
	"testing"
)

func Test_newCipher(t *testing.T) {
	fmt.Println(CPU.Supports(SM3))
	fmt.Println(CPU.Supports(SM4))
	fmt.Println(CPU.Supports(AESNI))
	fmt.Println(CPU.Supports(AESARM))
	fmt.Println(CPU.Supports(SHA2))
	fmt.Println(CPU.Supports(SVE))
	fmt.Println(supportsAES)
}
