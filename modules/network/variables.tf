variable "vpc_name" {
  type = string
  description  = "Name of vpc"
}

variable "vpc_cidr" {
  type = string
  description = "vpc cidr block"
}

variable "ecs_private_subnets" {
  type = map(number)
  description = "List private subnets for ecs"
}

variable "cronjob_private_subnets" {
  type = map(number)
  description = "List private subnets for cronjob"
}

variable "rds_private_subnets" {
  type = map(number)
  description = "List private subnets for rds"
}

variable "public_subnets" {
  type = map(number)
  description = "List public subnets"
}

#------------------------------------ Security Group ------------------------------------#
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
#------------------------------------ Security Group ------------------------------------#

#------------------------------------ ALB ------------------------------------#
variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}
#------------------------------------ ALB ------------------------------------#