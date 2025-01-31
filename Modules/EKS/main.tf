module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # EKS Addons
  cluster_addons = var.cluster_addons
  vpc_id                  = var.vpc_id
  subnet_ids              = var.subnet_ids
  eks_managed_node_groups = var.eks_managed_node_groups
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  node_iam_role_additional_policies = {
    ebs-csi = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }
  tags = var.tags
}

