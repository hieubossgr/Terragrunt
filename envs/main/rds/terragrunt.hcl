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
  source = "../../../modules/rds"
}

inputs = {
  availability_zone = [dependency.vpc.outputs.aws_availability_zone_1, dependency.vpc.outputs.aws_availability_zone_2]
  subnet_ids = [dependency.vpc.outputs.rds_private_subnet_1_id, dependency.vpc.outputs.rds_private_subnet_2_id]
  security_group_id = dependency.security_group.outputs.rds_sg_id
}