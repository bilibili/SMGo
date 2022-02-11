// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build !amd64 && !arm64
package sm4

import "crypto/cipher"

func newCipher(key []byte) (cipher.Block, error) {
	return newCipherGeneric(key)
}

