# Elastic IP for NAT Gateway in AZ 2a's public subnet
resource "aws_eip" "nat_eip_subnet_2a" {
  domain = var.eip_domain

  tags = {
    Name = "nat-eip-subnet-2a"
  }
}

# Elastic IP for NAT Gateway in AZ 2b's public subnet
resource "aws_eip" "nat_eip_subnet_2b" {
  domain = var.eip_domain

  tags = {
    Name = "nat-eip-subnet-2b"
  }
}
