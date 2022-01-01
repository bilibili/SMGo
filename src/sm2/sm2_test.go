package sm2

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"math/big"
	"reflect"
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

func BenchmarkVerifyHashed_Slow(b *testing.B) {
	priv := make([]byte, 32)
	e := make([]byte, 32)

	rand.Read(priv)
	rand.Read(e)
	r, s, err := SignHashed(rand.Reader, &priv, &e)
	if err != nil {
		b.Fail()
	}

	pub, _ := internal.ScalarBaseMult_Precomputed_DaA(priv)
	x := pub.Bytes()[1:33]
	y := pub.Bytes()[33:]

	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		v, err := VerifyHashed_Slow(&x, &y, &e, &r,& s)
		if err != nil {
			fmt.Println(err.Error())
		}
		if !v {
			b.Fail()
		}
	}
}

type myRand struct{}
var myRandVar myRand
func (myRand) Read(b []byte) (n int, err error) {
	k, _ := hex.DecodeString("59276E27D506861A16680F3AD9C02DCCEF3CC1FA3CDBE4CE6D54B80DEAC1BC21")
	for i, _ := range k {
		b[i] = k[i]
	}

	return 32, nil
}

func Test_Sign(t *testing.T) {
	priv, _ := hex.DecodeString("3945208F7B2144B13F36E38AC6D39F95889393692860B51A42FB81EF4DF7C5B8")
	e, _ := hex.DecodeString("F0B43E94BA45ACCAACE692ED534382EB17E6AB5A19CE7B31F4486FDFC0D28640")
	r, _ := hex.DecodeString("F5A03B0648D2C4630EEAC513E1BB81A15944DA3827D5B74143AC7EACEEE720B3")
	s, _ := hex.DecodeString("B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA")

	R, S, err := SignHashed(myRandVar, &priv, &e)

	if err != nil {
		t.Fail()
	}

	if !reflect.DeepEqual(R, r) {
		t.Fail()
	}
	if !reflect.DeepEqual(S, s) {
		t.Fail()
	}
}

func Test_Verify(t *testing.T) {
	pubx, _ := hex.DecodeString("09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020")
	puby, _ := hex.DecodeString("CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13")
	e, _ := hex.DecodeString("F0B43E94BA45ACCAACE692ED534382EB17E6AB5A19CE7B31F4486FDFC0D28640")
	r, _ := hex.DecodeString("F5A03B0648D2C4630EEAC513E1BB81A15944DA3827D5B74143AC7EACEEE720B3")
	s, _ := hex.DecodeString("B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA")

	v, err := VerifyHashed_Slow(&pubx, &puby, &e, &r, &s)
	if err != nil {
		fmt.Println(err.Error())
	}
	if !v {
		t.Fail()
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
	if a != 8 {
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
