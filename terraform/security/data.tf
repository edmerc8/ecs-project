# Access outputs from Networking Module
data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "networking/terraform.tfstate"
    region = "us-east-2"
  }
}
