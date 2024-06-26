package main

import (
	"flag"
	"fmt"
	"net/http"
)

func main() {
	var port string
	flag.StringVar(&port, "port", "8000", "the port of http file server")
	flag.Parse()

	fmt.Printf("Serving HTTP on 0.0.0.0 port %s ...\n", port)
	h := http.FileServer(http.Dir("."))
	http.ListenAndServe(":"+port, h)
}
