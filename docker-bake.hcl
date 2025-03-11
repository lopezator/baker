variable "DATABASE_URL" {}

variable "GOLANG_IMAGE" {
  default = "golang:1.23.2-bullseye"
}

group "default" {
  targets = ["prepare", "sanity-check", "test", "build"]
}

target "prepare" {
  target = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/baker:build"
  ]

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

  output = [
    "type=cacheonly"
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
