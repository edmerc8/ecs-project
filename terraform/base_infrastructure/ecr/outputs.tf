# Used by ECS task execution role to access images in the private repo 
# and specify which image the container should use
output "ecr_frontend_repo_url" {
  description = "URL of the Private Frontend ECR for the project"
  value       = aws_ecr_repository.ecr_project_repo_frontend.repository_url
}

output "ecr_backend_repo_url" {
  description = "URL of the Private BackendECR for the project"
  value       = aws_ecr_repository.ecr_project_repo_backend.repository_url
}
