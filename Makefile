.PHONY: prepare
prepare:
	@echo "Running mod download..."
	@go mod download

.PHONY: sanity-check
sanity-check:
	@echo "Running golangci-lint..."
	@golangci-lint run ./... -v

.PHONY: go-build
go-build:
	@echo "Building $(APP)..."
	@go build -o /usr/local/bin/cache-test ./cmd/cache-test/main.go