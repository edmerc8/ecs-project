data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "security/terraform.tfstate"
    region = "us-east-2"
  }
}
