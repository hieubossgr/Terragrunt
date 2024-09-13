include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/route53"
}

inputs = {
    dns_name = dependency.network.outputs.alb_dns_name
    zone_id = dependency.network.outputs.alb_zone_id
}