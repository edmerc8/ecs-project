output "ecs_log_group_name" {
  description = "ARN of the ecs log group"
  value       = aws_cloudwatch_log_group.ecs_app_logs.name
}
