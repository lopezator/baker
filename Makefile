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
	@go test -race -cover -v ./...