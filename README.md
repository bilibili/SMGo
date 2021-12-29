# SMGo

商密算法SM2/3/4的Golang实现，适用于具备64位乘法指令的平台。

The Golang implementation of the SM2/3/4 ciphers, suitable for platforms with 64-bit multiplier.

本实现使用常数时间算法，通过牺牲一小部分性能获得更好的安全性，不会在签名时或执行DH协议时通过运行时间泄漏私钥或者签名随机数信息。

This implementation uses constant time algorithm, and trades in a small runtime cost for better security. It does not leak timing information of private key or random number during signing or DH protocol.

本实现使用了[Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) 项目和[addchain](https://github.com/mmcloughlin/addchain) 项目所生成的代码。

This implementation uses generated codes from [Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) and [addchain](https://github.com/mmcloughlin/addchain) .

基于Golang的标准库，本实现基于雅可比坐标计算点加和倍点的时候，使用[Complete addition formulas for prime order elliptic curves](https://eprint.iacr.org/2015/1060) §A.2 所提供的算法。

Based on the standard Golang library, this implementation uses the algorithm from [Complete addition formulas for prime order elliptic curves](https://eprint.iacr.org/2015/1060) §A.2 to calculate Point-Add and Point-Double in the Jacobian coordinates.