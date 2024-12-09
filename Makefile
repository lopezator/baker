.PHONY: prepare
prepare:
	@echo "Running mod download..."
	@go mod download

.PHONY: sanity-check
sanity-check:
	@echo "Running golangci-lint..."
	@golangci-lint run ./... -v

.PHONY: build
build:
	@echo "Running build..."
	@go build -o /usr/local/bin/cache-test ./cmd/cache-test/main.go

.PHONY: test
test:
	@echo "Running tests..."
	@go test -race -cover -v ./...