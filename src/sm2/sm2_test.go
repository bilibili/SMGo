package sm2

import (
	"crypto/rand"
	"testing"
)

func BenchmarkSignHashed(b *testing.B) {
	priv := make([]byte, 32)
	e := make([]byte, 32)

	rand.Read(priv)
	rand.Read(e)

	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		SignHashed(rand.Reader, &priv, &e)
	}
}
