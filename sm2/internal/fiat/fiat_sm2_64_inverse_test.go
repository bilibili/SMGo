package fiat

import (
	"math/big"
	"math/rand"
	"testing"
)

func Benchmark_EEAInv(b *testing.B) {
	const BYTES = 32
	var a [BYTES]byte
	var SM2p, _ = new(big.Int).SetString("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF", 16)

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		for j := 0; j < BYTES-8; j++ {
			a[j] = (byte)(rand.Uint32() % 256)
		}
		for j := BYTES - 8; j < BYTES; j++ {
			a[j] = 0
		}

		var val = new(big.Int).SetBytes(a[:])
		var inv big.Int
		inv.ModInverse(val, SM2p)

		var res big.Int
		res.Mul(val, &inv)
		res.Mod(&res, SM2p)

		var final = res.Uint64()
		if final != 1 {
			b.Fail()
		}
	}
}

func Benchmark_FermatInv(b *testing.B) {
	const BYTES = 32
	var a [BYTES]byte
	var SM2p, _ = new(big.Int).SetString("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF", 16)
	var SM2pm2 big.Int
	SM2pm2.Sub(SM2p, new(big.Int).SetUint64(2))

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		for j := 0; j < BYTES-8; j++ {
			a[j] = (byte)(rand.Uint32() % 256)
		}
		for j := BYTES - 8; j < BYTES; j++ {
			a[j] = 0
		}

		var val = new(big.Int).SetBytes(a[:])
		var inv big.Int

		inv.Exp(val, &SM2pm2, SM2p)

		var res big.Int
		res.Mul(val, &inv)
		res.Mod(&res, SM2p)

		var final = res.Uint64()
		if final != 1 {
			b.Fail()
		}
	}
}

func Benchmark_sm2Inv(b *testing.B) {

	const BYTES = 32

	var res [LIMBS]uint64
	var out, g1, g2, g3 [LIMBS]uint64
	var g [SAT_LIMBS]uint64
	var a [BYTES]uint8

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {
		for j:=0; j<BYTES-8; j++ {
			a[j] = (uint8)(rand.Uint32() % 256)
		}
		for j:=BYTES-8; j<BYTES; j++ {
			a[j] = 0
		}

		sm2FromBytes(&g1, &a)
		sm2FromBytes(&g2, &a)
		sm2FromMontgomery((*sm2NonMontgomeryDomainFieldElement)(&g3), (*sm2MontgomeryDomainFieldElement)(&g2))

		for j:=0; j<LIMBS; j++ {
			g[j] = g3[j]
		}
		g[SAT_LIMBS - 1] = 0

		sm2Inv(&out, &g)

		sm2Mul((*sm2MontgomeryDomainFieldElement)(&res), (*sm2MontgomeryDomainFieldElement)(&out), (*sm2MontgomeryDomainFieldElement)(&g1))
		sm2FromMontgomery((*sm2NonMontgomeryDomainFieldElement)(&out), (*sm2MontgomeryDomainFieldElement)(&res))
		sm2ToBytes(&a, &out)

		if a[0] != 1 {
			b.Fail()
		}
		for j:=1; j<BYTES; j++ {
			if a[j] != 0 {
				b.Fail()
			}
		}

	}
}
