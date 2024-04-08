# Conditional tagging based on eks_subnets
locals {
  eks_private_subnet_tags = var.eks_subnets ? {
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  } : {}

  eks_public_subnet_tags = var.eks_subnets  ? {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  } : {}

}

# Get availablility zones
data "aws_availability_zones" "available" {
  state = "available"
}

############################################################################################################
# Private Subnets
# - Creates smaller private subnets from the VPC CIDR that do not have routes to an IGW
# - Cant be accessed from internet
# - If eks_subnets are being created, kubernetes.io* tags will be added to each subnet
############################################################################################################
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.private_subnet_additional_bits, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    { "Name" = "${var.environment}-${format("private-subnet-%03d", count.index)}" },
    local.eks_private_subnet_tags,
    var.private_subnet_tags
  )
}

############################################################################################################
# Public Subnets
# - Creates smaller public subnets from the VPC CIDR
# - Resources inside these subnets can be reachable from the Internet
# - If eks_subnets are being created, kubernetes.io* tags will be added to each subnet
############################################################################################################
resource "aws_subnet" "public" {
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.public_subnet_additional_bits, count.index + var.public_subnet_count)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    { "Name" = "${var.environment}-${format("public-subnet-%03d", count.index)}" },
    local.eks_public_subnet_tags,
    var.public_subnet_tags
  )
}
