variable "vpc_id" {
  description = "The ID of the VPC to associate the security groups with"
  type        = string
}

variable "sg_alb_name" {
  description = "Name of security group alb"
  type = string
}

variable "sg_ecs_name" {
  description = "Name of security group ecs"
  type = string
}

variable "sg_cronjob_name" {
  description = "Name of security group cronjob"
  type = string
}

variable "sg_rds_name" {
  description = "Name of security group rds"
  type = string
}