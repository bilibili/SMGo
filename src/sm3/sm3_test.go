package sm3

import (
	"encoding/hex"
	"fmt"
	"reflect"
	"smgo/utils"
	"testing"
)

func Test_SpecExample1(t *testing.T) {
	sm3 := New()
	out := make([]byte, 32)
	data, _ := hex.DecodeString("616263")
	sm3.Write(data)
	out = sm3.Sum(nil)
	expected, _ := hex.DecodeString("66c7f0f462eeedd9d1f2d46bdc10e4e24167c4875cf2f7a2297da02b8f4ba8e0")
	if !reflect.DeepEqual(out[:], expected) {
		fmt.Printf("#1 output: %x\nexpected: %x\n", out, expected)
		t.Fail()
	}
	sm3.Reset()
	data, _ = hex.DecodeString("61")
	sm3.Write(data)
	data, _ = hex.DecodeString("62")
	sm3.Write(data)
	data, _ = hex.DecodeString("63")
	sm3.Write(data)
	out = sm3.Sum(nil)
	if !reflect.DeepEqual(out[:], expected) {
		fmt.Printf("#2 output: %x\nexpected: %x\n", out, expected)
		t.Fail()
	}
}
func Test_SpecExample2(t *testing.T) {
	sm3 := New()
	out := make([]byte, 32)
	data, _ := hex.DecodeString("61626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364")
	sm3.Write(data)
	out = sm3.Sum(nil)
	expected, _ := hex.DecodeString("debe9ff92275b8a138604889c18e5a4d6fdb70e5387e5765293dcba39c0c5732")
	if !reflect.DeepEqual(out[:], expected) {
		fmt.Printf("#1 output: %x\nexpected: %x\n", out, expected)
		t.Fail()
	}
	sm3.Reset()
	data, _ = hex.DecodeString("616263")
	sm3.Write(data)
	out2 := sm3.Sum(nil)
	expected2, _ := hex.DecodeString("66c7f0f462eeedd9d1f2d46bdc10e4e24167c4875cf2f7a2297da02b8f4ba8e0")
	if !reflect.DeepEqual(out2[:], expected2) {
		fmt.Printf("#2 output: %x\nexpected: %x\n", out2, expected2)
		t.Fail()
	}

	// keep writing after Sum call
	data, _ = hex.DecodeString("64616263646162636461626364616263646162636461626364616263646162")
	sm3.Write(data)
	data, _ = hex.DecodeString("636461626364616263")
	sm3.Write(data)
	data, _ = hex.DecodeString("646162636461626364616263646162636461626364")
	sm3.Write(data)
	data, _ = hex.DecodeString("")
	sm3.Write(data)
	out = sm3.Sum(nil)
	if !reflect.DeepEqual(out[:], expected) {
		fmt.Printf("#2 output: %x\nexpected: %x\n", out, expected)
		t.Fail()
	}
}

// test data obtained from OpenSSL 1.1.1+
func Test_data65(t *testing.T) {
	sm3 := New()
	out := make([]byte, 32)
	data, _ := hex.DecodeString("6561626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364")
	sm3.Write(data)
	out = sm3.Sum(nil)
	expected, _ := hex.DecodeString("54f949c5d5644fb5ea955f90de5dee8095082db99d67a4c3e9dbbddc23bfc267")
	if !reflect.DeepEqual(out[:], expected) {
		fmt.Printf("#1 output: %x\nexpected: %x\n", out, expected)
		t.Fail()
	}
}

// test data obtained from OpenSSL 1.1.1+
func Test_data60(t *testing.T) {
	sm3 := New()
	out := make([]byte, 32)
	data, _ := hex.DecodeString("656162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263")
	sm3.Write(data)
	out = sm3.Sum(nil)
	expected, _ := hex.DecodeString("0bc0ebcbd130f5af1db8169ef296f3d69b5817e560c62e9bfbb65d175e66f9ba")
	if !reflect.DeepEqual(out[:], expected) {
		fmt.Printf("#1 output: %x\nexpected: %x\n", out, expected)
		t.Fail()
	}
}

func Test_coverage(t *testing.T){
	data, _ := hex.DecodeString("616263")
	out := SumSM3(data)
	expected, _ := hex.DecodeString("66c7f0f462eeedd9d1f2d46bdc10e4e24167c4875cf2f7a2297da02b8f4ba8e0")
	if !reflect.DeepEqual(out[:], expected) {
		fmt.Printf("#1 output: %x\nexpected: %x\n", out, expected)
		t.Fail()
	}

	sm3 := New()
	if sm3.Size() != 32 {
		t.Fail()
	}
	if sm3.BlockSize() != 64 {
		t.Fail()
	}
}

func Test_DeriveTTs(t *testing.T) {
	for i:=0; i<16; i++ {
		fmt.Printf("0x%08x,\t", utils.RotateLeft(t0, i))
		if (i+1)&0x07 == 0 {
			fmt.Println()
		}
	}
	for i:=16; i<64; i++ {
		fmt.Printf("0x%08x,\t", utils.RotateLeft(t1, i%32))
		if (i+1)&0x07 == 0 {
			fmt.Println()
		}
	}
}

func BenchmarkSum_16(b *testing.B) {
	bench(b, 16)
}

func BenchmarkSum_64(b *testing.B) {
	bench(b, 64)
}

func BenchmarkSum_256(b *testing.B) {
	bench(b, 256)
}

func BenchmarkSum_1024(b *testing.B) {
	bench(b, 1024)
}

func BenchmarkSum_8192(b *testing.B) {
	bench(b, 8192)
}

func BenchmarkSum_16384(b *testing.B) {
	bench(b, 16384)
}

func bench(b *testing.B, n int) {
	sm3 := New()
	data := make([]byte, n)
	b.SetBytes(int64(n))
	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm3.Write(data[:])
		sm3.Sum(nil)
	}
}