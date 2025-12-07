resource "aws_eip" "nat-eip-subnet-2a" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-subnet-1"
  }
}

resource "aws_eip" "nat-eip-subnet-2b" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-subnet-2"
  }
}