package fiat

const LIMBS = 4
const WORD_SIZE = 64
const LEN_PRIME = 256

//#if LEN_PRIME < 46
//#define ITERATIONS (((49 * LEN_PRIME) + 80) / 17)
//#else
//#define ITERATIONS (((49 * LEN_PRIME) + 57) / 17)
//#endif

const ITERATIONS = ((49 * LEN_PRIME) + 57) / 17

const SAT_LIMBS = LIMBS + 1 /* we might need 2 more bits to represent m in twos complement */

// invert g module SM2.p in the Montgomery domain
func sm2Inv(out *[LIMBS]uint64, g *[SAT_LIMBS]uint64) {

	var precomp [LIMBS]uint64
	sm2DivstepPrecomp(&precomp)

	var d uint64 = 1
	var f [SAT_LIMBS]uint64
	var v, r [LIMBS]uint64

	var out1 uint64
	var out2, out3 [SAT_LIMBS]uint64
	var out4, out5 [LIMBS]uint64

	sm2Msat(&f)
	sm2SetOne((*sm2MontgomeryDomainFieldElement)(&r))
	for j := 0; j < LIMBS; j++ {
		v[j] = 0
	}

	for i := 0; i < ITERATIONS-(ITERATIONS%2); i += 2 {
		sm2Divstep(&out1, &out2, &out3, &out4, &out5, d, &f, g, &v, &r)
		sm2Divstep(&d, &f, g, &v, &r, out1, &out2, &out3, &out4, &out5)
	}

	if 0 != ITERATIONS % 2 {
		sm2Divstep(&out1, &out2, &out3, &out4, &out5, d, &f, g, &v, &r)
		for k := 0; k < LIMBS; k++ {
			v[k] = out4[k]
		}
		for k := 0; k < SAT_LIMBS; k++ {
			f[k] = out2[k]
		}
	}

	var h sm2MontgomeryDomainFieldElement
	sm2Opp(&h, (*sm2MontgomeryDomainFieldElement)(&v))
	sm2Selectznz(&v, (sm2Uint1)(f[SAT_LIMBS-1]>>(WORD_SIZE-1)), &v, (*[LIMBS]uint64)(&h))
	sm2Mul((*sm2MontgomeryDomainFieldElement)(out), (*sm2MontgomeryDomainFieldElement)(&v), (*sm2MontgomeryDomainFieldElement)(&precomp))

	return
}
