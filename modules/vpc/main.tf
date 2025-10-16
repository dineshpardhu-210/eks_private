###########################################
# PRIVATE VPC MODULE
###########################################

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpc"
  })
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = element(var.azs, tonumber(each.key))
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-${each.key}"
  })
}

# Route tables
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rt-${each.key}"
  })
}

resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

###########################################
# SECURITY GROUPS
###########################################

resource "aws_security_group" "internal" {
  name        = "${var.name_prefix}-internal-sg"
  vpc_id      = aws_vpc.this.id
  description = "Internal communication within the VPC"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-internal-sg"
  })
}

###########################################
# VPC ENDPOINTS (Private Access)
###########################################

# Gateway Endpoint for S3 (no NAT)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in aws_route_table.private : rt.id]

  tags = merge(var.tags, { Name = "${var.name_prefix}-s3-endpoint" })
}

# List of Interface Endpoints
locals {
  interface_endpoints = [
    "com.amazonaws.${var.region}.ecr.api",
    "com.amazonaws.${var.region}.ecr.dkr",
    "com.amazonaws.${var.region}.eks",
    "com.amazonaws.${var.region}.sts",
    "com.amazonaws.${var.region}.logs",
    "com.amazonaws.${var.region}.ec2",
    "com.amazonaws.${var.region}.kms",
    "com.amazonaws.${var.region}.ecs" # optional
  ]

  # New: SSM Endpoints (required for private EC2 Session Manager)
  ssm_endpoints = [
    "com.amazonaws.${var.region}.ssm",
    "com.amazonaws.${var.region}.ssmmessages",
    "com.amazonaws.${var.region}.ec2messages"
  ]
}

# Interface Endpoints (ECR/EKS/ECS/Logs)
resource "aws_vpc_endpoint" "interface" {
  for_each = toset(local.interface_endpoints)

  vpc_id              = aws_vpc.this.id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in aws_subnet.private : s.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.internal.id]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${replace(each.value, ".", "-")}"
  })
}

# Interface Endpoints for SSM Agent (Critical for Private Access)
resource "aws_vpc_endpoint" "ssm_interface" {
  for_each = toset(local.ssm_endpoints)

  vpc_id              = aws_vpc.this.id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in aws_subnet.private : s.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.internal.id]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${replace(each.value, ".", "-")}"
  })
}
