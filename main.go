package main

import (
	"fmt"
	"io"
	"net/http"
)

// Respond to call on endpoint
func respond(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "This is a test endpoint for the Che plugin service")
	fmt.Printf("main.go: Go app endpoint response\n")
}

func main() {
	http.HandleFunc("/", respond)
	fmt.Printf("main.go: Go app listening on port 8080\n")
	http.ListenAndServe(":8080", nil)
}
