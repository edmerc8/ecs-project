data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "networking/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "secrets_manager" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "secrets-manager/terraform.tfstate"
    region = "us-east-2"
  }
}