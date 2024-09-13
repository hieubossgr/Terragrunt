variable "security_group_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "lambda_package" {
  type = string
}


variable "project_name" {
  type = string
}