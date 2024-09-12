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