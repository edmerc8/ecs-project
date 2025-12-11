# Main route table, routing between both public subnets and the IGW
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main.id

  # allows traffic to IGW from anywhere
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "public_us_east_2a_association" {
  subnet_id      = aws_subnet.public_us_east_2a.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "public_us_east_2b_association" {
  subnet_id      = aws_subnet.public_us_east_2b.id
  route_table_id = aws_route_table.main_route_table.id
}

# Private Route table for private subnet in us-east-2a
resource "aws_route_table" "private_us_east_2a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_subnet_2a.id
  }
}

# Private Route table for private subnet in us-east-2b
resource "aws_route_table" "private_us_east_2b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_subnet_2b.id
  }
}

resource "aws_route_table_association" "private_us_east_2a_association" {
  subnet_id      = aws_subnet.private_us_east_2a.id
  route_table_id = aws_route_table.private_us_east_2a.id
}

resource "aws_route_table_association" "private_us_east_2b_association" {
  subnet_id      = aws_subnet.private_us_east_2b.id
  route_table_id = aws_route_table.private_us_east_2b.id
}
