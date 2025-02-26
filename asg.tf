resource "aws_launch_template" "web_lt" {
  name_prefix   = "student19-lt-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.student_key.key_name

  network_interfaces {
    associate_public_ip_address = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "student19-asg"
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  desired_capacity          = var.asg_min
  vpc_zone_identifier       = [var.subnet_id]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Student19-asg"
    propagate_at_launch = true
  }
}