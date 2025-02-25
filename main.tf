# main.tf

resource "aws_key_pair" "deployer" {
  key_name   = "flavio-key"
  public_key = file("/home/flavio/.ssh/id_rsa.pub")
}

resource "aws_instance" "flavio-machine" {
  ami           = "ami-0446057e5961dfab6"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name

  subnet_id = "subnet-0d4c3122cb0327eb2"

  tags = {
    Name = "flavio-machine"
  }

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow_ssh_"
  vpc_id      = "vpc-04e7fa58d477c06b7"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  value = aws_instance.flavio-machine.public_ip
}
