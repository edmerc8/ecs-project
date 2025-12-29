output "cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.cluster.name
}

output "ecs_frontend_service_name" {
  description = "Name of the Frontend ECS Service"
  value       = aws_ecs_service.frontend.name
}

output "ecs_backend_service_name" {
  description = "Name of the Backend ECS Service"
  value       = aws_ecs_service.backend.name
}
