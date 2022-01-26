package sm3

import (
	"encoding/hex"
	"fmt"
	"reflect"
	"testing"
)

func Test_reduce(t *testing.T) {
	for j:=0; j <=15; j++ {
		r := reduce(j)
		if r != 0 {
			t.Fail()
		}
	}
	for j:=16; j<=63; j++ {
		r := reduce(j)
		if r != 1 {
			t.Fail()
		}
	}
}

func Test_SpecExample1(t *testing.T) {
	sm3 := New()
	out := make([]byte, 32)
	data, _ := hex.DecodeString("616263")
	sm3.Write(data)
	out = sm3.Sum(nil)
	fmt.Printf("output: %x\n", out)
	expected, _ := hex.DecodeString("66c7f0f462eeedd9d1f2d46bdc10e4e24167c4875cf2f7a2297da02b8f4ba8e0")
	if !reflect.DeepEqual(out[:], expected) {
		t.Fail()
	}
}
func Test_SpecExample2(t *testing.T) {
	sm3 := New()
	out := make([]byte, 32)
	data, _ := hex.DecodeString("61626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364616263646162636461626364")
	sm3.Write(data)
	out = sm3.Sum(nil)
	fmt.Printf("output: %x\n", out)
	expected, _ := hex.DecodeString("debe9ff92275b8a138604889c18e5a4d6fdb70e5387e5765293dcba39c0c5732")
	if !reflect.DeepEqual(out[:], expected) {
		t.Fail()
	}
}

func BenchmarkSum_16(b *testing.B) {
	sm3 := New()
	data, _ := hex.DecodeString("0123456789abcdef0123456789abcdef") //16bytes
	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm3.Write(data)
		sm3.Sum(nil)
	}
}

func BenchmarkSum_32(b *testing.B) {
	sm3 := New()
	data, _ := hex.DecodeString("0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef") //32bytes
	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm3.Write(data)
		sm3.Sum(nil)
	}
}