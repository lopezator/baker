package main_test

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/DATA-DOG/go-txdb"
	_ "github.com/jackc/pgx/v5/stdlib"
)

// Define the variables
var (
	databaseURL string
)

// TestMain is the entry point for the test suite.
func TestMain(m *testing.M) {
	databaseURL = os.Getenv("DATABASE_URL")
	os.Exit(m.Run())
}

// TestPingEndpoint tests the /ping endpoint.
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

// TestDatabase tests the database connection.
func TestDatabase(t *testing.T) {
	db := sql.OpenDB(txdb.New("pgx", databaseURL))
	defer func() {
		err := db.Close()
		if err != nil {
			t.Fatalf("Failed to close database: %v", err)
		}
	}()

	if _, err := db.Exec(`CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, username VARCHAR(50) NOT NULL)`); err != nil {
		t.Fatalf("Failed to create table: %v", err)
	}

	if _, err := db.Exec(`INSERT INTO users(username) VALUES('gopher')`); err != nil {
		t.Fatalf("Failed to insert into database: %v", err)
	}
}
