variable "cluster_ecs_name" {
  description = "Name of ecs cluster"
  type        = string
}

variable "task_family" {
  description = "Name of family ECS task definition"
  type        = string
}

variable "task_cpu" {
  description = "CPU number for task"
  type        = string
}

variable "task_memory" {
  description = "RAM number for task"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Image Docker for container"
  type        = string
}

variable "container_cpu" {
  description = "CPU number for container"
  type        = number
}

variable "container_memory" {
  description = "RAM number for container"
  type        = number
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "service_name" {
  description = "Name of ECS service"
  type        = string
}

variable "desired_count" {
  description = "Number of task"
  type        = number
}

variable "private_subnets" {
  description = "subnets private"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group id"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of target group ALB"
  type        = string
}

variable "max_capacity" {
  description = "Max capacity task for auto scaling"
  type        = number
}

variable "min_capacity" {
  description = "Min capacity task for auto scaling"
  type        = number
}