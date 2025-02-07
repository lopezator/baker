variable "DATABASE_URL" {}

group "default" {
  targets = ["base", "prepare", "sanity-check", "test", "build"]
}

target "base" {
  target = "base"

  cache-from = [
    "type=gha"
  ]

  cache-to = [
    "type=inline,mode=max"
  ]

  output = [
    "type=docker"
  ]
}

target "prepare" {
  target = "prepare"
  depends = ["base"]

  cache-from = [
    "type=gha",
  ]

  output = [
    "type=cacheonly"
  ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=gha"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "test" {
  target     = "test"
  depends    = ["prepare"]

  cache-from = [
    "type=gha"
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
    "type=gha"
  ]

  cache-to = [
    "type=inline,mode=max"
  ]

  tags = [
    "lopezator/baker:build"
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
