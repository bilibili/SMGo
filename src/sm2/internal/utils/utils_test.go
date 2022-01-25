package utils

import (
	"fmt"
	"testing"
)

func TestConstantTimeCmp(t *testing.T) {
	var a, b [32]byte
	for i:=0; i<32; i++ {
		a[i] = byte(i*2 + 1)
		b[i] = a[i]
	}

	if ConstantTimeCmp(a[:], b[:], 32) != 0 {
		t.Fail()
	}

	a[20] -= 1
	if ConstantTimeCmp(a[:], b[:], 32) != -1 {
		t.Fail()
	}

	a[19] += 1
	if ConstantTimeCmp(a[:], b[:], 32) != 1 {
		t.Fail()
	}
}

func TestDecompose4NAF(t *testing.T) {
	var out = make([]int, 257)
	var s = make([]byte, 32)

	s[31] = 0b00101111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[0] != 0b1111 || out[5] != 0x0001 {
		t.Fail()
	}
	s[31] = 0b00111111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[0] != -1 || out[5] != 1 {
		t.Fail()
	}
	s[0] = 0b00101111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[248] != 0b1111 || out[253] != 0x0001 {
		t.Fail()
	}
	s[0] = 0b00111111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[248] != -1 || out[253] != 1 || out[254] != 1 {
		t.Fail()
	}
	s[0] = 0b11111111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[256] != 1 {
		t.Fail()
	}
}

func BenchmarkDecomposeNAF(b *testing.B) {
	var out = make([]int, 257)
	var s = make([]byte, 32)

	s[0] = 0b00101111
	for i:=0; i<b.N; i++ {
		DecomposeNAF(out[:], &s, 257, 4)
	}
}