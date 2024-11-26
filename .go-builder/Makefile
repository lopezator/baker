SANITY_CHECKING_CONFIG ?= .go-builder/.golangci.yml

sanity_check_targets = golangci-lint
build_targets        = go-build
release_targets      = docker-build docker-push

.PHONY: docker-build
docker-build:
	@echo "Building docker image..."
	@if [ -z "$(PREFIX)" ]; then \
		echo "You must define the mandatory PREFIX variable"; \
		exit 1; \
	fi
	@for app in $(APP) ; do \
		cp bin/$$app-$(VERSION_NOPREFIX)-linux-amd64 build/container/$$app-linux-amd64; \
		chmod 0755 build/container/$$app-linux-amd64; \
	done; \
	"$(DOCKER)" build \
		-f build/container/Dockerfile \
		-t $(PREFIX)/$(NAME):$(VERSION) \
	build/container/

.PHONY: docker-push
docker-push:
	@echo "Pushing docker image..."
	@if [ -z "$(PREFIX)" ]; then \
		echo "You must define the mandatory PREFIX variable"; \
		exit 1; \
	fi
	"$(DOCKER)" push $(PREFIX)/$(NAME):$(VERSION); \

.PHONY: golangci-lint
golangci-lint:
	@echo "Running golangci-lint..."
	golangci-lint run $(PKG) --timeout 30m -v --config=$(SANITY_CHECKING_CONFIG)
