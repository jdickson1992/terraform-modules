############################################################################################################
# VPC
# - Virtual private cloud network with DNS enabled (useful for cluster autoscaler / Karpernter)
# - Subnets will be created within this VPC
############################################################################################################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}