output "frontend_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_alb_target_group.frontend-target-group.arn
}

output "backend_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_alb_target_group.backend-target-group.arn
}


output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb-for-ecs-tasks.dns_name
}
