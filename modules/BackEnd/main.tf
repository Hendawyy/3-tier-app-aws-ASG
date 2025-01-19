resource "aws_launch_template" "backend" {
  name_prefix   = "backend-"
  image_id      = "ami-07c0517613d0845d3"
  instance_type = "t4g.nano"

  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_ids]


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend-instance"
    }
  }
}

resource "aws_lb_target_group" "backend" {
  name     = "backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_autoscaling_group" "BackendASG" {
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  vpc_zone_identifier       = var.private_subnets

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.backend.arn]
}
