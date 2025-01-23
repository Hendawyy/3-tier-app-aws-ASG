resource "aws_autoscaling_group" "FrontendASG" {
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  vpc_zone_identifier       = var.private_subnets

  launch_template {
    id      = var.fe_lt_id
    version = "$Latest"
  }
  target_group_arns = [var.fe_aws_lb_target_group_arn]
  tag {
    key                 = "Name"
    value               = "frontend-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "frontend_scale_out" {
  name                   = "frontend-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.FrontendASG.name
}

resource "aws_autoscaling_policy" "frontend_scale_in" {
  name                   = "frontend-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.FrontendASG.name
}
