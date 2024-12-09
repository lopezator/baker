group "default" {
  targets = ["prepare", "sanity-check", "test", "build", "release"]
}

target "prepare" {
  dockerfile = "Dockerfile.build"
  target     = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/cache-test:build",
    "type=gha,scope=/go/pkg/mod"
  ]

  cache-to = [
    "type=gha,scope=/go/pkg/mod,mode=max"
  ]
}

target "sanity-check" {
  dockerfile = "Dockerfile.build"
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=gha,scope=/go/pkg/mod",
    "type=gha,scope=/root/.cache/golangci-lint"
  ]

  cache-to = [
    "type=gha,scope=/root/.cache/golangci-lint,mode=max"
  ]
}

target "test" {
  dockerfile = "Dockerfile.build"
  target     = "test"
  depends    = ["prepare"]

  cache-from = [
    "type=gha,scope=/go/pkg/mod",
    "type=gha,scope=/root/.cache/go-build"
  ]

  cache-to = [
    "type=gha,scope=/root/.cache/go-build,mode=max"
  ]
}

target "build" {
  dockerfile = "Dockerfile.build"
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
}

target "release" {
  context    = "."
  dockerfile = "Dockerfile.build"
  target     = "release"
  depends    = ["build"]

  tags = [
    "docker.io/lopezator/cache-test:latest"
  ]

  cache-to = [
    "type=registry,ref=lopezator/cache-test:build,mode=max"
  ]
}
