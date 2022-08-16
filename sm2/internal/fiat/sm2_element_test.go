package fiat

import (
	"testing"
)

func BenchmarkSM2Element_Select(b *testing.B) {
	p := new (SM2Element).SetRaw([4]uint64{5476392200690447885, 16079532233255329149, 13173625660100026660, 2134660095632755284})
	q := new (SM2Element).SetRaw([4]uint64{15939718978384371190, 6709025625306027763, 14955113773682140610, 17634177402105620167})

	s := new (SM2Element)

	for i:=0; i<b.N; i++ {
		s.Select(p, q, 1)
	}
}
