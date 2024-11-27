SHELL    ?= /bin/bash
NAME     =  $(shell echo $(PACKAGE) | rev | cut -d/ -f1 | rev)
PLATFORM ?= linux darwin windows
PREFIX   ?= docker.io/lopezator
DOCKER   ?= docker

COMMIT_SHORT     ?= $(shell git rev-parse --verify --short HEAD)
VERSION          ?= v0.0.0-sha.$(COMMIT_SHORT)
VERSION_NOPREFIX ?= $(shell echo $(VERSION) | sed -e 's/^[[v]]*//')

PACKAGE    =  github.com/lopezator/cache-test
PKG        ?= ./...
APP        ?= cache-test
BUILD_TAGS ?= netgo,timetzdata

include .go-builder/Makefile

.PHONY: print-vars
print-vars:
	@echo "APP=$(APP)" >> $GITHUB_ENV
	@echo "PREFIX=$(PREFIX)" >> $GITHUB_ENV
	@echo "NAME=$(NAME)" >> $GITHUB_ENV
	@echo "VERSION_NOPREFIX=$(VERSION_NOPREFIX)" >> $GITHUB_ENV
	@echo "VERSION=$(VERSION)" >> $GITHUB_ENV

.PHONY: prepare
prepare:
	@echo "Running mod download..."
	@go mod download

.PHONY: sanity-check
sanity-check: $(sanity_check_targets)

.PHONY: go-build
go-build:
	@for app in $(APP) ; do \
		for os in $(PLATFORM) ; do \
			ext=""; \
			if [ "$$os" = "windows" ]; then \
				ext=".exe"; \
			fi; \
			GOOS=$$os GOARCH=amd64 CGO_ENABLED=0 \
			GODEBUG=gocachehash=1 go build \
				-x -tags "$(BUILD_TAGS)" -installsuffix "cgo_netgo" \
				-ldflags " \
					-X main.Version=$(VERSION_NOPREFIX) \
					-X main.GitRev=$(COMMIT_SHORT) \
				" \
				-o ./bin/$$app-$(VERSION_NOPREFIX)-$$os-amd64$$ext \
				./cmd/$$app; \
		done; \
	done