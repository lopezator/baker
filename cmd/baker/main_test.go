package main_test

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/DATA-DOG/go-txdb"
	_ "github.com/jackc/pgx/v5/stdlib"
)

func TestPingEndpoint(t *testing.T) {
	// Create a new HTTP request
	req, err := http.NewRequest(http.MethodGet, "/ping", nil)
	if err != nil {
		t.Fatalf("Failed to create request: %v", err)
	}

	// Create a response recorder
	w := httptest.NewRecorder()

	// Create a handler
	handler := http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(map[string]string{"message": "pong"}); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	})

	// Perform the request
	handler.ServeHTTP(w, req)

	// Check the status code
	if w.Code != http.StatusOK {
		t.Fatalf("Expected status code %d, got %d", http.StatusOK, w.Code)
	}

	// Check the response body
	expectedBody := "{\"message\":\"pong\"}\n"
	if w.Body.String() != expectedBody {
		t.Fatalf("Expected body %s, got %s", expectedBody, w.Body.String())
	}
}

func TestDatabase(t *testing.T) {
	db := sql.OpenDB(txdb.New("pgx", "postgres://user:password@172.17.0.1:5432/database"))
	defer db.Close()

	if _, err := db.Exec(`CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, username VARCHAR(50) NOT NULL)`); err != nil {
		t.Fatalf("Failed to create table: %v", err)
	}

	if _, err := db.Exec(`INSERT INTO users(username) VALUES('gopher')`); err != nil {
		t.Fatalf("Failed to insert into database: %v", err)
	}
}
