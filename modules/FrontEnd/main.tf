resource "aws_launch_template" "frontend" {
  name_prefix   = "frontend-"
  image_id      = var.ami_id
  instance_type = "t3a.micro"

  key_name               = var.key_name
  vpc_security_group_ids = [var.fe_security_group_ids]


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
  security_groups    = [var.alb_Sec_group]
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

