package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(map[string]string{"message": "pong"}); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	})
	if err := http.ListenAndServe(":1337", nil); err != nil {
		log.Fatal(err)
	}
}
