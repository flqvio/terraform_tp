output "public_dns" {
  description = "DNS public de l'instance EC2"
  value       = aws_instance.instance.public_dns
}

output "public_ip" {
  description = "IP publique de l'instance EC2"
  value       = aws_instance.instance.public_ip
}
