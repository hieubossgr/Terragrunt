include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/ecr"
}