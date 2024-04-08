############################################################################################################
# NAT Gateway
# - Allows instances in private subnets to initiate OUTBOUND internet access without allowing inbound access
# - A static Elastic IP is attached to the NAT (useful for future whitelisting)
# - NAT must be placed on public subnet
############################################################################################################
resource "aws_eip" "nat_gateway" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public[0].id 

  tags = {
    Name = "${var.environment}-nat"
  }

  depends_on = [aws_internet_gateway.main]
}