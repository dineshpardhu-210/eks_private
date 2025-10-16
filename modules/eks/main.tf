resource "aws_eks_cluster" "this" {
  name = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access = false
  }

  # kubeconfig-related outputs are available via data sources in root if needed
}

resource "aws_eks_node_group" "this" {
  cluster_name = aws_eks_cluster.this.name
  node_group_name = "ng-${var.cluster_name}"
  node_role_arn = var.node_role_arn
  subnet_ids = var.private_subnet_ids
  scaling_config {
    desired_size = var.node_group_desired_size
    max_size = var.node_group_desired_size + 1
    min_size = 1
  }
}

