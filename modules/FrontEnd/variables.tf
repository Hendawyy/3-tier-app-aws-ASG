variable "vpc_id" {
  description = "The ID Of The VPC"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
}


variable "security_group_ids" {
  description = "List of security group IDs"
}


variable "key_name" {
  description = "The name of the SSH key pair"
}
