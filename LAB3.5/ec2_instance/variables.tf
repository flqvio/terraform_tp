variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-3"
}

variable "subnet_id" {
  description = "ID du subnet à utiliser"
  type        = string
}

variable "instance_type" {
  description = "Type de l'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Nom de l'instance"
  type        = string
  default     = "DefaultInstanceName"
}

variable "key_name" {
  description = "Nom de la clé SSH à utiliser"
  type        = string
}
