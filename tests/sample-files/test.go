// test.go — Verify: go-mode or go-ts-mode, REAL TABS (exception), tab-width 4
package main

import (
	"fmt"
	"strings"
)

type Greeter struct {
	Name    string
	Prefix  string
}

func (g *Greeter) Greet() string {
	if g.Prefix != "" {
		return fmt.Sprintf("%s, %s!", g.Prefix, g.Name)
	}
	return fmt.Sprintf("Hello, %s!", g.Name)
}

func main() {
	greeters := []Greeter{
		{Name: "World", Prefix: "Hi"},
		{Name: "Go"},
	}
	for _, g := range greeters {
		msg := g.Greet()
		fmt.Println(strings.ToUpper(msg))
	}
}
