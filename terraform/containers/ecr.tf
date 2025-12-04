resource "aws_ecr_repository" "ecr-project-repo" {
  name         = "ecr-project-repo"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

}
