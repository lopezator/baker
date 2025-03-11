variable "DATABASE_URL" {}

group "default" {
  targets = ["base", "prepare", "sanity-check", "test", "build"]
}

target "base" {
  target = "base"

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "prepare" {
  target = "prepare"
  depends = ["base"]

  output = [
    "type=cacheonly"
  ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]

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

  output = [
    "type=cacheonly"
  ]
}

target "build" {
  target     = "build"
  depends    = ["prepare"]

  tags = [
    "lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:build,mode=max",
  ]

  output = [
    "type=image"
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
