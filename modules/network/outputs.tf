output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the created VPC"
}

output "private_subnet_cidrs" {
  value       = aws_subnet.private[*].cidr_block
  description = "Computed private subnet CIDR blocks"
}

output "public_subnet_cidrs" {
  value       = aws_subnet.public[*].cidr_block
  description = "Computed public subnet CIDR blocks"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "ID of the computed private subnets"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "ID of the computed public subnets"
}

output "aws_route_table_public" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "aws_route_table_private" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}

output "nat_gateway_ipv4_address" {
  value = aws_nat_gateway.main.public_ip
}