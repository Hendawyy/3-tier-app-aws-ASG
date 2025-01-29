variable "vpc_id" {
  description = "The ID Of The VPC"
}

variable "private_subnets" {
  description = "List of public subnet IDs"
}


variable "db_security_group_ids" {
  description = "List of security group IDs"
}

variable "DBPass" {
  description = "The password for the database"
  type        = string
}
