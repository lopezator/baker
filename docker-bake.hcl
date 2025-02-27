variable "DATABASE_URL" {}

group "default" {
  targets = ["prepare", "sanity-check", "test", "build"]
}

target "prepare" {
  target = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/baker:build",
    "type=local,src=/tmp/.go-pkg-mod"
  ]

  cache-to = [
    "type=inline",
    "type=local,dest=/tmp/.go-pkg-mod"
  ]

  output = [
    "type=cacheonly"
  ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=registry,ref=lopezator/baker:cache"
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
    "type=registry,ref=lopezator/baker:cache"
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
    "type=registry,ref=lopezator/baker:cache"
  ]

  tags = [
    "lopezator/baker:build"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:cache,mode=max",
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
