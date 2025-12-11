output "task_execution_role_arn" {
  description = "ECS Task Execution Role"
  value       = aws_iam_role.ecs-execution-role.arn
}

output "task_role_backend_arn" {
  description = "ECS Task Role for Backend Containers"
  value       = aws_iam_role.ecs-task-role-backend.arn
}

output "task_role_frontend_arn" {
  description = "ECS Task Role for Frontend Containers"
  value       = aws_iam_role.ecs-task-role-frontend.arn
}
