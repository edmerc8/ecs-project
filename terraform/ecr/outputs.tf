# Used by ECS task execution role to access images in the private repo 
# and specify which image the container should use
output "ecr_repo_url" {
  description = "URL of the Private ECR for the project"
  value       = aws_ecr_repository.ecr_project_repo.repository_url
}
