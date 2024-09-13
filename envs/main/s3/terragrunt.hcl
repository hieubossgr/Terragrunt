include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/s3"
}

inputs = {
    vpc_id = dependency.network.outputs.vpc_id
    route_table_ids = [dependency.network.outputs.route_table_ecs]
}