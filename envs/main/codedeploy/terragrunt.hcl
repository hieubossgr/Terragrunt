include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/codedeploy"
}

inputs = {
  ecs_cluster_name = "my-cluster"
  ecs_service_name = "ecs-sample"
  alb_target_group_blue = dependency.network.outputs.ecs_target_group_ecs1_blue_arn
  alb_target_group_green = dependency.network.outputs.ecs_target_group_ecs2_green_arn
  alb_listener = dependency.network.outputs.http_listener_ecs1_blue_arn
}