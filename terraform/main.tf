terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# VPC module (private subnets + endpoints)
module "vpc" {
  source          = "../modules/vpc"
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  azs             = var.azs
  tags            = var.tags
}

# ECR repo
module "ecr" {
  source = "../modules/ecr"
  name   = var.ecr_repository_name
  tags   = var.tags
}

# IAM helpers for EKS (roles/policies)
module "iam" {
  source       = "../modules/iam"
  cluster_name = var.eks_cluster_name
}

# EKS cluster (private)
module "eks" {
  source                  = "../modules/eks"
  cluster_name            = var.eks_cluster_name
  private_subnet_ids      = module.vpc.private_subnet_ids
  cluster_role_arn        = module.iam.cluster_role_arn
  node_role_arn           = module.iam.node_role_arn
  node_group_desired_size = var.eks_node_group_desired_size
}

# ALB (internal)
module "alb" {
  source              = "../modules/alb"
  alb_name            = "priv-alb"   
  subnets             = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.security_group_id]
  vpc_id              = module.vpc.vpc_id
}

module "jenkins" {
  source = "../modules/jenkins"

  # Naming prefix for Jenkins resources
  name_prefix = "private-eks"

  # Networking inputs (from your VPC module)
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids

  # Instance configuration
  instance_type = "t3.medium"

  # Common tags (same as VPC & EKS)
  tags = {
    Project = "private-eks-webapp"
    Owner   = "Dinesh"
    Env     = "development"
  }
}


