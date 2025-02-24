resource "docker_container" "nginx" {
  count = var.num_containers

  image = var.image
  name  = "nginx_container_${count.index}"

  memory = var.memory

  privileged = var.privileged

  ports {
    internal = 80
    external = var.starting_port + count.index
  }
}