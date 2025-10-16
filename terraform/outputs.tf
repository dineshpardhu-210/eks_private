output "vpc_id" { value = module.vpc.vpc_id }
output "private_subnets" { value = module.vpc.private_subnet_ids }
output "ecr_repo_url" { value = module.ecr.ecr_repository_url }
output "eks_endpoint" { value = module.eks.cluster_endpoint }
output "alb_dns" { value = module.alb.alb_dns_name }
