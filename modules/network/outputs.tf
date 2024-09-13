#------------------------------------ VPC ------------------------------------#
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "public_subnet_1" {
  value = aws_subnet.public_subnets["public_subnet_1"].id
}

output "public_subnet_2" {
  value = aws_subnet.public_subnets["public_subnet_2"].id
}

output "ecs_private_subnet_1_id" {
  value = aws_subnet.ecs_private_subnets["ecs_private_subnet_1"].id
}

output "ecs_private_subnet_2_id" {
  value = aws_subnet.ecs_private_subnets["ecs_private_subnet_2"].id
}

output "cronjob_private_subnet_1_id" {
  value = aws_subnet.cronjob_private_subnets["cronjob_private_subnet_1"].id
}

output "cronjob_private_subnet_2_id" {
  value = aws_subnet.cronjob_private_subnets["cronjob_private_subnet_2"].id
}

output "rds_private_subnet_1_id" {
  value = aws_subnet.rds_private_subnets["rds_private_subnet_1"].id
}

output "rds_private_subnet_2_id" {
  value = aws_subnet.rds_private_subnets["rds_private_subnet_2"].id
}

output "aws_availability_zone_1" {
  value = tolist(data.aws_availability_zones.availability.names)[1]
}

output "aws_availability_zone_2" {
  value = tolist(data.aws_availability_zones.availability.names)[2]
}


output "route_table_ecs" {
  value = aws_route_table.private_route_table.id
}
#------------------------------------ VPC ------------------------------------#

#------------------------------------ Secutiry Group ------------------------------------#
output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "cronjob_sg_id" {
  value = aws_security_group.cronjob.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}
#------------------------------------ Secutiry Group ------------------------------------#

#------------------------------------ ALB ------------------------------------#
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

output "ecs_target_group_ecs1_blue_arn" {
  value = aws_lb_target_group.ecs_target_group_blue.arn
  description = "The ARN of the ECS target group"
}

output "ecs_target_group_ecs2_green_arn" {
  value = aws_lb_target_group.ecs_target_group_green.arn
  description = "The ARN of the ECS target group"
}
#------------------------------------ ALB ------------------------------------#