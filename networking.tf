module "networking" {
  source          = "./Modules/networking"
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  region          = var.region
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}