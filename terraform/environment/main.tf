module "network" {
  source   = "../modules/network"
  env      = ""
  vpc_cidr = "172.16.0.0/16"
}

module "ecr" {
  source = "../modules/ecr"
  env    = ""
}
