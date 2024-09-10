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