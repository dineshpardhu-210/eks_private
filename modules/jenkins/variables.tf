variable "name_prefix" {
  description = "Prefix for Jenkins resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Jenkins will be launched"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR of the VPC for internal communication"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t3.medium"
}

variable "tags" {
  description = "Tags to apply to Jenkins resources"
  type        = map(string)
  default = {
    Project = "private-eks-webapp"
    Owner   = "DevOps"
    Env     = "development"
  }
}
