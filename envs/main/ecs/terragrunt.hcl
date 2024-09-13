include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/ecs"
}

inputs = {
  private_subnets = [dependency.network.outputs.ecs_private_subnet_1_id, dependency.network.outputs.ecs_private_subnet_2_id]
  security_group_id = dependency.network.outputs.ecs_sg_id
  target_group_arn = dependency.network.outputs.ecs_target_group_ecs1_blue_arn
}