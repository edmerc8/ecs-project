variable "primary_region" {
  description = "Primary region hosting the bootstrap resources"
  type        = string
  default     = "us-east-2"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket used to store Terraform remote state for every other directory in this project"
  type        = string
  default     = "ecs-project-state-bucket"
}

variable "ecr_frontend_repo_name" {
  description = "Name of the ECR repository for frontend images (looked up by name in modules/containers/data.tf)"
  type        = string
  default     = "ecs-project-private-repo-frontend"
}

variable "ecr_backend_repo_name" {
  description = "Name of the ECR repository for backend images (looked up by name in modules/containers/data.tf)"
  type        = string
  default     = "ecs-project-private-repo-backend"
}
