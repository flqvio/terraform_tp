provider "aws" {
}

resource "aws_key_pair" "student_key" {
  key_name   = "student_19"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_security_group" "sg" {
  name        = "allow_ssh_http_student_19"
  description = "Security group for SSH and HTTP access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Autoriser SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Autoriser HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Autoriser tout le trafic sortant"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.student_key.key_name
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Student19-ec2"
  }
}

output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.web.public_ip
}
