// modified based on the standard go library
// 基于go标准库源程序修改

// 原版权声明如下：

// Copyright 2021 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package internal

import (
	"errors"
	"math/big"
	"smgo/sm2/internal/fiat"
)

const SM2ElementLength = 32
const SM2BytesLengthUncompressed = 1 + 2*SM2ElementLength

// SM2Point is a SM2 point. The zero value is NOT valid.
type SM2Point struct {
	// The point is represented in projective coordinates (X:Y:Z),
	// where x = X/Z and y = Y/Z.
	x, y, z *fiat.SM2Element
}

var sm2B *fiat.SM2Element
var sm2G *SM2Point

func initPoints() {
	sm2B = new (fiat.SM2Element).FromBigInt(sm2.Params().B)
 	sm2G = &SM2Point{
		x: new (fiat.SM2Element).FromBigInt(sm2.Params().Gx),
		y: new (fiat.SM2Element).FromBigInt(sm2.Params().Gy),
		z: new (fiat.SM2Element).One(),
	}
}

// NewSM2Point returns a new SM2Point representing the point at infinity point.
func NewSM2Point() *SM2Point {
	return &SM2Point{
		x: new(fiat.SM2Element),
		y: new(fiat.SM2Element).One(),
		z: new(fiat.SM2Element),
	}
}

// NewSM2Generator returns a new SM2Point set to the canonical generator.
func NewSM2Generator() *SM2Point {
	return (&SM2Point{
		x: new(fiat.SM2Element),
		y: new(fiat.SM2Element),
		z: new(fiat.SM2Element),
	}).Set(sm2G)
}

// Set sets p = q and returns p.
func (p *SM2Point) Set(q *SM2Point) *SM2Point {
	p.x.Set(q.x)
	p.y.Set(q.y)
	p.z.Set(q.z)
	return p
}

// SetBytes sets p to the compressed, uncompressed, or infinity value encoded in
// b, as specified in SEC 1, Version 2.0, Section 2.3.4. If the point is not on
// the curve, it returns nil and an error, and the receiver is unchanged.
// Otherwise, it returns p.
func (p *SM2Point) SetBytes(b []byte) (*SM2Point, error) {
	switch {
	// Point at infinity.
	case len(b) == 1 && b[0] == 0:
		return p.Set(NewSM2Point()), nil

	// Uncompressed form.
	case len(b) == 1 + 2*SM2ElementLength && b[0] == 4:
		x, err := new(fiat.SM2Element).SetBytes(b[1 : 1+SM2ElementLength])
		if err != nil {
			return nil, err
		}
		y, err := new(fiat.SM2Element).SetBytes(b[1+SM2ElementLength:])
		if err != nil {
			return nil, err
		}
		if err := sm2CheckOnCurve(x, y); err != nil {
			return nil, err
		}
		p.x.Set(x)
		p.y.Set(y)
		p.z.One()
		return p, nil

	// Compressed form
	case len(b) == 1+SM2ElementLength && b[0] == 0:
		return nil, errors.New("unimplemented") // TODO(filippo)

	default:
		return nil, errors.New("invalid sm2 point encoding")
	}
}

func sm2CheckOnCurve(x, y *fiat.SM2Element) error {
	// x³ - 3x + b.
	x3 := new(fiat.SM2Element).Square(x)
	x3.Mul(x3, x)

	threeX := new(fiat.SM2Element).Add(x, x)
	threeX.Add(threeX, x)

	x3.Sub(x3, threeX)
	x3.Add(x3, sm2B)

	// y² = x³ - 3x + b
	y2 := new(fiat.SM2Element).Square(y)

	if x3.Equal(y2) != 1 {
		return errors.New("sm2 point not on curve")
	}
	return nil
}

// Bytes returns the uncompressed or infinity encoding of p, as specified in
// SEC 1, Version 2.0, Section 2.3.3. Note that the encoding of the point at
// infinity is shorter than all other encodings.
func (p *SM2Point) Bytes() []byte {
	// This function is outlined to make the allocations inline in the caller
	// rather than happen on the heap.
	var out [SM2BytesLengthUncompressed]byte
	return p.bytes(&out)
}

func (p *SM2Point) bytes(out *[SM2BytesLengthUncompressed]byte) []byte {
	if p.z.IsZero() == 1 {
		return append(out[:0], 0)
	}

	zinv := new(fiat.SM2Element).Invert(p.z)
	xx := new(fiat.SM2Element).Mul(p.x, zinv)
	yy := new(fiat.SM2Element).Mul(p.y, zinv)

	buf := append(out[:0], 4)
	buf = append(buf, xx.Bytes()...)
	buf = append(buf, yy.Bytes()...)
	return buf
}

func (p *SM2Point) GetX() *big.Int {
	zinv := new(fiat.SM2Element).Invert(p.z)
	xx := new(fiat.SM2Element).Mul(p.x, zinv)
	return xx.ToBigInt()
}

// Add sets q = p1 + p2, and returns q. The points may overlap.
func (q *SM2Point) Add(p1, p2 *SM2Point) *SM2Point {
	// Complete addition formula for a = -3 from "Complete addition formulas for
	// prime order elliptic curves" (https://eprint.iacr.org/2015/1060), §A.2.

	t0 := new(fiat.SM2Element).Mul(p1.x, p2.x) // t0 := X1 * X2
	t1 := new(fiat.SM2Element).Mul(p1.y, p2.y) // t1 := Y1 * Y2
	t2 := new(fiat.SM2Element).Mul(p1.z, p2.z) // t2 := Z1 * Z2
	t3 := new(fiat.SM2Element).Add(p1.x, p1.y) // t3 := X1 + Y1
	t4 := new(fiat.SM2Element).Add(p2.x, p2.y) // t4 := X2 + Y2
	t3.Mul(t3, t4)                             // t3 := t3 * t4
	t4.Add(t0, t1)                             // t4 := t0 + t1
	t3.Sub(t3, t4)                             // t3 := t3 - t4
	t4.Add(p1.y, p1.z)                         // t4 := Y1 + Z1
	x3 := new(fiat.SM2Element).Add(p2.y, p2.z) // X3 := Y2 + Z2
	t4.Mul(t4, x3)                             // t4 := t4 * X3
	x3.Add(t1, t2)                             // X3 := t1 + t2
	t4.Sub(t4, x3)                             // t4 := t4 - X3
	x3.Add(p1.x, p1.z)                         // X3 := X1 + Z1
	y3 := new(fiat.SM2Element).Add(p2.x, p2.z) // Y3 := X2 + Z2
	x3.Mul(x3, y3)                             // X3 := X3 * Y3
	y3.Add(t0, t2)                             // Y3 := t0 + t2
	y3.Sub(x3, y3)                             // Y3 := X3 - Y3
	z3 := new(fiat.SM2Element).Mul(sm2B, t2)   // Z3 := b * t2
	x3.Sub(y3, z3)                             // X3 := Y3 - Z3
	z3.Add(x3, x3)                             // Z3 := X3 + X3
	x3.Add(x3, z3)                             // X3 := X3 + Z3
	z3.Sub(t1, x3)                             // Z3 := t1 - X3
	x3.Add(t1, x3)                             // X3 := t1 + X3
	y3.Mul(sm2B, y3)                           // Y3 := b * Y3
	t1.Add(t2, t2)                             // t1 := t2 + t2
	t2.Add(t1, t2)                             // t2 := t1 + t2
	y3.Sub(y3, t2)                             // Y3 := Y3 - t2
	y3.Sub(y3, t0)                             // Y3 := Y3 - t0
	t1.Add(y3, y3)                             // t1 := Y3 + Y3
	y3.Add(t1, y3)                             // Y3 := t1 + Y3
	t1.Add(t0, t0)                             // t1 := t0 + t0
	t0.Add(t1, t0)                             // t0 := t1 + t0
	t0.Sub(t0, t2)                             // t0 := t0 - t2
	t1.Mul(t4, y3)                             // t1 := t4 * Y3
	t2.Mul(t0, y3)                             // t2 := t0 * Y3
	y3.Mul(x3, z3)                             // Y3 := X3 * Z3
	y3.Add(y3, t2)                             // Y3 := Y3 + t2
	x3.Mul(t3, x3)                             // X3 := t3 * X3
	x3.Sub(x3, t1)                             // X3 := X3 - t1
	z3.Mul(t4, z3)                             // Z3 := t4 * Z3
	t1.Mul(t3, t0)                             // t1 := t3 * t0
	z3.Add(z3, t1)                             // Z3 := Z3 + t1

	q.x.Set(x3)
	q.y.Set(y3)
	q.z.Set(z3)
	return q
}

// Double sets q = p + p, and returns q. The points may overlap.
func (q *SM2Point) Double(p *SM2Point) *SM2Point {
	// Complete addition formula for a = -3 from "Complete addition formulas for
	// prime order elliptic curves" (https://eprint.iacr.org/2015/1060), §A.2.

	t0 := new(fiat.SM2Element).Square(p.x)   // t0 := X ^ 2
	t1 := new(fiat.SM2Element).Square(p.y)   // t1 := Y ^ 2
	t2 := new(fiat.SM2Element).Square(p.z)   // t2 := Z ^ 2
	t3 := new(fiat.SM2Element).Mul(p.x, p.y) // t3 := X * Y
	t3.Add(t3, t3)                           // t3 := t3 + t3
	z3 := new(fiat.SM2Element).Mul(p.x, p.z) // Z3 := X * Z
	z3.Add(z3, z3)                           // Z3 := Z3 + Z3
	y3 := new(fiat.SM2Element).Mul(sm2B, t2) // Y3 := b * t2
	y3.Sub(y3, z3)                           // Y3 := Y3 - Z3
	x3 := new(fiat.SM2Element).Add(y3, y3)   // X3 := Y3 + Y3
	y3.Add(x3, y3)                           // Y3 := X3 + Y3
	x3.Sub(t1, y3)                           // X3 := t1 - Y3
	y3.Add(t1, y3)                           // Y3 := t1 + Y3
	y3.Mul(x3, y3)                           // Y3 := X3 * Y3
	x3.Mul(x3, t3)                           // X3 := X3 * t3
	t3.Add(t2, t2)                           // t3 := t2 + t2
	t2.Add(t2, t3)                           // t2 := t2 + t3
	z3.Mul(sm2B, z3)                         // Z3 := b * Z3
	z3.Sub(z3, t2)                           // Z3 := Z3 - t2
	z3.Sub(z3, t0)                           // Z3 := Z3 - t0
	t3.Add(z3, z3)                           // t3 := Z3 + Z3
	z3.Add(z3, t3)                           // Z3 := Z3 + t3
	t3.Add(t0, t0)                           // t3 := t0 + t0
	t0.Add(t3, t0)                           // t0 := t3 + t0
	t0.Sub(t0, t2)                           // t0 := t0 - t2
	t0.Mul(t0, z3)                           // t0 := t0 * Z3
	y3.Add(y3, t0)                           // Y3 := Y3 + t0
	t0.Mul(p.y, p.z)                         // t0 := Y * Z
	t0.Add(t0, t0)                           // t0 := t0 + t0
	z3.Mul(t0, z3)                           // Z3 := t0 * Z3
	x3.Sub(x3, z3)                           // X3 := X3 - Z3
	z3.Mul(t0, t1)                           // Z3 := t0 * t1
	z3.Add(z3, z3)                           // Z3 := Z3 + Z3
	z3.Add(z3, z3)                           // Z3 := Z3 + Z3

	q.x.Set(x3)
	q.y.Set(y3)
	q.z.Set(z3)
	return q
}

// Select sets q to p1 if cond == 1, and to p2 if cond == 0.
func (q *SM2Point) Select(p1, p2 *SM2Point, cond int) *SM2Point {
	q.x.Select(p1.x, p2.x, cond)
	q.y.Select(p1.y, p2.y, cond)
	q.z.Select(p1.z, p2.z, cond)
	return q
}