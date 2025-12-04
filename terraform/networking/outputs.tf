output "vpc_id" {
  description = "ID of main VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id_us_east_2a" {
  description = "CIDR of us-east-2a public subnet"
  value       = aws_subnet.public-us-east-2a.id
}

output "public_subnet_id_us_east_2b" {
  description = "CIDR of us-east-2b public subnet"
  value       = aws_subnet.public-us-east-2b.id
}

output "private_subnet_id_us_east_2a" {
  description = "CIDR of us-east-2a private subnet"
  value       = aws_subnet.private-us-east-2a.id
}

output "private_subnet_id_us_east_2b" {
  description = "CIDR of us-east-2b private subnet"
  value       = aws_subnet.private-us-east-2b.id
}
