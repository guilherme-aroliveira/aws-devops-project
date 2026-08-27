module "network" {
  source   = "../modules/network"
  env      = ""
  vpc_cidr = "172.16.0.0/16"
  tags     = local.tags
}

module "ecr" {
  source = "../modules/ecr"
  env    = ""
  tags   = local.tags
}
