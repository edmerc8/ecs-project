# Used by ECS tasks and IAM roles to provide DB access permissions
output "db_password_arn" {
  description = "ARN of the RDS DB Password"
  value       = aws_db_instance.rds_db.master_user_secret[0].secret_arn
}
