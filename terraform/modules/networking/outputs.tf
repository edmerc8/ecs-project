output "vpc_id" {
  description = "ID of main VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of all public subnet IDs"
  value       = values(aws_subnet.public_subnet)[*].id
}

output "private_subnet_ids" {
  description = "List of all private subnet IDs"
  value       = values(aws_subnet.private_subnet)[*].id
}
