package fiat

import (
	"fmt"
	"math/big"
	"math/rand"
	"reflect"
	"testing"
)

const BYTES = 32

func Benchmark_Unsafe_LibEEAInv(b *testing.B) {
	var a [BYTES]byte
	var SM2p, _ = new(big.Int).SetString("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF", 16)

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		generateRandom(&a)

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

func Benchmark_Unsafe_LibEEAInv_Scalar(b *testing.B) {
	var a [BYTES]byte
	var SM2n, _ = new(big.Int).SetString("115792089210356248756420345214020892766061623724957744567843809356293439045923", 10)

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		generateRandom(&a)

		var val = new(big.Int).SetBytes(a[:])
		var inv big.Int
		inv.ModInverse(val, SM2n)

		var res big.Int
		res.Mul(val, &inv)
		res.Mod(&res, SM2n)

		var final = res.Uint64()
		if final != 1 {
			b.Fail()
		}
	}
}

func Benchmark_NaiveFermatInv(b *testing.B) {
	var a [BYTES]byte
	var SM2p, _ = new(big.Int).SetString("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF", 16)
	var SM2pm2 big.Int
	SM2pm2.Sub(SM2p, new(big.Int).SetUint64(2))

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		generateRandom(&a)

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

func Benchmark_NaiveFermatInv_Scalar(b *testing.B) {
	var a [BYTES]byte
	var SM2n, _ = new(big.Int).SetString("115792089210356248756420345214020892766061623724957744567843809356293439045923", 10)
	var SM2nm2 big.Int
	SM2nm2.Sub(SM2n, new(big.Int).SetUint64(2))

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		generateRandom(&a)

		var val = new(big.Int).SetBytes(a[:])
		var inv big.Int

		inv.Exp(val, &SM2nm2, SM2n)

		var res big.Int
		res.Mul(val, &inv)
		res.Mod(&res, SM2n)

		var final = res.Uint64()
		if final != 1 {
			b.Fail()
		}
	}
}

func Benchmark_FiatDivStepInv(b *testing.B) {

	var res [LIMBS]uint64
	var out, g1, g2, g3 [LIMBS]uint64
	var g [SAT_LIMBS]uint64
	var a [BYTES]uint8

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		generateRandom(&a)

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

		if out[0] != 1 || out[1] != 0 || out[2] != 0 || out[3] != 0 {
			b.Fail()
		}

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

func Benchmark_FiatFermatInv(b *testing.B) {

	var res [LIMBS]uint64
	var out, g1, g2 [LIMBS]uint64
	var a [BYTES]uint8

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		generateRandom(&a)

		sm2FromBytes(&g1, &a)
		sm2FromBytes(&g2, &a)

		sm2FermatInvert_FiatAC((*sm2MontgomeryDomainFieldElement)(&out), (*sm2MontgomeryDomainFieldElement)(&g2))

		sm2Mul((*sm2MontgomeryDomainFieldElement)(&res), (*sm2MontgomeryDomainFieldElement)(&out), (*sm2MontgomeryDomainFieldElement)(&g1))
		sm2FromMontgomery((*sm2NonMontgomeryDomainFieldElement)(&out), (*sm2MontgomeryDomainFieldElement)(&res))

		if out[0] != 1 || out[1] != 0 || out[2] != 0 || out[3] != 0 {
			b.Fail()
		}

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

func Benchmark_FiatFermatInv_Scalar(b *testing.B) {

	var res [LIMBS]uint64
	var out, g1, g2 [LIMBS]uint64
	var a [BYTES]uint8

	b.ReportAllocs()
	b.ResetTimer()

	for i:=0; i<b.N; i++ {

		generateRandom(&a)

		sm2ScalarFromBytes(&g1, &a)
		sm2ScalarFromBytes(&g2, &a)

		sm2ScalarFermatInvert_FiatAC((*sm2ScalarMontgomeryDomainFieldElement)(&out), (*sm2ScalarMontgomeryDomainFieldElement)(&g2))

		sm2ScalarMul((*sm2ScalarMontgomeryDomainFieldElement)(&res), (*sm2ScalarMontgomeryDomainFieldElement)(&out), (*sm2ScalarMontgomeryDomainFieldElement)(&g1))
		sm2ScalarFromMontgomery((*sm2ScalarNonMontgomeryDomainFieldElement)(&out), (*sm2ScalarMontgomeryDomainFieldElement)(&res))

		if out[0] != 1 || out[1] != 0 || out[2] != 0 || out[3] != 0 {
			b.Fail()
		}

		sm2ScalarToBytes(&a, &out)

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

func generateRandom(a *[BYTES]byte) {

	for j:=0; j<BYTES-8; j++ {
		a[j] = (uint8)(rand.Uint32() % 256)
	}
	for j:=BYTES-8; j<BYTES; j++ {
		a[j] = 0
	}
}

func Test_SquareAndMultiply(t *testing.T) {

	xBytes := make([]byte, 16)
	rand.Read(xBytes)
	x := new(big.Int).SetBytes(xBytes)

	n,_ := new(big.Int).SetString("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54123", 16)
	n2,_ := new(big.Int).SetString("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54121", 16)

	y := new(big.Int).ModInverse(x, n)
	z := squareAndMultiply(x, n2, n)

	if !reflect.DeepEqual(y.Bytes(), z.Bytes()) {
		fmt.Printf("%x\n%x\n", y.Bytes(), z.Bytes())
		t.Fail()
	}
}


func squareAndMultiply(x, power, mod *big.Int) *big.Int {
	out := new(big.Int).SetUint64(1)
	s := 0
	m := 0
	for i:=0; i<256; i++ {
		out.Mul(out, out)
		out.Mod(out, mod)
		s +=1
		if power.Bit(255-i) == 1 {
			out.Mul(out, x)
			out.Mod(out, mod)
			m += 1
		}
	}

	fmt.Printf("square: %d, multiply: %d\n", s, m)

	return out
}


