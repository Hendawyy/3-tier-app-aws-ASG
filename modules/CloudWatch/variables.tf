variable "autoscaling_group_names" {
  description = "List of Auto Scaling Group names to monitor"
  type        = list(string)
}

variable "scale_out_arns" {
  description = "List of ARNs for scale-out policies"
  type        = list(string)
}

variable "scale_in_arns" {
  description = "List of ARNs for scale-in policies"
  type        = list(string)
}
