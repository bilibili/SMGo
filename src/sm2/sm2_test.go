package sm2

import (
	"crypto/rand"
	"math/big"
	"smgo/sm2/internal"
	"testing"
)

func BenchmarkSignHashed(b *testing.B) {
	priv := make([]byte, 32)
	e := make([]byte, 32)

	rand.Read(priv)
	rand.Read(e)

	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		SignHashed(rand.Reader, &priv, &e)
	}
}

func Test_RejectNminus1(t *testing.T) {

	for i:=1; i<1000; i++ {
		k := new(big.Int).Mul(internal.Sm2().Params().N, big.NewInt(int64(i)))
		k.Sub(k, big.NewInt(1))
		_, _, err := SignHashed(nil, &nminus1, nil)
		if err == nil {
			t.Fail()
		}
	}

	var bytes []byte

	bytes =	make([]byte, 40)
	a := TestPrivateKey(&bytes)
	if a != 16 {
		t.Fail()
	}

	bytes =	make([]byte, 20)
	a = TestPrivateKey(&bytes)
	if a != -24 {
		t.Fail()
	}

	bytes =	make([]byte, 32)
	rand.Read(bytes[:30])
	a = TestPrivateKey(&bytes)
	if a != 0 {
		t.Fail()
	}

	a = TestPrivateKey(&nminus1)
	if a != -1 {
		t.Fail()
	}

}
