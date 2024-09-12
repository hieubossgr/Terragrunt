variable "cluster_identifier" {
  description = "Identifier for the RDS cluster"
  type        = string
}

variable "availability_zone" {
  description = "Availability_zone"
  type        = list(string)
}

variable "engine_aurora" {
  description = "Engine aurora"
  type        = string
}

variable "engine_version" {
  description = "Version of the RDS engine"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
}

variable "master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "security_group_id" {
  description = "Security group ID for the RDS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS cluster"
  type        = list(string)
}

variable "rds_write_number" {
  description = "Number of rds writer"
  type        = number
}

variable "rds_read_number" {
  description = "Number of rds read"
  type        = number
}

variable "instance_class" {
  description = "Instance class for the RDS instances"
  type        = string
}

variable "reader_max_capacity" {
  description = "Maximum number of reader instances"
  type        = number
  default = 2
}

variable "reader_min_capacity" {
  description = "Minimum number of reader instances"
  type        = number
  default = 1
}