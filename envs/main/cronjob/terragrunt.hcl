include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/cronjob"
}

inputs = {
  security_group_id = dependency.network.outputs.cronjob_sg_id
  private_subnets = [dependency.network.outputs.cronjob_private_subnet_1_id, dependency.network.outputs.cronjob_private_subnet_2_id]
}