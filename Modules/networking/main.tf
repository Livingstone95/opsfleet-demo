data "aws_availability_zones" "available" {}

locals {
  name   = var.vpc_name
  region = var.region

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name    = local.name
    Managed_by  = "Terraform"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = local.name
  cidr = local.vpc_cidr

  azs                 = local.azs
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true


  single_nat_gateway = true
  enable_nat_gateway = true


  tags = local.tags
}
