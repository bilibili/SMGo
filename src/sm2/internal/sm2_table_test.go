// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com
//

package internal

import (
	"reflect"
	"testing"
)

func Test_6_3_14(t *testing.T) {
	var p, q *SM2Point
	var b []byte

	// test g*
	p = sm2Precomputed_6_3_14[0][0]
	b = makeBigInt([]int64{4})
	q, _ = scalarMult_Unsafe_DaA(NewSM2Generator(), &b)
	if !reflect.DeepEqual(p.Bytes(), q.Bytes_Unsafe()) {
		t.Fail()
	}

	// this one should be [2^210 + 2^168 + 2^126 + 2^84 + 2^42 + 1]G*
	p = sm2Precomputed_6_3_14[0][62]
	b = makeBigInt([]int64{210, 168, 126, 84, 42, 0})
	q, _ = scalarMult_Unsafe_DaA(sm2Precomputed_6_3_14[0][0], &b)
	if !reflect.DeepEqual(p.Bytes(), q.Bytes_Unsafe()) {
		t.Fail()
	}

	// this one should be [2^224 + 2^182 + 2^140 + 2^98 + 2^56 + 2^14]G*
	p = sm2Precomputed_6_3_14[1][62]
	b = makeBigInt([]int64{224, 182, 140, 98, 56, 14})
	q, _ = scalarMult_Unsafe_DaA(sm2Precomputed_6_3_14[0][0], &b)
	if !reflect.DeepEqual(p.Bytes(), q.Bytes_Unsafe()) {
		t.Fail()
	}
}

func Test_4_2_32(t *testing.T) {
	p := sm2Precomputed_4_2_32[0][0]
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