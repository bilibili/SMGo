// Copyright 2021 bilibili. All rights reserved.
// 哔哩哔哩版权所有 2021
// 代码为使用addchain工具自动生成，勿编辑
//    addchain search "115792089210356248756420345214020892766061623724957744567843809356293439045923 - 2" > sm2_scalar.ac
//    addchain gen -tmpl template_scalar.tmpl sm2_scalar.ac > ../SM2_scalar_inverse.go
//
// addchain项目的网络地址为：https://github.com/mmcloughlin/addchain
//
// 背景介绍：
// 素域求逆问题，在考虑安全性的时候，为了避免算法运行时间泄漏私钥信息（例如，SM2的签名算法要求计算d ^ -1），有一种常数时间算法是利用费马小定理：
//    a ^ (p-1) = 1 mod p  其中 a 不是 p 的倍数，而 p 为素数
// 可以得知：
//    a ^ (p-2) 为 a 在 Fp上的乘法逆元。
// 在计算SM2的标量域（mod n）的时候，由于n是固定的，因此可以通过一个对n较为优化的addition chain分解，给出优化的模指数算法去计算 a ^ (n - 2)
// 而addchain (addition chain) 工具能够计算给定素数的较优化的连加链
//
// 相对于通常的EEA算法（一般在大整数类里面实现，无针对性优化），使用费马小定理求逆的代价大约是EEA的两倍。
// 参考: Computing Multiplicative Inverses in GFp (1969, by George E. Collins)
//
// 叠加addchain优化后，可能缩小一部分差距，大约在20% ～ 30%左右。
//
// 具体性能对比需要运行测试

package addchain

// Invert an element in the SM2 scalar field (mod n). Note: this is not a SM2 Curve Field inversion (mod p).
// Output: 1/x mod (SM2 n) if x != 0, and 0 otherwise
func (z *SM2ScalarElement) Invert(x *SM2ScalarElement) *SM2ScalarElement {
	//
	//	_10      = 2*1
	//	_11      = 1 + _10
	//	_100     = 1 + _11
	//	_101     = 1 + _100
	//	_111     = _10 + _101
	//	_1001    = _10 + _111
	//	_1101    = _100 + _1001
	//	_1111    = _10 + _1101
	//	_11110   = 2*_1111
	//	_11111   = 1 + _11110
	//	_111110  = 2*_11111
	//	_111111  = 1 + _111110
	//	_1111110 = 2*_111111
	//	i20      = _1111110 << 6 + _1111110
	//	x18      = i20 << 5 + _111111
	//	x31      = x18 << 13 + i20 + 1
	//	i42      = 2*x31
	//	i44      = i42 << 2
	//	i140     = ((i44 << 32 + i44) << 29 + i42) << 33
	//	i150     = ((i44 + i140 + _111) << 4 + _111) << 3
	//	i170     = ((1 + i150) << 11 + _1111) << 6 + _11111
	//	i183     = ((i170 << 5 + _1101) << 3 + _11) << 3
	//	i198     = ((1 + i183) << 7 + _111) << 5 + _11
	//	i219     = ((i198 << 9 + _101) << 5 + _101) << 5
	//	i231     = ((_1101 + i219) << 5 + _1001) << 4 + _1101
	//	i244     = ((i231 << 2 + _11) << 7 + _111111) << 2
	//	i262     = ((1 + i244) << 10 + _1001) << 5 + _111
	//	i277     = ((i262 << 5 + _111) << 4 + _101) << 4
	//	return     ((_101 + i277) << 9 + _1001) << 5 + 1
	//
	// Operations: 253 squares 41 multiplies
	//
	// Generated by github.com/mmcloughlin/addchain v0.4.0.

	// Allocate Temporaries.
		var (
			t0 = new(SM2ScalarElement)
			t1 = new(SM2ScalarElement)
			t2 = new(SM2ScalarElement)
			t3 = new(SM2ScalarElement)
			t4 = new(SM2ScalarElement)
			t5 = new(SM2ScalarElement)
			t6 = new(SM2ScalarElement)
			t7 = new(SM2ScalarElement)
			t8 = new(SM2ScalarElement)
			t9 = new(SM2ScalarElement))

		
		// Step 1: t2 = x^0x2
		t2.Sqr(x)
		
		// Step 2: t3 = x^0x3
		t3.Mul(x, t2)
		
		// Step 3: t4 = x^0x4
		t4.Mul(x, t3)
		
		// Step 4: t0 = x^0x5
		t0.Mul(x, t4)
		
		// Step 5: t1 = x^0x7
		t1.Mul(t2, t0)
		
		// Step 6: z = x^0x9
		z.Mul(t2, t1)
		
		// Step 7: t4 = x^0xd
		t4.Mul(t4, z)
		
		// Step 8: t6 = x^0xf
		t6.Mul(t2, t4)
		
		// Step 9: t2 = x^0x1e
		t2.Sqr(t6)
		
		// Step 10: t5 = x^0x1f
		t5.Mul(x, t2)
		
		// Step 11: t2 = x^0x3e
		t2.Sqr(t5)
		
		// Step 12: t2 = x^0x3f
		t2.Mul(x, t2)
		
		// Step 13: t7 = x^0x7e
		t7.Sqr(t2)
		
		// Step 19: t8 = x^0x1f80
		t8.Sqr(t7)
		for s := 1; s < 6; s++ {
			t8.Sqr(t8)
		}
		
		// Step 20: t7 = x^0x1ffe
		t7.Mul(t7, t8)
		
		// Step 25: t8 = x^0x3ffc0
		t8.Sqr(t7)
		for s := 1; s < 5; s++ {
			t8.Sqr(t8)
		}
		
		// Step 26: t8 = x^0x3ffff
		t8.Mul(t2, t8)
		
		// Step 39: t8 = x^0x7fffe000
		for s := 0; s < 13; s++ {
			t8.Sqr(t8)
		}
		
		// Step 40: t7 = x^0x7ffffffe
		t7.Mul(t7, t8)
		
		// Step 41: t7 = x^0x7fffffff
		t7.Mul(x, t7)
		
		// Step 42: t8 = x^0xfffffffe
		t8.Sqr(t7)
		
		// Step 44: t7 = x^0x3fffffff8
		t7.Sqr(t8)
		for s := 1; s < 2; s++ {
			t7.Sqr(t7)
		}
		
		// Step 76: t9 = x^0x3fffffff800000000
		t9.Sqr(t7)
		for s := 1; s < 32; s++ {
			t9.Sqr(t9)
		}
		
		// Step 77: t9 = x^0x3fffffffbfffffff8
		t9.Mul(t7, t9)
		
		// Step 106: t9 = x^0x7fffffff7fffffff00000000
		for s := 0; s < 29; s++ {
			t9.Sqr(t9)
		}
		
		// Step 107: t8 = x^0x7fffffff7ffffffffffffffe
		t8.Mul(t8, t9)
		
		// Step 140: t8 = x^0xfffffffefffffffffffffffc00000000
		for s := 0; s < 33; s++ {
			t8.Sqr(t8)
		}
		
		// Step 141: t7 = x^0xfffffffefffffffffffffffffffffff8
		t7.Mul(t7, t8)
		
		// Step 142: t7 = x^0xfffffffeffffffffffffffffffffffff
		t7.Mul(t1, t7)
		
		// Step 146: t7 = x^0xfffffffeffffffffffffffffffffffff0
		for s := 0; s < 4; s++ {
			t7.Sqr(t7)
		}
		
		// Step 147: t7 = x^0xfffffffeffffffffffffffffffffffff7
		t7.Mul(t1, t7)
		
		// Step 150: t7 = x^0x7fffffff7fffffffffffffffffffffffb8
		for s := 0; s < 3; s++ {
			t7.Sqr(t7)
		}
		
		// Step 151: t7 = x^0x7fffffff7fffffffffffffffffffffffb9
		t7.Mul(x, t7)
		
		// Step 162: t7 = x^0x3fffffffbfffffffffffffffffffffffdc800
		for s := 0; s < 11; s++ {
			t7.Sqr(t7)
		}
		
		// Step 163: t6 = x^0x3fffffffbfffffffffffffffffffffffdc80f
		t6.Mul(t6, t7)
		
		// Step 169: t6 = x^0xfffffffeffffffffffffffffffffffff7203c0
		for s := 0; s < 6; s++ {
			t6.Sqr(t6)
		}
		
		// Step 170: t5 = x^0xfffffffeffffffffffffffffffffffff7203df
		t5.Mul(t5, t6)
		
		// Step 175: t5 = x^0x1fffffffdfffffffffffffffffffffffee407be0
		for s := 0; s < 5; s++ {
			t5.Sqr(t5)
		}
		
		// Step 176: t5 = x^0x1fffffffdfffffffffffffffffffffffee407bed
		t5.Mul(t4, t5)
		
		// Step 179: t5 = x^0xfffffffeffffffffffffffffffffffff7203df68
		for s := 0; s < 3; s++ {
			t5.Sqr(t5)
		}
		
		// Step 180: t5 = x^0xfffffffeffffffffffffffffffffffff7203df6b
		t5.Mul(t3, t5)
		
		// Step 183: t5 = x^0x7fffffff7fffffffffffffffffffffffb901efb58
		for s := 0; s < 3; s++ {
			t5.Sqr(t5)
		}
		
		// Step 184: t5 = x^0x7fffffff7fffffffffffffffffffffffb901efb59
		t5.Mul(x, t5)
		
		// Step 191: t5 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac80
		for s := 0; s < 7; s++ {
			t5.Sqr(t5)
		}
		
		// Step 192: t5 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac87
		t5.Mul(t1, t5)
		
		// Step 197: t5 = x^0x7fffffff7fffffffffffffffffffffffb901efb590e0
		for s := 0; s < 5; s++ {
			t5.Sqr(t5)
		}
		
		// Step 198: t5 = x^0x7fffffff7fffffffffffffffffffffffb901efb590e3
		t5.Mul(t3, t5)
		
		// Step 207: t5 = x^0xfffffffeffffffffffffffffffffffff7203df6b21c600
		for s := 0; s < 9; s++ {
			t5.Sqr(t5)
		}
		
		// Step 208: t5 = x^0xfffffffeffffffffffffffffffffffff7203df6b21c605
		t5.Mul(t0, t5)
		
		// Step 213: t5 = x^0x1fffffffdfffffffffffffffffffffffee407bed6438c0a0
		for s := 0; s < 5; s++ {
			t5.Sqr(t5)
		}
		
		// Step 214: t5 = x^0x1fffffffdfffffffffffffffffffffffee407bed6438c0a5
		t5.Mul(t0, t5)
		
		// Step 219: t5 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814a0
		for s := 0; s < 5; s++ {
			t5.Sqr(t5)
		}
		
		// Step 220: t5 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad
		t5.Mul(t4, t5)
		
		// Step 225: t5 = x^0x7fffffff7fffffffffffffffffffffffb901efb590e30295a0
		for s := 0; s < 5; s++ {
			t5.Sqr(t5)
		}
		
		// Step 226: t5 = x^0x7fffffff7fffffffffffffffffffffffb901efb590e30295a9
		t5.Mul(z, t5)
		
		// Step 230: t5 = x^0x7fffffff7fffffffffffffffffffffffb901efb590e30295a90
		for s := 0; s < 4; s++ {
			t5.Sqr(t5)
		}
		
		// Step 231: t4 = x^0x7fffffff7fffffffffffffffffffffffb901efb590e30295a9d
		t4.Mul(t4, t5)
		
		// Step 233: t4 = x^0x1fffffffdfffffffffffffffffffffffee407bed6438c0a56a74
		for s := 0; s < 2; s++ {
			t4.Sqr(t4)
		}
		
		// Step 234: t3 = x^0x1fffffffdfffffffffffffffffffffffee407bed6438c0a56a77
		t3.Mul(t3, t4)
		
		// Step 241: t3 = x^0xfffffffeffffffffffffffffffffffff7203df6b21c6052b53b80
		for s := 0; s < 7; s++ {
			t3.Sqr(t3)
		}
		
		// Step 242: t2 = x^0xfffffffeffffffffffffffffffffffff7203df6b21c6052b53bbf
		t2.Mul(t2, t3)
		
		// Step 244: t2 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefc
		for s := 0; s < 2; s++ {
			t2.Sqr(t2)
		}
		
		// Step 245: t2 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefd
		t2.Mul(x, t2)
		
		// Step 255: t2 = x^0xfffffffeffffffffffffffffffffffff7203df6b21c6052b53bbf400
		for s := 0; s < 10; s++ {
			t2.Sqr(t2)
		}
		
		// Step 256: t2 = x^0xfffffffeffffffffffffffffffffffff7203df6b21c6052b53bbf409
		t2.Mul(z, t2)
		
		// Step 261: t2 = x^0x1fffffffdfffffffffffffffffffffffee407bed6438c0a56a777e8120
		for s := 0; s < 5; s++ {
			t2.Sqr(t2)
		}
		
		// Step 262: t2 = x^0x1fffffffdfffffffffffffffffffffffee407bed6438c0a56a777e8127
		t2.Mul(t1, t2)
		
		// Step 267: t2 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefd024e0
		for s := 0; s < 5; s++ {
			t2.Sqr(t2)
		}
		
		// Step 268: t1 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefd024e7
		t1.Mul(t1, t2)
		
		// Step 272: t1 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefd024e70
		for s := 0; s < 4; s++ {
			t1.Sqr(t1)
		}
		
		// Step 273: t1 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefd024e75
		t1.Mul(t0, t1)
		
		// Step 277: t1 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefd024e750
		for s := 0; s < 4; s++ {
			t1.Sqr(t1)
		}
		
		// Step 278: t0 = x^0x3fffffffbfffffffffffffffffffffffdc80f7dac871814ad4eefd024e755
		t0.Mul(t0, t1)
		
		// Step 287: t0 = x^0x7fffffff7fffffffffffffffffffffffb901efb590e30295a9ddfa049ceaa00
		for s := 0; s < 9; s++ {
			t0.Sqr(t0)
		}
		
		// Step 288: z = x^0x7fffffff7fffffffffffffffffffffffb901efb590e30295a9ddfa049ceaa09
		z.Mul(z, t0)
		
		// Step 293: z = x^0xfffffffeffffffffffffffffffffffff7203df6b21c6052b53bbf40939d54120
		for s := 0; s < 5; s++ {
			z.Sqr(z)
		}
		
		// Step 294: z = x^0xfffffffeffffffffffffffffffffffff7203df6b21c6052b53bbf40939d54121
		z.Mul(x, z)
		
		return z
	}
