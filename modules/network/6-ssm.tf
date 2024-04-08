############################################################################################################
# SSM variables
# - Uploads outputs to SSM
############################################################################################################

# Upload VPC ID to SSM
resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.environment}-iac/network/vpc_id"
  description = "VPC ID"
  type        = "String"
  value       = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-vpc-id"
  }
}

# Upload private / public subnet ids to SSM
resource "aws_ssm_parameter" "private_subnet_ids" {
  name        = "/${var.environment}-iac/network/private-subnet-ids"
  description = "Private Subnet Ids"
  type        = "StringList"
  value       = join(",", aws_subnet.private[*].id)

  tags = {
    Name = "${var.environment}-private-subnet-ids"
  }
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name        = "/${var.environment}-iac/network/public-subnet-ids"
  description = "Public Subnet Ids"
  type        = "StringList"
  value       = join(",", aws_subnet.public[*].id)

  tags = {
    Name = "${var.environment}-public-subnet-ids"
  }
}