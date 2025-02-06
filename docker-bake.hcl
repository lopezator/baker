variable "DATABASE_URL" {}

group "default" {
  targets = ["base", "prepare", "sanity-check", "test", "build"]
}

target "base" {
  target = "base"

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=inline"
  ]

  output = [
    "type=cacheonly"
  ]
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
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=inline"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "test" {
  target     = "test"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=inline"
  ]

  args = {
    DATABASE_URL = "${DATABASE_URL}"
  }

  output = [
    "type=cacheonly"
  ]
}

target "build" {
  target     = "build"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:build"
  ]

  tags = [
    "lopezator/baker:build"
  ]

  output = [
    "type=docker",
    "type=registry"
  ]
}

target "release" {
  target     = "release"
  depends    = ["build"]

  tags = [
    "lopezator/baker:latest"
  ]

  output = [
    "type=registry"
  ]
}
