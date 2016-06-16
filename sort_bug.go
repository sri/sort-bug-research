// Sorts completes successfully under go1.6 darwin/amd64
// This program was run 100 times.
package main

import (
	"fmt"
	"sort"
	"math/rand"
)

type T struct {
	A, B float32
}

type ByWrongAttr []T

func (t ByWrongAttr) Len() int { return len(t) }
func (t ByWrongAttr) Swap(i, j int)  { t[i], t[j] = t[j], t[i] }

func (t ByWrongAttr) Less(i, j int) bool {
	fmt.Println("comparing (i, j)=", i, j, "t[i].A=", t[i].A, "t[j].B=", t[j].B)
	return t[i].A < t[j].B
}

func randFloat() float32 {
	n := rand.Intn(1500) + 1000
	return float32(n)
}

func main() {
	ts := []T{}

	for i := 0; i < 100000; i++ {
		t := T{randFloat(), randFloat()}
		fmt.Println(t)
		ts = append(ts, t)
	}

	sort.Sort(ByWrongAttr(ts))
	fmt.Println("Done!")
}
