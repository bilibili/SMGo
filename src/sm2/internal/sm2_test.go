// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package internal


import (
	"encoding/hex"
	"fmt"
	"math/big"
	"math/rand"
	"reflect"
	"smgo/sm2/internal/fiat"
	"testing"
)
func makeElement(s string) (*fiat.SM2Element) {
	var e, er =hex.DecodeString(s)
	if er != nil {
		panic("cannot decode hex due to " + er.Error())
	}
	r, er := new (fiat.SM2Element).SetBytes(e)
	return r
}

func TestSM2Point_ScalarMult_1(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// 私钥：3945208F 7B2144B1 3F36E38A C6D39F95 88939369 2860B51A 42FB81EF 4DF7C5B8
	// 公钥x：09F9DF31 1E5421A1 50DD7D16 1E4BC5C6 72179FAD 1833FC07 6BB08FF3 56F35020
	// 公钥y: CCEA490C E26775A5 2DC6EA71 8CC1AA60 0AED05FB F35E084A 6632F607 2DA9AD13
	if !testWithStrings("3945208F7B2144B13F36E38AC6D39F95889393692860B51A42FB81EF4DF7C5B8",
		"09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020",
		"CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13") {
		t.Fail()
	}
}

func TestSM2Point_ScalarMult_2(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// k：59276E27D506861A16680F3AD9C02DCCEF3CC1FA3CDBE4CE6D54B80DEAC1BC21
	// x1：04EBFC718E8D1798620432268E77FEB6415E2EDE0E073C0F4F640ECD2E149A73
	// y1: E858F9D81E5430A57B36DAAB8F950A3C64E6EE6A63094D99283AFF767E124DF0
	if !testWithStrings("59276E27D506861A16680F3AD9C02DCCEF3CC1FA3CDBE4CE6D54B80DEAC1BC21",
		"04EBFC718E8D1798620432268E77FEB6415E2EDE0E073C0F4F640ECD2E149A73",
		"E858F9D81E5430A57B36DAAB8F950A3C64E6EE6A63094D99283AFF767E124DF0") {
		t.Fail()
	}
}

func TestSM2Point_ScalarMult_3(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// s'：B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA
	// x0'：2B9CE14E3C8D1FFC46D693FA0B54F2BDC4825A506607655DE22894B5C99D3746
	// y0': 277BFE04D1E526B4E1C32726435761FBCE0997C26390919C4417B3A0A8639A59
	if !testWithStrings("B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA",
		"2B9CE14E3C8D1FFC46D693FA0B54F2BDC4825A506607655DE22894B5C99D3746",
		"277BFE04D1E526B4E1C32726435761FBCE0997C26390919C4417B3A0A8639A59") {
		t.Fail()
	}
}

func TestSM2Point_ScalarMult_4(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// t：A756E53127F3F43B851C47CFEEFD9E43A2D133CA258EF4EA73FBF4683ACDA13A
	// x00'：FDAC1EFAA770E4635885CA1BBFB360A584B238FB2902ECF09DDC935F60BF4F9B
	// y00': B89AA9263D5632F6EE82222E4D63198E78E095C24042CBE715C23F711422D74C
	// pubx: 09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020
	// puby: CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13

	pub := &SM2Point{
		x: makeElement("09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020"),
		y: makeElement("CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13"),
		z: new(fiat.SM2Element).One(),
	}


	if !testWithStringsAndPoint("A756E53127F3F43B851C47CFEEFD9E43A2D133CA258EF4EA73FBF4683ACDA13A",
		"FDAC1EFAA770E4635885CA1BBFB360A584B238FB2902ECF09DDC935F60BF4F9B",
		"B89AA9263D5632F6EE82222E4D63198E78E095C24042CBE715C23F711422D74C",
		pub) {
		t.Fail()
	}
}

// Tests if calculation leads to infinity how the program handles
func TestSM2Point_ScalarMult_to_inf(t *testing.T) {
	nBytes := sm2.Params().N.Bytes()
	res, err := scalarMult_Unsafe_DaA(NewSM2Generator(), &nBytes)
	if err != nil {
		fmt.Printf("Error: %s", err.Error())
		t.Fail()
	}
	fmt.Printf("[n]G = (%s, %s, %s) %x\n", res.x.ToBigInt().String(), res.y.ToBigInt().String(), res.z.ToBigInt().String(), res.Bytes())
	if res.z.IsZero() == 0 {
		t.Fail()
	}
}

// Tests if calculation leads to infinity how the program handles
func TestSM2Point_ScalarMult_warparound_inf(t *testing.T) {
	np1 := new(big.Int).Set(sm2.Params().N)
	np1.Add(np1, new(big.Int).SetInt64(1))
	np1Bytes := np1.Bytes()
	res, err := scalarMult_Unsafe_DaA(NewSM2Generator(), &np1Bytes)
	if err != nil {
		fmt.Printf("Error: %s", err.Error())
		t.Fail()
	}

	if !reflect.DeepEqual(res.Bytes(), NewSM2Generator().Bytes()) {
		t.Fail()
	}
}

// systematically test if the scalar multiplication can handle values much larger than N
func TestCompleteness(t *testing.T) {
	var bytes [41]byte

	for i:=0; i<1000; i++ {
		rand.Read(bytes[:])
		raw := new (big.Int).SetBytes(bytes[:])
		inrange := new (big.Int).Mod(raw, sm2.Params().N)
		raw = raw.Mul(sm2.Params().N, new (big.Int).SetUint64(rand.Uint64()))
		raw.Add(raw, inrange)

		inrangeBytes, rawBytes := inrange.Bytes(), raw.Bytes()
		res1, _ := scalarMult_Unsafe_DaA(NewSM2Generator(), &inrangeBytes)
		res2, _ := scalarMult_Unsafe_DaA(NewSM2Generator(), &rawBytes)

		if !reflect.DeepEqual(res1.Bytes(), res2.Bytes()) {
			fmt.Printf("round #%d, %x\n", i, sm2.Params().N)
			t.Fail()
		}

	}
}

func TestScalarBaseMult_Precomputed_DaA(t *testing.T) {
	var bytes = make([]byte, 32)


	for i:=0; i< 1000; i++ {
		rand.Read(bytes)

		res1, _ := scalarMult_Unsafe_DaA(NewSM2Generator(), &bytes)
		res2, _ := scalarBaseMult_Precomputed_DaA(bytes[:])
		if !reflect.DeepEqual(res1.Bytes(), res2.Bytes()) {
			t.Fail()
		}
	}

	// Test zero-padded values
	rand.Read(bytes)
	bytes[0] = 0
	bytes[1] = 0
	res1, _ := scalarMult_Unsafe_DaA(NewSM2Generator(), &bytes)
	res2, _ := scalarBaseMult_Precomputed_DaA(bytes[:])
	if !reflect.DeepEqual(res1.Bytes(), res2.Bytes()) {
		t.Fail()
	}

	var bytes2 [33]byte
	rand.Read(bytes2[:])

	_, err2 := scalarBaseMult_Precomputed_DaA(bytes2[:])
	if err2 == nil {
		t.Fail()
	}

	var bytes3 [31]byte
	rand.Read(bytes3[:])

	_, err3 := scalarBaseMult_Precomputed_DaA(bytes3[:])
	if err3 == nil {
		t.Fail()
	}
}

// Tests if the result wraps around infinity how the program handles
func BenchmarkSM2Point_ScalarMult_Unsafe_DaA(b *testing.B) {
	bytes := make([]byte, 32)
	g := NewSM2Generator()

	b.ReportAllocs()
	b.ResetTimer()
	for i:=0; i<b.N; i++ {
		rand.Read(bytes[:])
		scalarMult_Unsafe_DaA(g, &bytes)
	}
}

func BenchmarkScalarBaseMult_Precomputed_DaA(b *testing.B) {
	bytes := new([32]byte)

	b.ReportAllocs()
	b.ResetTimer()
	for i:=0; i<b.N; i++ {
		rand.Read(bytes[:])
		scalarBaseMult_Precomputed_DaA(bytes[:])
	}
}

func testWithStrings(p, x, y string) bool {
	return testWithStringsAndPoint(p, x, y, NewSM2Generator())
}

func testWithStringsAndPoint(p, x, y string, point *SM2Point) bool {
	var q = SM2Point{
		x: makeElement(x),
		y: makeElement(y),
		z: new(fiat.SM2Element).One(),
	}

	var bytes []byte
	bytes = makeElement(p).Bytes()
	res, _ := scalarMult_Unsafe_DaA(point, &bytes)
	if !reflect.DeepEqual(res.Bytes(), q.Bytes()) {
		return false
	}

	larger := makeElement(p).ToBigInt()
	larger.Add(larger, sm2.Params().N) // this shall not change the result if the Add and Double are implemented "completely"
	bytes = larger.Bytes()
	fmt.Printf("larger scalar has %d bytes\n", len(bytes))
	res2, _ := scalarMult_Unsafe_DaA(point, &bytes)
	if !reflect.DeepEqual(res2.Bytes(), res.Bytes()) {
		return false
	}

	return true
}

func Test_MontgomeryFriendlity(t *testing.T) {
	SM2p :=  bigFromHex("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF")
	SM2n :=  bigFromHex("FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54123")

	tellMontgomeryFriendility(SM2p, 64)
	tellMontgomeryFriendility(SM2p, 32)
	tellMontgomeryFriendility(SM2n, 64)
	tellMontgomeryFriendility(SM2n, 32)
}

func tellMontgomeryFriendility(p *big.Int, s uint) {
	ms := big.NewInt(1)
	ms.Lsh(ms, s)

	pInv := new(big.Int).ModInverse(p, ms)
	pInv.Add(pInv, big.NewInt(1))
	pInv.Mod(pInv, ms)
	if pInv.Sign() != 0 {
		fmt.Println(fmt.Sprintf("0x%s is NOT %d-Montgomery friendly.", p.Text(16), s))
	} else {
		fmt.Println(fmt.Sprintf("0x%s is %d-Montgomery friendly.", p.Text(16), s))
	}
}

