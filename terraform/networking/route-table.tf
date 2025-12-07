# Main route table, routing between both public subnets and the IGW
resource "aws_route_table" "main-route-table" {
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

resource "aws_route_table_association" "public-us-east-2a-association" {
  subnet_id = aws_subnet.public-us-east-2a.id
  route_table_id = aws_route_table.main-route-table.id
}

resource "aws_route_table_association" "public-us-east-2b-association" {
  subnet_id = aws_subnet.public-us-east-2b.id
  route_table_id = aws_route_table.main-route-table.id
}

# Private Route table for private subnet in us-east-2a
resource "aws_route_table" "private-us-east-2a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public-subnet-2a.id
  }
}

# Private Route table for private subnet in us-east-2b
resource "aws_route_table" "private-us-east-2b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public-subnet-2b.id
  }
}

resource "aws_route_table_association" "private-us-east-2a-association" {
  subnet_id = aws_subnet.private-us-east-2a.id
  route_table_id = aws_route_table.private-us-east-2a.id
}

resource "aws_route_table_association" "private-us-east-2b-association" {
  subnet_id = aws_subnet.private-us-east-2b.id
  route_table_id = aws_route_table.private-us-east-2b.id
}