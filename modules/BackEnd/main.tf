resource "aws_launch_template" "backend" {
  name_prefix            = "backend-"
  image_id               = var.ami_id
  instance_type          = "t2.micro"
  user_data              = filebase64("${path.module}/UserData/BackendUserData.sh")
  key_name               = var.key_name
  vpc_security_group_ids = [var.be_security_group_ids]


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend-instance"
    }
  }
}
resource "aws_lb" "backend" {
  name               = "backend-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_Sec_group]
  subnets            = var.private_subnets
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}


resource "aws_lb_target_group" "backend" {
  name     = "backend-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
