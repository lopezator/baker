group "default" {
  targets = ["prepare", "sanity-check", "test", "build"]
}

target "prepare" {
  target     = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/cache-test:build",
    "type=gha,scope=/go/pkg/mod"
  ]

  cache-to = [
    "type=gha,scope=/go/pkg/mod,mode=max"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=gha,scope=/go/pkg/mod",
    "type=gha,scope=/root/.cache/golangci-lint"
  ]

  cache-to = [
    "type=gha,scope=/root/.cache/golangci-lint,mode=max"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "test" {
  target     = "test"
  depends    = ["prepare"]

  cache-from = [
    "type=gha,scope=/go/pkg/mod",
    "type=gha,scope=/root/.cache/go-build"
  ]

  cache-to = [
    "type=gha,scope=/root/.cache/go-build,mode=max"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "build" {
  target     = "build"
  depends    = ["prepare"]

  cache-from = [
    "type=gha,scope=/go/pkg/mod",
    "type=gha,scope=/root/.cache/go-build"
  ]

  cache-to = [
    "type=gha,scope=/root/.cache/go-build,mode=max"
  ]

  tags = [
    "docker.io/lopezator/cache-test:build"
  ]

  output = [
    "type=docker"
  ]
}

target "release" {
  target     = "release"
  depends    = ["build"]

  tags = [
    "docker.io/lopezator/cache-test:latest"
  ]

  output = [
    "type=registry"
  ]
}
