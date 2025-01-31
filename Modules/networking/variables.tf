variable "region" {
  type = string
  default = "eu-west-1"
  description = "The values of the region to deploy resources"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "The VPC CIDR"
}

variable "vpc_name" {
    type = string
    default = ""
    description = "The name of the VPC"
  
}

variable "private_subnets" {
  type = list(string)
  default = []
  description = "List of private subnets"
}

variable "public_subnets" {
  type = list(string)
  default = []
  description = "List of Public subnets"
}

variable "create_private_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the private subnets"
  type        = bool
  default     = false
}