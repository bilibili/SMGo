package fiat

import "testing"

func Benchmark_sm2ScalarMul(b *testing.B) {
	var out, a, c sm2ScalarMontgomeryDomainFieldElement
	sm2ScalarSetOne(&a)
	sm2ScalarSetOne(&c)

	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm2ScalarMul(&out, &a, &c)
	}
}
