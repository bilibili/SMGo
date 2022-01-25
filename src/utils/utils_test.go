package utils

import (
	"fmt"
	"math/rand"
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

	s[31] = 0x1
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[0] != 0x1 {
		t.Fail()
	}

	out = make([]int, 257)
	s = make([]byte, 32)
	s[31] = 0b00101111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[0] != 0b1111 || out[5] != 0x0001 {
		t.Fail()
	}

	out = make([]int, 257)
	s = make([]byte, 32)
	s[31] = 0b00111111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[0] != -1 || out[6] != 1 {
		t.Fail()
	}

	out = make([]int, 257)
	s = make([]byte, 32)
	s[0] = 0b00101111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[248] != 0b1111 || out[253] != 0x0001 {
		t.Fail()
	}

	out = make([]int, 257)
	s = make([]byte, 32)
	s[0] = 0b00111111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[248] != -1 || out[254] != 1 {
		t.Fail()
	}

	out = make([]int, 257)
	s = make([]byte, 32)
	s[0] = 0b11111111
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	if out[256] != 1 {
		t.Fail()
	}

	out = make([]int, 257)
	s = make([]byte, 32)
	rand.Read(s)
	DecomposeNAF(out[:], &s, 257, 4)
	fmt.Printf("%d\n%x\n", out, s)
	consecutiveZeroCounter := 4
	for i:=0; i<len(out); i++ {
		d := out[i]
		if d == 0 {
			consecutiveZeroCounter++
			continue
		}

		if consecutiveZeroCounter < 4 {
			t.Fail()
		}

		consecutiveZeroCounter = 0

		if d < 0 {
			d = -d
		}

		if d&1 != 1 {
			t.Fail()
		}

		if d > 15 {
			t.Fail()
		}
	}
}

func BenchmarkDecomposeNAF(b *testing.B) {
	var out = make([]int, 257)
	var s = make([]byte, 32)

	rand.Read(s)
	for i:=0; i<b.N; i++ {
		DecomposeNAF(out[:], &s, 257, 4)
	}
}