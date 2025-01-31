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

variable "vpc_id" {
  description = ""
  type        = string
  default     = ""
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
  type = map(string)
  default = {}
}
