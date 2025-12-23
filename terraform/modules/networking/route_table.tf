# Main route table, routing between both public subnets and the IGW
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main.id

  # allows traffic to IGW from anywhere
  route {
    cidr_block = var.cidr_range_all
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.main_route_table.id
}

# Private Route table for private subnets in us-east-2
resource "aws_route_table" "private_subnets" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = var.cidr_range_all
    nat_gateway_id = aws_nat_gateway.public_subnets[each.key].id
  }
}

# need this to reference public key specified for NAT Gateway based on private key
locals {
  private_key_to_az = {
    for k, v in var.private_subnets : k => v.az_index
  }

  az_to_public_key = {
    for k, v in var.public_subnets : v.az_index => k
  }
}

resource "aws_route_table_association" "private_subnets_association" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_subnets[local.az_to_public_key[local.private_key_to_az[each.key]]].id

}
