/*
This file contains the public and private subnets for this architecture
They exist in us-east-2 a & b and each has a range of 256 IP addresses
*/


resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_range, 8, each.value.cidr_offset)
  availability_zone       = data.aws_availability_zones.available_azs.names[each.value.az_index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-az-${each.value.az_index}",
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_range, 8, each.value.cidr_offset)
  availability_zone = data.aws_availability_zones.available_azs.names[each.value.az_index]

  tags = {
    Name = "private-az-${each.value.az_index}",
  }
}

