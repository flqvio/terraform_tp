provider "aws" {
  region = "eu-west-3"
}

module "ec2_instance" {
  source         = "./ec2_instance"
  region         = "eu-west-3"
  subnet_id      = "subnet-0d4c3122cb0327eb2"
  instance_type  = "t3.micro"
  instance_name  = "student19-flavio-instance"
  key_name       = "student_19_flavio_key"
}

output "instance_public_dns" {
  description = "DNS public de l'instance"
  value       = module.ec2_instance.public_dns
}

output "instance_public_ip" {
  description = "IP publique de l'instance"
  value       = module.ec2_instance.public_ip
}
