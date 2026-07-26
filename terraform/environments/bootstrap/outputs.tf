output "state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform remote state"
  value       = aws_s3_bucket.ecs_project_state_bucket.id
}

output "ecr_frontend_repo_url" {
  description = "URL of the private frontend ECR repo"
  value       = aws_ecr_repository.ecr_project_repo_frontend.repository_url
}

output "ecr_backend_repo_url" {
  description = "URL of the private backend ECR repo"
  value       = aws_ecr_repository.ecr_project_repo_backend.repository_url
}
