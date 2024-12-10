group "default" {
  targets = ["prepare", "sanity-check", "test", "build"]
}

target "prepare" {
  target = "prepare"

  cache-from = [
    "type=registry,ref=lopezator/baker:build",
  ]

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

  output = [
    "type=registry"
  ]
}
