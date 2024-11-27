SANITY_CHECKING_CONFIG ?= .go-builder/.golangci.yml

sanity_check_targets = golangci-lint

.PHONY: golangci-lint
golangci-lint:
	@echo "Running golangci-lint..."
	golangci-lint run $(PKG) --timeout 30m -v --config=$(SANITY_CHECKING_CONFIG)
