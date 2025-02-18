variable "DATABASE_URL" {}

group "default" {
  targets = ["base", "prepare", "sanity-check", "test", "build"]
}

target "base" {
  target = "base"

  cache-from = [
    "type=registry,ref=lopezator/baker:cache",
    #"type=local,src=/tmp/.buildx-cache"
  ]

  tags = [
    "lopezator/baker:cache"
  ]

  cache-to = [
    "type=registry,ref=lopezator/baker:cache,mode=max",
    #"type=local,dest=/tmp/.buildx-cache"
  ]

  # Export as a Docker image
  output = [
    "type=image"
  ]
}

target "prepare" {
  target = "prepare"

  # This step requires to have the cache prepared from the previous build.
  depends = ["base"]

  # We are just download go modules here, and that cache is handled by buildkit cache dance, nothing to cache here
  # regarding buildkit.
  # Using type=cacheonly ensures that the build output is effectively discarded; the layers are saved to BuildKit's
  # cache, but Buildx will not attempt to load the result to the Docker Engine's image store.
  # output = [
  #   "type=cacheonly"
  # ]
}

target "sanity-check" {
  target     = "sanity-check"
  depends    = ["prepare"]

  cache-from = [
    "type=gha"
  ]

  cache-to = [
    "type=gha,mode=max",
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

  cache-to = [
    "type=gha,mode=max",
  ]

  args = {
    DATABASE_URL = "${DATABASE_URL}"
  }

  output = [
    "type=image"
  ]
}

target "build" {
  target     = "build"
  depends    = ["prepare"]

  cache-from = [
    "type=gha"
  ]

  cache-to = [
    "type=gha,mode=max",
  ]

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
