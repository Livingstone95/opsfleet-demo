region = "eu-west-2"
vpc_cidr = "10.0.0.0/24"
vpc_name = "opsfleet_dev"
private_subnets = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]
public_subnets = ["10.0.0.96/27"]



##########################
## EKS Values
#######################

cluster_name    = "opsfleet-demo"

tags = {
  "Environment" = "development"
  "Project"     = "opsfleet-demo"
}

eks_managed_node_groups = {
  karpenter1 = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m6i.large"]
    min_size       = 2
    max_size       = 5
    desired_size   = 2
  }
}

cluster_addons = {
    coredns = {
      most_recent = true
      enabled     = true
    }
    kube-proxy = {
      most_recent = true
      enabled     = true
    }
    vpc-cni = {
      most_recent = true
      enabled     = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
      enabled = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
