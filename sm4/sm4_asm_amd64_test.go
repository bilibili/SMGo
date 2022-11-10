// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64

package sm4

import (
	"fmt"
	"strings"
	"testing"
)

func Test_fillCounterX1(t *testing.T) {
	j0 := []byte{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
	fillCounterX1(&j0[0])
	fmt.Println(j0)
}

func Test_fillCounterX4(t *testing.T) {
	j0 := []byte{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
	fillCounterX4(&j0[0])
	fmt.Println(j0)
}

func Test_concatenateY(t *testing.T){
	y0 := []byte{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,}
	y1 := []byte{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,}
	concatenateY(&y0[0],&y1[0])
	fmt.Println(y0)
}

func Test_concatenateX(t *testing.T){
	x0 := [64]byte{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,}
	x1 := [64]byte{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,}
	x2 := [64]byte{7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7}
	x3 := [64]byte{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,}
	concatenateX(&x0[0], &x1[0], &x2[0], &x3[0])
	fmt.Println(x0)
}

func Test_broadcastJ0(t *testing.T){
	j0 := [64]byte{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,}
	broadcastJ0(&j0[0])
	fmt.Println(j0)
}

func Test_clearRight(t *testing.T){
	state := [16]byte{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,}
	clearRight(&state[0],12)
	fmt.Println(state)
}


func Test_transpose4x4(t *testing.T) {
	plain := makeMatrix()
	out := make([]uint32, 16)
	transpose4x4(&out[0], &plain[0])
	for i := 0; i < 16; i++ {
		fmt.Printf("%02x, ", plain[i])
	}
	fmt.Println()
	result := ""
	for i := 0; i < 16; i++ {
		result += fmt.Sprintf("%02x, ", out[i])
	}

	fmt.Println(result)
	expected := "a0, b0, c0, d0, a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, "

	if strings.Compare(result, expected) != 0 {
		t.Fail()
	}
}

func Test_transpose1x4(t *testing.T) {
	plain := makeMatrix()
	out := make([]uint32, 16)
	transpose1x4(&out[0], &plain[0])
	for i := 0; i < 4; i++ {
		fmt.Printf("%02x, ", plain[i])
	}
	fmt.Println()
	result := ""
	for i := 0; i < 4; i++ {
		result += fmt.Sprintf("%02x, ", out[i*4])
	}

	fmt.Println(result)
	expected := "a0, a1, a2, a3, "

	if strings.Compare(result, expected) != 0 {
		t.Fail()
	}
}

func makeMatrix() []uint32 {
	var ret = make([]uint32, 16)
	ret[0] = 0xa0
	ret[1] = 0xa1
	ret[2] = 0xa2
	ret[3] = 0xa3
	ret[4] = 0xb0
	ret[5] = 0xb1
	ret[6] = 0xb2
	ret[7] = 0xb3
	ret[8] = 0xc0
	ret[9] = 0xc1
	ret[10] = 0xc2
	ret[11] = 0xc3
	ret[12] = 0xd0
	ret[13] = 0xd1
	ret[14] = 0xd2
	ret[15] = 0xd3
	return ret
}
