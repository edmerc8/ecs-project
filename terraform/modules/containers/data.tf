data "aws_ecr_repository" "ecr_frontend_repo_url" {
  name = "ecs-project-private-repo-frontend"
}

data "aws_ecr_repository" "ecr_backend_repo_url" {
  name = "ecs-project-private-repo-backend"
}

