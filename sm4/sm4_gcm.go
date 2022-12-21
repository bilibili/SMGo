// Copyright 2021 ~ 2022 bilibili. All rights reserved. Author: Guo, Weiji guoweiji@bilibili.com
// 哔哩哔哩版权所有 2021 ~ 2022。作者：郭伟基 guoweiji@bilibili.com

//go:build amd64 || arm64

package sm4

import (
	"crypto/cipher"
	"errors"
)

const (
	gcmMinimumTagSize    = 12
	gcmStandardNonceSize = 12
)

type gcmAble interface {
	NewGCM(nonceSize, tagSize int) (cipher.AEAD, error)
}

func (sm4 *sm4CipherAsm) NewGCM(nonceSize, tagSize int) (cipher.AEAD, error) {
	g := &sm4GcmAsm{
		cipher:    sm4,
		roundKeys: sm4.enc[:],
		nonceSize: nonceSize,
		tagSize:   tagSize,
	}
	return g, nil
}

type sm4GcmAsm struct {
	cipher    cipher.Block
	roundKeys []uint32
	nonceSize int
	tagSize   int
}

var errOpen = errors.New("cipher: message authentication failed")

func (g *sm4GcmAsm) NonceSize() int {
	return g.nonceSize
}

func (g *sm4GcmAsm) Overhead() int {
	return g.tagSize
}

//go:noescape
func gHashBlocks(H *byte, tag *byte, data *byte, count int)

