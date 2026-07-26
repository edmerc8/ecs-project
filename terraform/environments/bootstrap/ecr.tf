/* Private ECR repositories for the frontend and backend images.
Force delete defaults to false and will stay that way because container
images need to be uploaded outside of the terraform code.
Repos are looked up by name (not by remote state) in modules/containers/data.tf,
so the names here must stay in sync with the defaults there.
*/

resource "aws_ecr_repository" "ecr_project_repo_frontend" {
  name = var.ecr_frontend_repo_name
  # force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "ecr_project_repo_backend" {
  name = var.ecr_backend_repo_name
  # force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
