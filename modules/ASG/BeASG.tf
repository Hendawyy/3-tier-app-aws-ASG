resource "aws_autoscaling_group" "BackendASG" {
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  vpc_zone_identifier       = var.private_subnets

  launch_template {
    id      = var.be_lt_id
    version = "$Latest"
  }
  target_group_arns = [var.be_aws_lb_target_group_arn]
  tag {
    key                 = "Name"
    value               = "backend-instance"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_policy" "backend_scale_out" {
  name                   = "backend-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.BackendASG.name
}

resource "aws_autoscaling_policy" "backend_scale_in" {
  name                   = "backend-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.BackendASG.name
}
