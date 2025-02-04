DATABASE_URL ?= postgres://user:password@localhost:5432/database

.PHONY: prepare
prepare:
	@echo "Running prepare..."
	@go mod download

.PHONY: sanity-check
sanity-check:
	@echo "Running sanity-check..."
	@golangci-lint run ./... -v

.PHONY: build
build:
	@echo "Running build..."
	@go build -o /usr/local/bin/baker ./cmd/baker/main.go

.PHONY: test
test:
	@echo "Running test..."
	@DATABASE_URL="$(DATABASE_URL)" go test -race -cover -v ./...