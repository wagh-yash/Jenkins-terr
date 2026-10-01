terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}
provider "docker" {}
# Pull the hello-world image
resource "docker_image" "hello" {
  name = "hello-world:latest"
}
# Run the hello-world container
resource "docker_container" "hello" {
  name     = "hello-from-terraform"
  image    = docker_image.hello.image_id
  must_run = false # hello-world prints a message and exits
  attach   = true  # wait for the container to finish
  logs     = true  # capture its output
}
output "container_logs" {
  value = docker_container.hello.container_logs
}
