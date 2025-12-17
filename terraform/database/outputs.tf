# Used by ECS tasks and IAM roles to provide DB access permissions
output "db_password_arn" {
  description = "ARN of the RDS DB Password"
  value       = aws_db_instance.rds_db.master_user_secret[0].secret_arn
}

output "db_host_param_arn" {
  value = aws_ssm_parameter.db_host.arn
}

output "db_port_param_arn" {
  value = aws_ssm_parameter.db_port.arn
}

output "db_name_param_arn" {
  value = aws_ssm_parameter.db_name.arn
}
