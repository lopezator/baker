variable "DATABASE_URL" {}

group "default" {
  targets = ["prepare", "sanity-check", "test", "build"]
}

target "prepare" {
  target = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/baker:build",
  ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]
}

target "test" {
  target     = "test"
  depends    = ["prepare"]

  args = {
    DATABASE_URL = "${DATABASE_URL}"
  }
}

target "build" {
  target     = "build"
  depends    = ["prepare"]

  tags = [
    "lopezator/baker:build"
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
