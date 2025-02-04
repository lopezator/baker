variable "DATABASE_URL" {}

group "default" {
  targets = ["prepare", "sanity-check", "test", "build"]
}

target "prepare" {
  target = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:build,mode=max"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:build,mode=max"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "test" {
  target     = "test"
  depends    = ["prepare"]

  args = {
    DATABASE_URL = "${DATABASE_URL}"
  }

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:build,mode=max"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "build" {
  target     = "build"
  depends    = ["prepare"]

  tags = [
    "docker.io/lopezator/baker:build"
  ]

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:build,mode=max"
  ]

  output = [
    "type=docker"
  ]
}

target "release" {
  target     = "release"
  depends    = ["build"]

  tags = [
    "docker.io/lopezator/baker:latest"
  ]

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:build,mode=max"
  ]

  output = [
    "type=registry"
  ]
}
