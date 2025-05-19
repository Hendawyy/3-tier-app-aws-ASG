resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = length(var.autoscaling_group_names)

  alarm_name          = "cpu_high_${element(var.autoscaling_group_names, count.index)}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = element(var.autoscaling_group_names, count.index)
  }

  alarm_actions = [element(var.scale_out_arns, count.index)]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = length(var.autoscaling_group_names)

  alarm_name          = "cpu_low_${element(var.autoscaling_group_names, count.index)}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = element(var.autoscaling_group_names, count.index)
  }

  alarm_actions = [element(var.scale_in_arns, count.index)]
}
