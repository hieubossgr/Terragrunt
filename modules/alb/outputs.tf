output "alb_arn" {
  value = aws_lb.custom_alb.arn
}

output "alb_dns_name" {
  value = aws_lb.custom_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.custom_alb.zone_id
}

output "http_listener_ecs1_blue_arn" {
  value = aws_lb_listener.ecs1-blue.arn
  description = "The ARN of the HTTP listener for the ALB."
}

output "http_listener_ecs2_green_arn" {
  value = aws_lb_listener.ecs2-green.arn
  description = "The ARN of the HTTP listener for the ALB."
}

output "ecs_target_group_ecs1_blue_arn" {
  value = aws_lb_target_group.ecs_target_group_blue.arn
  description = "The ARN of the ECS target group"
}

output "ecs_target_group_ecs2_green_arn" {
  value = aws_lb_target_group.ecs_target_group_green.arn
  description = "The ARN of the ECS target group"
}