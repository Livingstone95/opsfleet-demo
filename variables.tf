variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "The values of the region to deploy resources"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The VPC CIDR"
}

variable "vpc_name" {
  type        = string
  default     = ""
  description = "The name of the VPC"

}

variable "private_subnets" {
  type        = list(string)
  default     = []
  description = "List of private subnets"
}

variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "List of Public subnets"
}

##########################
## EKS Variable
#######################

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "eks_managed_node_groups" {
  description = "Configuration of EKS managed node groups"
  type = map(object({
    ami_type       = string
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
  }))
}

variable "control_plane_subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned. If `control_plane_subnet_ids` is not provided, the EKS cluster control plane (ENIs) will be provisioned in these subnets"
  type        = list(string)
  default     = []
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags to add to the cluster resources."
  type        = map(string)
  default     = {}
}

###################
#karpenter
####################
variable "karpenter_namespace" {
  description = "Namespace where Karpenter will be installed"
  type        = string
  default     = "kube-system"
}

variable "karpenter_name" {
  description = "Name of the Helm release for Karpenter"
  type        = string
  default     = "karpenter"
}

variable "karpenter_repository" {
  description = "OCI repository for Karpenter"
  type        = string
  default     = "oci://public.ecr.aws/karpenter"
}

variable "karpenter_chart" {
  description = "Karpenter Helm chart name"
  type        = string
  default     = "karpenter"
}

variable "karpenter_version" {
  description = "Version of the Karpenter Helm chart"
  type        = string
  default     = "1.1.1"
}

variable "karpenter_wait" {
  description = "Whether to wait for Helm release to be ready"
  type        = bool
  default     = false
}

variable "karpenter_values_file" {
  description = "Path to the Helm values file for Karpenter"
  type        = string
  default     = "./files/values.yaml"
}

