provider "aws" {
  region = var.region
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.selected.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.selected.id
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}
