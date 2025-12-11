# NAT Gateway in public subnet of us-east-2a
resource "aws_nat_gateway" "public_subnet_2a" {
  subnet_id     = aws_subnet.public_us_east_2a.id
  allocation_id = aws_eip.nat_eip_subnet_2a.id

  depends_on = [aws_internet_gateway.internet_gateway]
}

# NAT Gateway in public subnet of us-east-2b
resource "aws_nat_gateway" "public_subnet_2b" {
  subnet_id     = aws_subnet.public_us_east_2b.id
  allocation_id = aws_eip.nat_eip_subnet_2b.id

  depends_on = [aws_internet_gateway.internet_gateway]
}

