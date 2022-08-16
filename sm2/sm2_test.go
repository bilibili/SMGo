package sm2

import (
	"crypto/rand"
	"encoding/binary"
	"encoding/hex"
	"errors"
	"fmt"
	"math/big"
	"reflect"
	"smgo/sm3"
	"testing"
)

func BenchmarkSignHashed(b *testing.B) {
	priv, _, _, _ := GenerateKey(rand.Reader)

	e := make([]byte, 32)
	rand.Read(e)

	b.SetBytes(1000*1000) // hacking to report ops/s, it will be the number leading MB/s
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		SignHashed(myRandVar, priv, e)
	}
}

func BenchmarkSignZa(b *testing.B) {
	priv, _, _, _ := GenerateKey(rand.Reader)

	za := make([]byte, 32)
	rand.Read(za)

	msg := make([]byte, 32)
	rand.Read(msg)

	b.SetBytes(1000*1000) // hacking to report ops/s, it will be the number leading MB/s
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		SignZa(myRandVar, priv, za, msg)
	}
}

func BenchmarkSign(b *testing.B) {
	priv, x, y, _ := GenerateKey(rand.Reader)

	msg := make([]byte, 32)
	rand.Read(msg)

	id, _ := hex.DecodeString("12345678")

	b.SetBytes(1000*1000) // hacking to report ops/s, it will be the number leading MB/s
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		Sign(id, x, y, myRandVar, priv, msg)
	}
}

func BenchmarkVerifyHashed(b *testing.B) {
	priv, x, y, _ := GenerateKey(rand.Reader)

	e := make([]byte, 32)
	rand.Read(e)

	r, s, err := SignHashed(rand.Reader, priv, e)
	if err != nil {
		b.Fail()
	}

	b.SetBytes(1000*1000) // hacking to report ops/s, it will be the number leading MB/s
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		v, err := VerifyHashed(x, y, e, r, s)
		if err != nil {
			fmt.Println(err.Error())
		}
		if !v {
			b.Fail()
		}
	}
}

func BenchmarkVerifyZa(b *testing.B) {
	priv, x, y, _ := GenerateKey(rand.Reader)

	za := make([]byte, 32)
	rand.Read(za)

	msg := make([]byte, 32)
	rand.Read(msg)


	r, s, err := SignZa(rand.Reader, priv, za, msg)
	if err != nil {
		b.Fail()
	}

	b.SetBytes(1000*1000) // hacking to report ops/s, it will be the number leading MB/s
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		v, err := VerifyZa(x, y, za, msg, r, s)
		if err != nil {
			fmt.Println(err.Error())
		}
		if !v {
			b.Fail()
		}
	}
}

func BenchmarkVerify(b *testing.B) {
	priv, x, y, _ := GenerateKey(rand.Reader)

	msg := make([]byte, 32)
	rand.Read(msg)

	id, _ := hex.DecodeString("12345678")


	r, s, err := Sign(id, x, y, rand.Reader, priv, msg)
	if err != nil {
		b.Fail()
	}

	b.SetBytes(1000*1000) // hacking to report ops/s, it will be the number leading MB/s
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		v, err := Verify(id, x, y, msg, r, s)
		if err != nil {
			fmt.Println(err.Error())
		}
		if !v {
			b.Fail()
		}
	}
}

// copied and renamed function just to test conformity
// actual API function takes in actual SM2 parameters
func za(id, a, b, Gx, Gy, pubx, puby []byte) ([]byte, error) {
	entl := len(id) << 3
	if entl > 1 << 16 {
		return []byte{}, errors.New("entity ID too long")
	}

	var entlBytes [2]byte
	binary.BigEndian.PutUint16(entlBytes[:], uint16(entl))

	hash := sm3.New()
	hash.Write(entlBytes[:])
	hash.Write(id)
	hash.Write(a)
	hash.Write(b)
	hash.Write(Gx)
	hash.Write(Gy)
	hash.Write(pubx)
	hash.Write(puby)

	return hash.Sum(nil), nil
}

// testing spec sample 1
func Test_za(t *testing.T) {
	id, _ := hex.DecodeString("414C494345313233405941484F4F2E434F4D")
	a, _ := hex.DecodeString("787968B4FA32C3FD2417842E73BBFEFF2F3C848B6831D7E0EC65228B3937E498")
	b, _ := hex.DecodeString("63E4C6D3B23B0C849CF84241484BFE48F61D59A5B16BA06E6E12D1DA27C5249A")
	Gx, _ := hex.DecodeString("421DEBD61B62EAB6746434EBC3CC315E32220B3BADD50BDC4C4E6C147FEDD43D")
	Gy, _ := hex.DecodeString("0680512BCBB42C07D47349D2153B70C4E5D7FDFCBFA36EA1A85841B9E46E09A2")
	pubx, _ := hex.DecodeString("0AE4C7798AA0F119471BEE11825BE46202BB79E2A5844495E97C04FF4DF2548A")
	puby, _ := hex.DecodeString("7C0240F88F1CD4E16352A73C17B7F16F07353E53A176D684A9FE0C6BB798E857")
	z, _ := hex.DecodeString("F4A38489E32B45B6F876E3AC2168CA392362DC8F23459C1D1146FC3DBFB7BC9A")

	out, _ := za(id, a, b, Gx, Gy, pubx, puby)

	if !reflect.DeepEqual(z, out[:]) {
		fmt.Printf("out: %X\n", out)
		t.Fail()
	}
}

func TestDerivePublic(t *testing.T) {
	priv, x, y, err := GenerateKey(rand.Reader)

	if err != nil {
		t.Fail()
	}

	px, py, err2 := DerivePublic(priv)

	if err2 != nil {
		t.Fail()
	}

	if !reflect.DeepEqual(x, px) || !reflect.DeepEqual(y, py) {
		t.Fail()
	}
}

type myRand struct{}
var myRandVar myRand
func (myRand) Read(b []byte) (n int, err error) {
	k, _ := hex.DecodeString("59276E27D506861A16680F3AD9C02DCCEF3CC1FA3CDBE4CE6D54B80DEAC1BC21")
	copy(b, k)

	return 32, nil
}

func TestGenerateKey(t *testing.T) {
	for i:=0; i<100000; i++ { // with 100,000 count of random generation, it is expected random numbers larger than n will be generated
		priv, x, y, err := GenerateKey(rand.Reader)

		if err != nil {
			t.Fail()
		}

		dInt := new(big.Int).SetBytes(priv)
		if dInt.Cmp(nMinus1) >= 0 {
			t.Fail()
		}

		if !CheckOnCurve(x, y) {
			t.Fail()
		}
	}
}

func Test_ZA(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	id, _ := hex.DecodeString("31323334353637383132333435363738")
	//M, _ := hex.DecodeString("6D65737361676520646967657374")
	pubx, _ := hex.DecodeString("09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020")
	puby, _ := hex.DecodeString("CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13")
	z, _ := hex.DecodeString("B2E14C5C79C6DF5B85F4FE7ED8DB7A262B9DA7E07CCB0EA9F4747B8CCDA8A4F3")
	za, err := ZA(id, pubx, puby)

	if err != nil || !reflect.DeepEqual(z, za) {
		t.Fail()
	}
}

func Test_Sign(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	id, _ := hex.DecodeString("31323334353637383132333435363738")
	M, _ := hex.DecodeString("6D65737361676520646967657374")
	priv, _ := hex.DecodeString("3945208F7B2144B13F36E38AC6D39F95889393692860B51A42FB81EF4DF7C5B8")
	pubx, _ := hex.DecodeString("09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020")
	puby, _ := hex.DecodeString("CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13")

	z, _ := hex.DecodeString("B2E14C5C79C6DF5B85F4FE7ED8DB7A262B9DA7E07CCB0EA9F4747B8CCDA8A4F3")
	za, err := ZA(id, pubx, puby)
	if err != nil || !reflect.DeepEqual(z, za) {
		t.Fail()
	}

	e, _ := hex.DecodeString("F0B43E94BA45ACCAACE692ED534382EB17E6AB5A19CE7B31F4486FDFC0D28640")
	r, _ := hex.DecodeString("F5A03B0648D2C4630EEAC513E1BB81A15944DA3827D5B74143AC7EACEEE720B3")
	s, _ := hex.DecodeString("B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA")


	R, S, err := SignHashed(myRandVar, priv, e)

	if err != nil {
		t.Fail()
	}

	if !reflect.DeepEqual(R, r) {
		t.Fail()
	}
	if !reflect.DeepEqual(S, s) {
		t.Fail()
	}

	R, S, err = SignZa(myRandVar, priv, z, M)

	if err != nil {
		t.Fail()
	}

	if !reflect.DeepEqual(R, r) {
		t.Fail()
	}
	if !reflect.DeepEqual(S, s) {
		t.Fail()
	}

	R, S, err = Sign(id, pubx, puby, myRandVar, priv, M)

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
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	id, _ := hex.DecodeString("31323334353637383132333435363738")
	M, _ := hex.DecodeString("6D65737361676520646967657374")

	pubx, _ := hex.DecodeString("09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020")
	puby, _ := hex.DecodeString("CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13")

	z, _ := hex.DecodeString("B2E14C5C79C6DF5B85F4FE7ED8DB7A262B9DA7E07CCB0EA9F4747B8CCDA8A4F3")

	e, _ := hex.DecodeString("F0B43E94BA45ACCAACE692ED534382EB17E6AB5A19CE7B31F4486FDFC0D28640")
	r, _ := hex.DecodeString("F5A03B0648D2C4630EEAC513E1BB81A15944DA3827D5B74143AC7EACEEE720B3")
	s, _ := hex.DecodeString("B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA")

	v, err := VerifyHashed(pubx, puby, e, r, s)
	if err != nil {
		fmt.Println(err.Error())
	}
	if !v {
		t.Fail()
	}

	v, err = VerifyZa(pubx, puby, z, M, r, s)
	if err != nil {
		fmt.Println(err.Error())
	}
	if !v {
		t.Fail()
	}

	v, err = Verify(id, pubx, puby, M, r, s)
	if err != nil {
		fmt.Println(err.Error())
	}
	if !v {
		t.Fail()
	}
}

func Test_RejectNminus1(t *testing.T) {

	for i:=1; i<1000; i++ {
		k := new(big.Int).Mul(n, big.NewInt(int64(i)))
		k.Sub(k, big.NewInt(1))
		bytes := nMinus1.Bytes()
		_, _, err := SignHashed(rand.Reader, bytes, bytes)
		if err == nil {
			t.Fail()
		}
	}

	var bytes []byte

	bytes =	make([]byte, 40)
	a := TestPrivateKey(bytes)
	if a != 8 {
		t.Fail()
	}

	bytes =	make([]byte, 32)
	rand.Read(bytes[:30])
	a = TestPrivateKey(bytes)
	if a != 0 {
		t.Fail()
	}

	bytes = nMinus1.Bytes()
	a = TestPrivateKey(bytes)
	if a != -1 {
		t.Fail()
	}

}
