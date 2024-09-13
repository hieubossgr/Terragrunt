include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/rds"
}

inputs = {
  availability_zone = [dependency.network.outputs.aws_availability_zone_1, dependency.network.outputs.aws_availability_zone_2]
  subnet_ids = [dependency.network.outputs.rds_private_subnet_1_id, dependency.network.outputs.rds_private_subnet_2_id]
  security_group_id = dependency.network.outputs.rds_sg_id
}