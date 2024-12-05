group "default" {
  targets = ["prepare", "sanity-check", "build"]
}

target "prepare" {
  dockerfile = "Dockerfile.build"
  target     = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/cache-test:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/cache-test:build,mode=max"
  ]

  output = [
    "type=docker"
  ]
}

target "sanity-check" {
  dockerfile = "Dockerfile.build"
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=lopezator/cache-test:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/cache-test:build,mode=max"
  ]

  output = [
    "type=docker"
  ]
}

target "build" {
  dockerfile = "Dockerfile.build"
  target     = "build"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=lopezator/cache-test:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/cache-test:build,mode=max"
  ]

  tags = [
    "docker.io/lopezator/cache-test:build"
  ]

  output = [
    "type=registry"
  ]
}

target "release" {
  context    = "."
  dockerfile = "Dockerfile.build"
  target     = "release"
  depends    = ["check-build"]

  cache-from = [
    "type=registry,ref=lopezator/cache-test:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/cache-test:build,mode=max"
  ]

  tags = [
    "docker.io/lopezator/cache-test:latest"
  ]

  output = [
    "type=registry"
  ]
}