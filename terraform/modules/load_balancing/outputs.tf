output "lb_dns_name" {
  value = aws_lb.alb_ecs_tasks.dns_name
}

output "backend_target_group" {
  value = aws_alb_target_group.backend_target_group.arn
}

output "backend_target_group_arn_suffix" {
  value = aws_alb_target_group.backend_target_group.arn_suffix
}

output "frontend_target_group" {
  value = aws_alb_target_group.frontend_target_group.arn
}

output "frontend_target_group_arn_suffix" {
  value = aws_alb_target_group.frontend_target_group.arn_suffix
}

output "lb_arn" {
  value = aws_lb.alb_ecs_tasks.arn
}

output "lb_arn_suffix" {
  value = aws_lb.alb_ecs_tasks.arn_suffix
}
