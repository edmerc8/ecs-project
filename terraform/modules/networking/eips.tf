resource "aws_eip" "nat_eip" {
  for_each = var.public_subnets

  domain = "vpc"

  tags = {
    Name = "nat-eip-${each.key}"
  }
}
