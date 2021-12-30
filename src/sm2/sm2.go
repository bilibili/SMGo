// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package sm2

import (
	"io"
	"math/big"
	"smgo/sm2/internal"

	//"smgo/sm2/internal"
)

// GenerateKeyWithRand generate private key with provided random source
// note that private key will lie in range [1, n-2] as we need
// to calculate 1/(d + 1) for signature
// private key is used as stack variable and then copied out so that this
// function can securely destroy the key material instead of leaving it in
// heap after generation
func GenerateKeyWithRand(rand io.Reader) (priv []byte, x, y *[]byte, err error) {
	priv = make([]byte, 32)
	var tmp []byte
	return priv, &tmp, &tmp, nil
}

// SignHashed signs the data which have been hashed from message and public parameters
func SignHashed(rand io.Reader, priv, e *[]byte) (r, s []byte, err error) {

	for {
		K := make([]byte, 32)
		rand.Read(K)

		k := new(big.Int).SetBytes(K)
		k.Mod(k, internal.Sm2().Params().N)                           // we shall get n and mod n here according to standard TODO
		kG, err := internal.ScalarBaseMult_Precomputed_DaA(k.Bytes()) // 不直接使用k，它有极小的可能性会是n的倍数
		if err != nil {
			return nil, nil, err
		}

		x := kG.GetX()
		rInt := new(big.Int).Add(x, new(big.Int).SetBytes(*e))
		rInt.Mod(rInt, internal.Sm2().Params().N)

		if rInt.Sign() == 0 {
			continue
		}
		rk := new(big.Int).Add(rInt, k)
		if rk.Mod(rk, internal.Sm2().Params().N).Sign() == 0 {
			continue
		}

		// 标准要求计算  (k - r * priv) / (1 + priv)
		// 但可以计算 （k + r）/ (1  + priv) -r，可以节省一个乘法，而且k + r上面已经计算过了
		// 注意，求逆的时候我们需要使用常数时间算法，虽然慢一点，但可以保证安全性 TODO
		d1 := new(big.Int).Add(new (big.Int).SetBytes(*priv), new(big.Int).SetInt64(1))
		d1Inv := new (big.Int).ModInverse(d1, internal.Sm2().Params().N) // TODO 常数时间算法
		sInt := rk.Mul(rk, d1Inv)
		sInt.Sub(sInt, rInt)

		if sInt.Sign() == 0 {
			continue
		}

		return rInt.Bytes(), sInt.Bytes(), nil
	}
}