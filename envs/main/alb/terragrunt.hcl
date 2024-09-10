include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "security_group" {
  config_path = "../security_group"
}

terraform {
  source = "../../../modules/alb"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = [dependency.vpc.outputs.public_subnet_1, dependency.vpc.outputs.public_subnet_2]
  security_group_id = dependency.security_group.outputs.alb_sg_id
}