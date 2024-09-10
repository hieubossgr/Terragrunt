include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/vpc"
  
}

// inputs = {
//   vpc_name = get_env("VPC_NAME", "aa")
//   vpc_cidr = "10.0.0.0/16"
//   public_subnets = {
//     "public_subnet_1" = 1
//     "public_subnet_2" = 2
//   }

//   ecs_private_subnets = {
//     "ecs_private_subnet_1" = 1
//     "ecs_private_subnet_2" = 2
//   }
  
//   cronjob_private_subnets = {
//     "cronjob_private_subnet_1" = 3
//     "cronjob_private_subnet_2" = 4
//   }

//   rds_private_subnets = {
//     "rds_private_subnet_1" = 5
//     "rds_private_subnet_2" = 6
//   }
// }