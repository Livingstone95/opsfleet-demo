module "eks" {
  source                  = "./Modules/EKS"
  cluster_name            = var.cluster_name
  cluster_version         = var.cluster_version
  eks_managed_node_groups = var.eks_managed_node_groups
  vpc_id                  = module.networking.vpc_id
  subnet_ids              = [module.networking.private_subnets[0], module.networking.private_subnets[1], module.networking.private_subnets[2]]
  cluster_addons          = var.cluster_addons
  tags                    = var.tags
}
