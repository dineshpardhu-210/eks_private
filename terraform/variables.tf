variable "region" { 
  type    = string 
  default = "us-east-1" 
}

variable "vpc_cidr" { 
  type    = string 
  default = "10.10.0.0/16" 
}

variable "azs" { 
  type    = list(string) 
  default = ["us-east-1a", "us-east-1b"] 
}

variable "private_subnets" { 
  type    = list(string) 
  default = ["10.10.1.0/24", "10.10.2.0/24"] 
}

variable "tags" { 
  type    = map(string) 
  default = { Project = "private-eks-webapp" } 
}

variable "ecr_repository_name" {
  type    = string 
  default = "private-eks-webapp-repo" 
}

variable "eks_cluster_name" { 
  type    = string 
  default = "private-eks-cluster" 
}

variable "eks_node_group_desired_size" { 
  type    = number 
  default = 2 
}