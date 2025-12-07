# NAT Gateway in public subnet of us-east-2a
resource "aws_nat_gateway" "public-subnet-2a" {
  subnet_id = aws_subnet.public-us-east-2a.id
  allocation_id = aws_eip.nat-eip-subnet-2a.id

  depends_on = [ aws_internet_gateway.internet-gateway ]
}

# NAT Gateway in public subnet of us-east-2b
resource "aws_nat_gateway" "public-subnet-2b" {
  subnet_id = aws_subnet.public-us-east-2b.id
  allocation_id = aws_eip.nat-eip-subnet-2b.id

  depends_on = [ aws_internet_gateway.internet-gateway ]
}

