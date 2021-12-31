// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package sm2

import (
	"io"
	"math/big"
	"smgo/sm2/internal"
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

var one = big.NewInt(1)
var n = internal.Sm2().Params().N

// SignHashed signs the data which have been hashed from message and public parameters
func SignHashed(rand io.Reader, priv, e *[]byte) (r, s []byte, err error) {

	for {
		// k 为敏感数据，应避免在堆上分配
		var K [32]byte
		_, err = io.ReadFull(rand, K[:])
		if err != nil {
			return
		}

		var k big.Int
		k.SetBytes(K[:])
		//k.Mod(k, n) // 注意，这个操作使得k并非在[1, n-1]之间均匀分布，而是偏向于 [1, 2^256 - n] 这个区间，所以我们最好重新抽取一次随机数
		if k.Cmp(n) >= 0 {
			continue
		}

		var kG *internal.SM2Point
		kG, err = internal.ScalarBaseMult_Precomputed_DaA(k.Bytes())
		if err != nil {
			return
		}

		x := kG.GetX() // 避免计算y坐标，可以节约计算量

		var eInt, rInt, sInt, rk, d, d1, d1Inv big.Int

		eInt.SetBytes(*e)
		rInt.Add(x, &eInt)
		rInt.Mod(&rInt, n)

		// 标准要求排除的第一种情形
		if rInt.Sign() == 0 {
			continue
		}

		rk.Add(&rInt, &k)
		// 标准要求排除的第二种情形
		if rk.Cmp(n) == 0 {
			continue
		}

		// 标准要求计算  (k - r * priv) / (1 + priv)
		// 其等价于 （(k + r）/ (1  + priv)) - r，使用后者可以节省一个乘法，而且k + r上面已经计算过了(rk)
		// 注意，求逆的时候我们需要使用常数时间算法，虽然慢一点，但可以保证安全性
		d.SetBytes(*priv)
		d1.Add(&d, one)
		d1Inv.ModInverse(&d1, n) // TODO 常数时间算法
		sInt.Mul(&rk, &d1Inv)
		sInt.Sub(&sInt, &rInt)

		if sInt.Sign() == 0 {
			continue
		}

		return rInt.Bytes(), sInt.Bytes(), nil
	}
}