output "container_names" {
  description = "Names of the spawned containers"
  value       = docker_container.nginx[*].name
}

output "container_ports" {
  description = "Ports of the spawned containers"
  value       = [for i in range(var.num_containers) : var.starting_port + i]
}