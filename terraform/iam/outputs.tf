# Role used by ECS agent to access permissions for ECR, Logs, and Secrets Manager
output "task_execution_role_arn" {
  description = "ARN for the ECS Task Execution Role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "cloudtrail_cloudwatch_log_delivery_role_arn" {
  description = "ARN for the CloudTrail Log Delivery Role to CloudWatch"
  value       = aws_iam_role.cloudtrail_cloudwatch_log_delivery_role.arn
}
