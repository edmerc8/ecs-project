resource "aws_eip" "nat_eip" {
  for_each = var.public_subnets

  domain = var.eip_domain

  tags = {
    Name = "nat-eip-${each.key}"
  }
}
