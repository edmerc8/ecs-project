data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "ecr_frontend_repo_url" {
  name = "ecs-project-private-repo-frontend"
}

data "aws_ecr_repository" "ecr_backend_repo_url" {
  name = "ecs-project-private-repo-backend"
}
