variable "DATABASE_URL" {}

group "default" {
  targets = ["prepare", "sanity-check", "test", "build"]
}

target "prepare" {
  target = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/baker:build",
  ]

  cache-to = [
    "type=inline"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=docker.io/lopezator/baker:build"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "build" {
  target     = "build"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=docker.io/lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,mode=max,ref=docker.io/lopezator/baker:build"
  ]

  tags = [
    "docker.io/lopezator/baker:build"
  ]

  output = [
    "type=docker"
  ]
}

target "test" {
  target     = "test"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=docker.io/lopezator/baker:build"
  ]

  args = {
    DATABASE_URL = "${DATABASE_URL}"
  }

  output = [
    "type=cacheonly"
  ]
}

target "release" {
  target     = "release"
  depends    = ["build"]

  cache-from = [
    "type=registry,ref=docker.io/lopezator/baker:build"
  ]

  tags = [
    "docker.io/lopezator/baker:latest"
  ]

  output = [
    "type=registry"
  ]
}
