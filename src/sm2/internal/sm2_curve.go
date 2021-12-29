// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package internal

//scalar multiplication, returns [x]P when no error
func ScalarMul(P *SM2Point, x []byte) (*SM2Point, error) {
	return nil, nil
}

//scalar base multiplication, retusn [k]G when no error
func ScalarBaseMul(k []byte) (*SM2Point, error) {
	return nil, nil
}

//mixed scalar multiplication, returns [k]G + [x]P when no error
func ScalarMixedMul(k []byte, P *SM2Point, x []byte) (*SM2Point, error) {
	return nil, nil
}

// slow and UNSAFE version first: let's run double and add
// not meant for external use, serves as baseline for correctness
func scalarMult_Unsafe_DaA(q *SM2Point, scalar []byte) (*SM2Point, error) {
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

	return tmp, nil
}

