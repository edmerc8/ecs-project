output "ecr_repo_url" {
  description = "URL of the Private ECR for the project"
  value       = aws_ecr_repository.ecr-project-repo.repository_url
}
