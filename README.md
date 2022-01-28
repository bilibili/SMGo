# SMGo

商密算法SM2/3/4的Golang实现，适用于具备64位乘法器的平台。

The Golang implementation of the SM2/3/4 ciphers, suitable for platforms with 64-bit multiplier.

<h3>完全公开 Totally Open</h3>
本实现使用了预计算数据提升性能。所有的预计算程序均已在源程序中提供。

This implementation is totally and completely open in that we provide all the codes to derive the precalculated data. We use these data to enhance the performance.

<h3>SM2</h3>
<h4>侧信道保护 SCA Protection</h4>
本实现使用常数时间算法，通过牺牲一部分性能获得更好的安全性，不会在签名时或执行DH协议时通过运行时间泄漏私钥或者签名随机数信息。这主要包含三部分的安全设计和实现：

1、使用敏感信息做标量乘法的时候，不基于敏感信息作代码分支，避免通过侧信道泄漏信息

2、使用预计算表加速计算的时候，不基于敏感信息进行查表操作，而使用Select方法，以防止通过缓存泄漏信息

3、计算（1 + d）^ -1 mod N 的时候（d为私钥），不使用[扩展欧几里德算法](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm) ，而使用基于[费马小定理](https://en.wikipedia.org/wiki/Fermat%27s_little_theorem) 的方法计算 (1 +d) ^ (N - 2) mod N

This implementation uses constant time algorithm, and trades in some runtime cost for better security. It does not leak timing information of private key or random number during signing or DH protocol. This includes three designs and implementations:

1, When doing scalar multiplication with sensitive information, this implementation does not branch codes based on the sensitive information so that no such information is leaked through side channel

2, When looking up pre-computed tables to speed up calculation, this implementation does not look up the table based on the sensitive information. Select is used instead to prevent cache timing leak.

3, When calculating （1 + d）^ -1 mod N (d is the private key), this implementation does not rely on the [EEA](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm) . Instead it adopts a method based on [Fermat's Little Theorem](https://en.wikipedia.org/wiki/Fermat%27s_little_theorem) to calculate (1 +d) ^ (N - 2) mod N

在其它部分计算已经充分优化的时候，常数时间算法增加了大约30%的开销。

The constant time algorithms take about 30% of total cost after the rest of the computation has been optimized. 

<h4>基于最优实践 Based on Best Practices</h4>
本实现使用了[Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) 项目和[addchain](https://github.com/mmcloughlin/addchain) 项目所生成的代码。其中，[Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) 项目提供了"构造即正确"的素域快速算法，而[addchain](https://github.com/mmcloughlin/addchain) 项目为基于费马小定理求素域乘法逆元的算法提供较为优化的加法链分解方法。

This implementation uses generated codes from [Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) and [addchain](https://github.com/mmcloughlin/addchain) . [Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) provides "correct by construction" codes for fast prime field calculations, and [addchain](https://github.com/mmcloughlin/addchain) provides addition chain decomposition (slighly sub-optimal) for the multiplicative inverse calculation based on Fermat's Little Theorem, in a designated prime field.

基于Golang的标准库，本实现基于雅可比坐标计算点加和倍点的时候，使用[Complete addition formulas for prime order elliptic curves](https://eprint.iacr.org/2015/1060) §A.2 所提供的算法。请注意，SM2定义的曲线符合"a = -3"的前提。

Based on the standard Golang library, this implementation uses the algorithm from [Complete addition formulas for prime order elliptic curves](https://eprint.iacr.org/2015/1060) §A.2 to calculate Point-Add and Point-Double in the Jacobian coordinates. Please note that the curve definition of SM2 meets the prerequisite of "a = -3".

<h4>API设计原则 Principles of API Design</h4>
本实现（将）无运行时内存分配。TODO

This implementation (will) contains no runtime heap allocation. TODO

所需返回值需要调用方提供相应的对象引用，本实现内部不复制私钥等敏感信息。建议调用方在使用后，安全销毁敏感数据。

Caller needs to provide reference so that this implementation can output the return values. This implementation will not copy sensitive information such as private key. Users are suggested to destroy sensitive materials immediately after use of the APIs.

<h3>SM3</h3>

<h3>SM4</h3>

