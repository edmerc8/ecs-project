output "db_password_arn" {
  description = "ARN of the RDS DB Password"
  value       = aws_db_instance.rds-db.master_user_secret[0].secret_arn
}
