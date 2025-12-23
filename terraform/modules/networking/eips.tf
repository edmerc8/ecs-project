resource "aws_eip" "nat_eip" {
  # Filter the subnet map to only include public ones
  for_each = var.public_subnets

  domain = "vpc"

  tags = {
    # This gives them names like "nat-eip-public-1"
    Name = "nat-eip-${each.key}"
  }
}
