/*
This file contains the public and private subnets for this architecture
They exist in us-east-2 a & b and each has a range of 256 IP addresses
*/


# Subnets of AZ 1
resource "aws_subnet" "public-us-east-2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2a",
  }
}

resource "aws_subnet" "private-us-east-2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "private-us-east-2a",
  }
}

# Subnets for AZ 2
resource "aws_subnet" "public-us-east-2b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2b",
  }
}

resource "aws_subnet" "private-us-east-2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "private-us-east-2b",
  }
}
