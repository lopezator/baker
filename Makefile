SHELL    ?= /bin/bash
NAME     =  $(shell echo $(PACKAGE) | rev | cut -d/ -f1 | rev)
PLATFORM ?= linux darwin windows
PREFIX   ?= docker.io/lopezator/cache-test
DOCKER   ?= docker

COMMIT_SHORT     ?= $(shell git rev-parse --verify --short HEAD)
VERSION          ?= v0.0.0-sha.$(COMMIT_SHORT)
VERSION_NOPREFIX ?= $(shell echo $(VERSION) | sed -e 's/^[[v]]*//')

PACKAGE    =  github.com/lopezator/cache-test
PKG        ?= ./...
APP        ?= cache-test
BUILD_TAGS ?= netgo,timetzdata


.PHONY: prepare
prepare:
	@echo "Running mod download..."
	@go mod download

.PHONY: build
build: go-build docker-build

.PHONY: go-build
go-build:
	@for app in $(APP) ; do \
		for os in $(PLATFORM) ; do \
			ext=""; \
			if [ "$$os" == "windows" ]; then \
				ext=".exe"; \
			fi; \
			GOOS=$$os GOARCH=amd64 CGO_ENABLED=0 \
			go build \
				-a -x -tags "$(BUILD_TAGS)" -installsuffix cgo -installsuffix netgo \
				-ldflags " \
					-X main.Version=$(VERSION_NOPREFIX) \
					-X main.GitRev=$(COMMIT_SHORT) \
				" \
				-o ./bin/$$app-$(VERSION_NOPREFIX)-$$os-amd64$$ext \
				./cmd/$$app; \
		done; \
	done

.PHONY: docker-build
docker-build:
	@set -x
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

.PHONY: sanity-check
sanity-check:
	ls -la ~
	ls -la ~/.cache/golangci-lint
	golangci-lint run $(PKG) --timeout 30m -v