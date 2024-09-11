include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "security_group" {
  config_path = "../security_group"
}

dependency "alb" {
  config_path = "../alb"
}

terraform {
  source = "../../../modules/ecs"
}

inputs = {
  private_subnets = [dependency.vpc.outputs.ecs_private_subnet_1_id, dependency.vpc.outputs.ecs_private_subnet_2_id]
  security_group_id = dependency.security_group.outputs.ecs_sg_id
  target_group_arn = dependency.alb.outputs.ecs_target_group_ecs1_blue_arn
}