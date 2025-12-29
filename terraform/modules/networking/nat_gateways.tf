# NAT Gateway in public subnets of us-east-2
resource "aws_nat_gateway" "public_subnets" {
  for_each = var.public_subnets

  subnet_id     = aws_subnet.public_subnet[each.key].id
  allocation_id = aws_eip.nat_eip[each.key].id

  depends_on = [aws_internet_gateway.internet_gateway]
}


