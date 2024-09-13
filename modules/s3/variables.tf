variable "bucket_name" {
  description = "Name S3 bucket"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}


variable "route_table_ids" {
  description = "List of route table IDs to associate with the VPC endpoint"
  type        = list(string)
}

variable "role_name" {
  description = "Name of IAM Role"
  type        = string
}

variable "policy_name" {
  description = "Name of IAM Policy"
  type        = string
}