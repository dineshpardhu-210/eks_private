
# Prefix used for naming all resources
variable "name_prefix" {
  description = "Prefix used for naming all VPC resources (e.g., project or environment name)"
  type        = string
  default     = "private-eks"
}

# AWS region
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

# Private subnets (one per AZ)
variable "private_subnets" {
  description = "List of private subnet CIDRs (one per availability zone)"
  type        = list(string)
  default     = [
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]
}

# Availability zones matching the subnets
variable "azs" {
  description = "List of availability zones where private subnets will be created"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Tags for resources
variable "tags" {
  description = "A map of common tags to assign to all resources"
  type        = map(string)
  default = {
    Project = "private-eks-webapp"
    Owner   = "DevOps-Team"
    Env     = "development"
  }
}
