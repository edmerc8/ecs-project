output "frontend_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_alb_target_group.frontend-target-group.arn
}

output "backend_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_alb_target_group.backend-target-group.arn
}


