output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds-sg.id
}
