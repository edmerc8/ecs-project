data "terraform_remote_state" "database" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "database/terraform.tfstate"
    region = "us-east-2"
  }
}
