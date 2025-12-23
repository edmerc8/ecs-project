output "cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.cluster.name
}
