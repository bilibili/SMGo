// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

//go:build ignore

package fiat


import (
	"encoding/hex"
	"math/rand"
	"reflect"
	"testing"
)
// slow and UNSAFE version first: let's run double and add
// not meant for external use, serves as baseline for correctness
func (p *SM2Point) scalarMult_Unsafe_DaA(q *SM2Point, scalar []byte) *SM2Point {
	var tmp = NewSM2Point()
	for _, b := range scalar {
		for bitNum := 0; bitNum < 8; bitNum++ {
			tmp.Double(tmp)
			if b&0x80 == 0x80 {
				tmp.Add(tmp, q)
			}
			b <<= 1
		}
	}

	p.Set(tmp)
	return p
}

func makeElement(s string) (*SM2Element, error) {
	var e, er =hex.DecodeString(s)
	if er != nil {
		panic("cannot decode hex due to " + er.Error())
	}
	return new (SM2Element).SetBytes(e)
}

func TestSM2Point_ScalarMult_1(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// 私钥：3945208F 7B2144B1 3F36E38A C6D39F95 88939369 2860B51A 42FB81EF 4DF7C5B8
	// 公钥x：09F9DF31 1E5421A1 50DD7D16 1E4BC5C6 72179FAD 1833FC07 6BB08FF3 56F35020
	// 公钥y: CCEA490C E26775A5 2DC6EA71 8CC1AA60 0AED05FB F35E084A 6632F607 2DA9AD13
	testWithStrings("3945208F7B2144B13F36E38AC6D39F95889393692860B51A42FB81EF4DF7C5B8",
		"09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020",
		"CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13",
		t)
}

func TestSM2Point_ScalarMult_2(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// k：59276E27D506861A16680F3AD9C02DCCEF3CC1FA3CDBE4CE6D54B80DEAC1BC21
	// x1：04EBFC718E8D1798620432268E77FEB6415E2EDE0E073C0F4F640ECD2E149A73
	// y1: E858F9D81E5430A57B36DAAB8F950A3C64E6EE6A63094D99283AFF767E124DF0
	testWithStrings("59276E27D506861A16680F3AD9C02DCCEF3CC1FA3CDBE4CE6D54B80DEAC1BC21",
		"04EBFC718E8D1798620432268E77FEB6415E2EDE0E073C0F4F640ECD2E149A73",
		"E858F9D81E5430A57B36DAAB8F950A3C64E6EE6A63094D99283AFF767E124DF0",
		t)
}

func TestSM2Point_ScalarMult_3(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// s'：B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA
	// x0'：2B9CE14E3C8D1FFC46D693FA0B54F2BDC4825A506607655DE22894B5C99D3746
	// y0': 277BFE04D1E526B4E1C32726435761FBCE0997C26390919C4417B3A0A8639A59
	testWithStrings("B1B6AA29DF212FD8763182BC0D421CA1BB9038FD1F7F42D4840B69C485BBC1AA",
		"2B9CE14E3C8D1FFC46D693FA0B54F2BDC4825A506607655DE22894B5C99D3746",
		"277BFE04D1E526B4E1C32726435761FBCE0997C26390919C4417B3A0A8639A59",
		t)
}

func TestSM2Point_ScalarMult_4(t *testing.T) {
	// 使用SM2参数定义规范所附录的数据进行基本的正确性测试 GM/T 0003.5 - 2012 A.2
	// 其中，示例数据为：
	// t：A756E53127F3F43B851C47CFEEFD9E43A2D133CA258EF4EA73FBF4683ACDA13A
	// x00'：FDAC1EFAA770E4635885CA1BBFB360A584B238FB2902ECF09DDC935F60BF4F9B
	// y00': B89AA9263D5632F6EE82222E4D63198E78E095C24042CBE715C23F711422D74C

	px, _ := makeElement("09F9DF311E5421A150DD7D161E4BC5C672179FAD1833FC076BB08FF356F35020")
	py, _ := makeElement("CCEA490CE26775A52DC6EA718CC1AA600AED05FBF35E084A6632F6072DA9AD13")
	pub := &SM2Point{
		x: px,
		y: py,
		z: new(SM2Element).One(),
	}


	testWithStringsAndPoint("A756E53127F3F43B851C47CFEEFD9E43A2D133CA258EF4EA73FBF4683ACDA13A",
		"FDAC1EFAA770E4635885CA1BBFB360A584B238FB2902ECF09DDC935F60BF4F9B",
		"B89AA9263D5632F6EE82222E4D63198E78E095C24042CBE715C23F711422D74C",
		pub,
		t)
}

func BenchmarkSM2Point_ScalarMult_Unsafe_DaA(b *testing.B) {
	bytes := new([32]byte)
	g := NewSM2Generator()
	v := NewSM2Point()

	b.ReportAllocs()
	b.ResetTimer()
	for i:=0; i<b.N; i++ {
		rand.Read(bytes[:])
		v.scalarMult_Unsafe_DaA(g, bytes[:])
	}
}

func testWithStrings(p, x, y string, t *testing.T) {
	testWithStringsAndPoint(p, x, y, NewSM2Generator(), t)
}

func testWithStringsAndPoint(p, x, y string, point *SM2Point, t *testing.T) {
	var k, _ = makeElement(p)
	var res = NewSM2Point()
	res.scalarMult_Unsafe_DaA(point, k.Bytes())

	var qx, _ = makeElement(x)
	var qy, _ = makeElement(y)

	var q = SM2Point{
		x: qx,
		y: qy,
		z: new(SM2Element).One(),
	}

	if !reflect.DeepEqual(res.Bytes(), q.Bytes()) {
		t.Fail()
	}
}

