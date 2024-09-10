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