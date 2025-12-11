/* This file contains the terraform code for a private repository in ECR.
Force Delete defaults to false and will stay that way
because container images need to be uploaded outside of the terraform code.
The private repo URI will be used to provide least privilege ECR access. 
*/

resource "aws_ecr_repository" "ecr-project-repo" {
  name = "ecs-project-private-repo"
  # force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

}
