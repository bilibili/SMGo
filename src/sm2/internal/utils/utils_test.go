package utils

import "testing"

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
