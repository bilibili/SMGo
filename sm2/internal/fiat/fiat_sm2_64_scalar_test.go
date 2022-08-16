package fiat

import "testing"

func Benchmark_sm2ScalarMul(b *testing.B) {
	var out, a, c sm2ScalarMontgomeryDomainFieldElement
	sm2ScalarSetOne(&a)
	sm2ScalarSetOne(&c)
	a[0] = 0x12345678
	a[1] = 0x87654321
	a[2] = 0xffffffff
	a[3] = 0xffffff
	c[0] = 0xffffffff
	c[3] = 0x12345678
	c[1] = 0x87654321
	c[2] = 0xffffffff

	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm2ScalarMul(&out, &a, &c)
	}
}

func Benchmark_sm2Mul(b *testing.B) {
	var out, a, c sm2MontgomeryDomainFieldElement
	sm2SetOne(&a)
	sm2SetOne(&c)
	a[0] = 0x12345678
	a[1] = 0x87654321
	a[2] = 0xffffffff
	a[3] = 0xffffff
	c[0] = 0xffffffff
	c[3] = 0x12345678
	c[1] = 0x87654321
	c[2] = 0xffffffff

	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm2Mul(&out, &a, &c)
	}
}

func Benchmark_sm2ScalarSquare(b *testing.B) {
	var out, a sm2ScalarMontgomeryDomainFieldElement
	sm2ScalarSetOne(&a)
	a[0] = 0x12345678
	a[1] = 0x87654321
	a[2] = 0xffffffff
	a[3] = 0xffffff

	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm2ScalarSquare(&out, &a)
	}
}

func Benchmark_sm2Square(b *testing.B) {
	var out, a sm2MontgomeryDomainFieldElement
	sm2SetOne(&a)
	a[0] = 0x12345678
	a[1] = 0x87654321
	a[2] = 0xffffffff
	a[3] = 0xffffff

	b.ResetTimer()
	b.ReportAllocs()
	for i:=0; i<b.N; i++ {
		sm2Square(&out, &a)
	}
}
