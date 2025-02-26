terraform {
  backend "s3" {
    bucket         = "terraform-state-qh2o7"
    key           = "global/s3/student_6_19/network.tfstate"
    region        = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt       = true

    access_key = ""
    secret_key = ""
  }
}

provider "aws" {
}

# Récupérer la VPC existante nommée "Lab5-6"
data "aws_vpc" "lab_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

# Création des Subnets
resource "aws_subnet" "public_a" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "192.168.6.0/24"
  availability_zone = "eu-west-3a"
  tags = {
    Name = "student_6_19_Public_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "192.168.19.0/24"
  availability_zone = "eu-west-3b"
  tags = {
    Name = "student_6_19_Public_b"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "192.168.196.0/24"
  availability_zone = "eu-west-3c"
  tags = {
    Name = "student_6_19_Private"
  }
}

# Security Group Public (HTTP, HTTPS ouvert)
resource "aws_security_group" "public_sg" {
  vpc_id = data.aws_vpc.lab_vpc.id
  name   = "public"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group Interne (Accepte seulement le trafic du SG public)
resource "aws_security_group" "internal_sg" {
  vpc_id = data.aws_vpc.lab_vpc.id
  name   = "internal"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }
}

# Application Load Balancer (ALB)
resource "aws_lb" "app_lb" {
  name               = "student-6-19-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets           = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

# Création des Target Groups pour Nginx et Tomcat
resource "aws_lb_target_group" "tg_nginx" {
  name     = "tg-nginx"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.lab_vpc.id
}

resource "aws_lb_target_group" "tg_tomcat" {
  name     = "tg-tomcat"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.lab_vpc.id
}

# Listener avec règles de routage basées sur le path
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Path not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "route_nginx" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/nginx"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_nginx.arn
  }
}

resource "aws_lb_listener_rule" "route_tomcat" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 20

  condition {
    path_pattern {
      values = ["/tomcat"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_tomcat.arn
  }
}