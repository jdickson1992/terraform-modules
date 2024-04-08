############################################################################################################
# Internet Gateway
# - Allows instances in public subnets to communicate with the internet
############################################################################################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}
