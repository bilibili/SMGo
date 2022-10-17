# SMGo

商密算法SM2/3/4的Golang实现，适用于具备64位乘法器的平台。

The Golang implementation of the SM2/3/4 ciphers, suitable for platforms with 64-bit multiplier.

## 完全公开 Totally Open

本实现使用了预计算数据提升性能。所有的预计算程序均已在源程序中提供。

This implementation is totally and completely open in that we provide all the codes to derive the precalculated data. We use these data to enhance the performance.

## SM2
### 侧信道保护 SCA Protection

本实现使用常数时间算法，通过牺牲一部分性能获得更好的安全性，不会在签名时或执行DH协议时通过运行时间泄漏私钥或者签名随机数信息。这主要包含三部分的安全设计和实现（可参见“哔哩哔哩技术“公众号相关文章，关注后搜索“常数时间国密算法”即可）：

1、使用敏感信息做标量乘法的时候，不基于敏感信息作代码分支，避免通过侧信道泄漏信息

2、使用预计算表加速计算的时候，不基于敏感信息进行查表操作，而使用Select方法，以防止通过缓存泄漏信息

3、计算(1+d)<sup>-1</sup> mod N 的时候（d为私钥），不使用[扩展欧几里德算法](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm) ，而使用基于[费马小定理](https://en.wikipedia.org/wiki/Fermat%27s_little_theorem) 的方法计算 (1+d)<sup>N-2</sup> mod N

This implementation uses constant time algorithm, and trades in some runtime cost for better security. It does not leak timing information of private key or random number during signing or DH protocol. This includes three designs and implementations:

1, When doing scalar multiplication with sensitive information, this implementation does not branch codes based on the sensitive information so that no such information is leaked through side channel

2, When looking up pre-computed tables to speed up calculation, this implementation does not look up the table based on the sensitive information. Select is used instead to prevent cache timing leak.

3, When calculating (1+d)<sup>-1</sup> mod N (d is the private key), this implementation does not rely on the [EEA](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm) . Instead it adopts a method based on [Fermat's Little Theorem](https://en.wikipedia.org/wiki/Fermat%27s_little_theorem) to calculate (1+d)<sup>N-2</sup> mod N

在其它部分计算已经充分优化的时候，常数时间算法增加了大约30%的开销。

The constant time algorithms take about 30% of total cost after the rest of the computation has been optimized.

### 基于最优实践 Based on Best Practices

本实现使用了[Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) 项目和[addchain](https://github.com/mmcloughlin/addchain) 项目所生成的代码。其中，[Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) 项目提供了"构造即正确"的素域快速算法，而[addchain](https://github.com/mmcloughlin/addchain) 项目为基于费马小定理求素域乘法逆元的算法提供较为优化的加法链分解方法。

This implementation uses generated codes from [Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) and [addchain](https://github.com/mmcloughlin/addchain) . [Fiat-Crypto](https://github.com/mit-plv/fiat-crypto) provides "correct by construction" codes for fast prime field calculations, and [addchain](https://github.com/mmcloughlin/addchain) provides addition chain decomposition (slighly sub-optimal) for the multiplicative inverse calculation based on Fermat's Little Theorem, in a designated prime field.

基于Golang的标准库，本实现基于雅可比坐标计算点加和倍点的时候，使用[Complete addition formulas for prime order elliptic curves](https://eprint.iacr.org/2015/1060) §A.2 所提供的算法。请注意，SM2定义的曲线符合"a = -3"的前提。

Based on the standard Golang library, this implementation uses the algorithm from [Complete addition formulas for prime order elliptic curves](https://eprint.iacr.org/2015/1060) §A.2 to calculate Point-Add and Point-Double in the Jacobian coordinates. Please note that the curve definition of SM2 meets the prerequisite of "a = -3".

### API设计原则 Principles of API Design

本实现（将）无运行时内存分配。TODO

This implementation (will) contains no runtime heap allocation. TODO

所需返回值需要调用方提供相应的对象引用，本实现内部不复制私钥等敏感信息。建议调用方在使用后，安全销毁敏感数据。

Caller needs to provide reference so that this implementation can output the return values. This implementation will not copy sensitive information such as private key. Users are suggested to destroy sensitive materials immediately after use of the APIs.

## SM3

## SM4
为了支持Golang标准库的范例，我们实现了sm4.NewCipher函数。使用该函数有一定的可能性将导致扩展密钥数据被Golang的垃圾回收器或者操作系统拷贝到其它内存地址或者磁盘。用户需要限制所创建对象的使用范围。

To follow the convention of Golang standard library, we implement the sm4.NewCipher function. There is possibility that the expanded key be copied around by GC or OS. User should limit the scope of the created object.

为了实现常数时间算法，我们在arm64平台上使用NEON指令集完成了SM4的密钥扩展和加解密计算，并使性能进一步提升。在amd64平台上，我们使用了AVX512F和GFNI扩展，大部分较新的Intel处理器都应该支持。参见[Efficient Constant-Time Implementation of SM4 with Intel GFNI instruction set extension and Arm NEON coprocessor](https://eprint.iacr.org/2022/1154)

不支持的CPU将自动运行Go语言版本，其并非常数时间实现。

To facilitate constant time implementation, we use NEON instructions in arm64 for key expansion and encryption/decryption. The performance is also improved. With amd64, we use the AVX512F and GFNI extention, which should be available in most recent Intel CPUs. See [Efficient Constant-Time Implementation of SM4 with Intel GFNI instruction set extension and Arm NEON coprocessor](https://eprint.iacr.org/2022/1154)

For those amd64 CPUs without the said GFNI feature, the Golang implementation will run, and it is NOT constant time.

## GCM
我们为SM4实现了优化的GCM模式。

We implemented optimized Galois Counter Mode for SM4.

## TODO list
通过为X16函数引入block count参数，还可以平摊一次性开销，得到进一步优化。但不需要单独实施，意义不大，应该结合GCM模式做。 目前SM4和GCM是分开实现的，未来可以通过将它们"缝合"在一起而得到进一步的优化，即中间数据不写入内存而是在寄存器中直接再进行GCM计算，同时完成上述多块连续计算优化。

## 授权协议 License
SMGo通过BSD 3-Clause 版权协议授权，详情请参见[LICENSE](LICENSE)文件。该文件包括SMGo内部所使用第三方工具或代码所遵循的版权声明以及授权条款。

SMGo is licensed under BSD 3-Clause. Please refer to [LICENSE](LICENSE) for details, which also includes copyright statements and license terms & conditions for the third party tools and codes used by SMGo.