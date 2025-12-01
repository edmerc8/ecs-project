resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main.id

  # allows traffic to IGW from anywhere
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "main-route-table"
  }
}
