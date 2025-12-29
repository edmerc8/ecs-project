output "rds_parameter_group_name" {
  description = "Specified parameters for RDS CloudWatch Log group"
  value       = aws_db_parameter_group.postgres_rds_params.name
}
