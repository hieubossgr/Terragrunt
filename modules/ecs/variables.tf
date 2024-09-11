variable "cluster_ecs_name" {
  description = "Tên của ECS cluster"
  type        = string
}

variable "task_family" {
  description = "Tên family của ECS task definition"
  type        = string
}

variable "task_cpu" {
  description = "Số lượng CPU cho task"
  type        = string
}

variable "task_memory" {
  description = "Dung lượng bộ nhớ cho task"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Ảnh Docker cho container"
  type        = string
}

variable "container_cpu" {
  description = "Số lượng CPU cho container"
  type        = number
}

variable "container_memory" {
  description = "Dung lượng bộ nhớ cho container"
  type        = number
}

variable "container_port" {
  description = "Cổng container sẽ lắng nghe"
  type        = number
}

variable "service_name" {
  description = "Tên của ECS service"
  type        = string
}

variable "desired_count" {
  description = "Số lượng task mong muốn"
  type        = number
}

variable "private_subnets" {
  description = "Danh sách các subnet private"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID của security group"
  type        = string
}

variable "target_group_arn" {
  description = "ARN của target group ALB"
  type        = string
}

variable "max_capacity" {
  description = "Số lượng tối đa task cho auto scaling"
  type        = number
}

variable "min_capacity" {
  description = "Số lượng tối thiểu task cho auto scaling"
  type        = number
}