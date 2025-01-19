resource "aws_launch_template" "frontend" {
  name_prefix   = "frontend-"
  image_id      = "ami-07c0517613d0845d3"
  instance_type = "t4g.nano"

  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_ids]


  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = "frontend-instance"
    }
  }
}
resource "aws_lb" "frontend" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_ids]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_autoscaling_group" "FrontendASG" {
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  vpc_zone_identifier       = var.public_subnets

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.frontend.arn]
}
