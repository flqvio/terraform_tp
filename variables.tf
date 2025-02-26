variable "vpc_id" {
  description = "ID du VPC dans lequel lancer l'instance"
  type        = string
  default     = "vpc-04e7fa58d477c06b7"
}

variable "subnet_id" {
  description = "ID du subnet public"
  type        = string
  default     = "subnet-0d4c3122cb0327eb2"
}

variable "ami" {
  description = "AMI à utiliser pour l'instance"
  type        = string
  default     = "ami-0446057e5961dfab6"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "ssh_public_key_path" {
  description = "Chemin vers ta clé publique SSH"
  type        = string
  default     = "/home/flavio/.ssh/id_rsa.pub"
}
