output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds-sg.id
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb-sg-public.id
}

output "ecs_sg_id" {
  description = "ID of the ECS security group"
  value       = aws_security_group.ecs-sg.id
}
