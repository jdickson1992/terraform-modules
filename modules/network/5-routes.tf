############################################################################################################
# Private Route table
# - Uses the NAT Gateway for routing outbound traffic from private subnets
# - Ensures private instances can access internet for updates / pulling down images etc
# - Prevents instances from being reachable from the internet
############################################################################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-private"
  }
}

# Associate the above route table with the private subnets
resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

############################################################################################################
# Public Route table
# - Directs traffic from the public subnets to the internet gateway
# - Ensures that resources can be accessible from the internet (LBs for e.g.)
############################################################################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-public"
  }
}


# Associate the above route table with the public subnets
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}