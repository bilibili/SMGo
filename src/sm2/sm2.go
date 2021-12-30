// Copyright 2021 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021。作者：郭伟基 guoweiji@bilibili.com

package sm2

import (
	"crypto/rand"
	"io"
	//"smgo/sm2/internal"
)

// GenerateKey generate private key with system default random source
// note that private key must lie in range [1, n-2] as we need
// to calculate 1/(d + 1) for signature
func GenerateKey() (priv, x, y [32]byte, err error) {
	return GenerateKeyWithRand(rand.Reader)
}

// GenerateKeyWithRand generate private key with provided random source
// note that private key must lie in range [1, n-2] as we need
// to calculate 1/(d + 1) for signature
func GenerateKeyWithRand(rand io.Reader) (priv, x, y [32]byte, err error) {
	var tmp [32]byte
	return tmp, tmp, tmp, nil
}