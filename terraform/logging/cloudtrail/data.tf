# Access outputs from Database Module
data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "iam/terraform.tfstate"
    region = "us-east-2"
  }
}


data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "main" {}

