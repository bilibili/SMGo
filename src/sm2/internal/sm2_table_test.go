// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com
//
//go:build tablegen

package internal

import (
	"reflect"
	"smgo/sm2/internal/fiat"
	"testing"
)

func Test_6_3_14(t *testing.T) {
	var q *SM2Point
	var b []byte

	// test g*
	px := sm2Precomputed_6_3_14[0][0][0]
	py := sm2Precomputed_6_3_14[0][1][0]
	p := makePoint(px, py)

	b = makeBigInt([]int64{4})
	q, _ = scalarMult_Unsafe_DaA(NewSM2Generator(), &b)

	if !reflect.DeepEqual(p.Bytes_Unsafe(), q.Bytes_Unsafe()) {
		t.Fail()
	}

	// this one should be [2^210 + 2^168 + 2^126 + 2^84 + 2^42 + 1]G*
	px = sm2Precomputed_6_3_14[0][0][62]
	py = sm2Precomputed_6_3_14[0][1][62]
	p = makePoint(px, py)

	b = makeBigInt([]int64{210, 168, 126, 84, 42, 0})
	q, _ = scalarMult_Unsafe_DaA(makePoint(sm2Precomputed_6_3_14[0][0][0], sm2Precomputed_6_3_14[0][1][0]), &b)
	if !reflect.DeepEqual(p.Bytes_Unsafe(), q.Bytes_Unsafe()) {
		t.Fail()
	}

	// this one should be [2^224 + 2^182 + 2^140 + 2^98 + 2^56 + 2^14]G*
	px = sm2Precomputed_6_3_14[1][0][62]
	py = sm2Precomputed_6_3_14[1][1][62]
	p = makePoint(px, py)

	b = makeBigInt([]int64{224, 182, 140, 98, 56, 14})
	q, _ = scalarMult_Unsafe_DaA(makePoint(sm2Precomputed_6_3_14[0][0][0], sm2Precomputed_6_3_14[0][1][0]), &b)
	if !reflect.DeepEqual(p.Bytes_Unsafe(), q.Bytes_Unsafe()) {
		t.Fail()
	}
}

func makePoint(xx, yy *[4]uint64) *SM2Point {
	return &SM2Point {
		x: new (fiat.SM2Element).SetRaw(*xx),
		y: new (fiat.SM2Element).SetRaw(*yy),
		z: new(fiat.SM2Element).One(),
	}
}

func Test_4_2_32(t *testing.T) {
	p := makePoint(sm2Precomputed_4_2_32[0][0][0], sm2Precomputed_4_2_32[0][1][0])
	if !reflect.DeepEqual(p.Bytes(), NewSM2Generator().Bytes()) {
		t.Fail()
	}
}

func makeBigInt(setBits []int64) []byte {
	bytes := make([]byte, 32)

	for _, bit := range setBits {
		bytes[31 - bit>>3] |= 1<<(bit&7)
	}

	return bytes
}

func Test_selectPoints(t *testing.T) {
	for i:=1; i<=len(sm2Precomputed_6_3_14_Remainder[0]); i++ {
		p := NewSM2Point()
		selectPoints(p, &sm2Precomputed_6_3_14_Remainder, 15, byte(i))
		q := makePoint(sm2Precomputed_6_3_14_Remainder[0][i-1], sm2Precomputed_6_3_14_Remainder[1][i-1])
		if !reflect.DeepEqual(p.Bytes(), q.Bytes()) {
			t.Fail()
		}
	}
}

