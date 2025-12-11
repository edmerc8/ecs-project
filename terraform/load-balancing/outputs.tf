# Target Group identifying the frontend ECS Service for Load Balancing
output "frontend_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_alb_target_group.frontend_target_group.arn
}

# Target Group identifying the backend ECS Service for Load Balancing
output "backend_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_alb_target_group.backend_target_group.arn
}

# Used to identify the public API endpoint
# Will likely be modified with an A record
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb_ecs_tasks.dns_name
}
