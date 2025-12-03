output "vpc_id" {
  description = "ID of main VPC"
  value       = aws_vpc.main.id
}

output "subnet_id_us_east_2a" {
  description = "ID of us-east-2a private subnet"
  value       = aws_subnet.private-us-east-2a.id
}

output "subnet_id_us_east_2b" {
  description = "ID of us-east-2b private subnet"
  value       = aws_subnet.private-us-east-2b.id
}
