variable "fe_lt_id" {
  description = "The ID of the Frontend launch template"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
}

variable "fe_aws_lb_target_group_arn" {
  description = "The ARN of the FrontEnd Application Load Balancer target group"
}

variable "be_lt_id" {
  description = "The ID of the Backend launch template"
}

variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "be_aws_lb_target_group_arn" {
  description = "The ARN of the BackEnd Application Load Balancer target group"
}
