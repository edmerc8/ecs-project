# Access outputs from Security Module
data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "security/terraform.tfstate"
    region = "us-east-2"
  }
}

# Access outputs from Networking Module
data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "networking/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "alb-access-logs" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "logging/alb-access-logs/terraform.tfstate"
    region = "us-east-2"
  }
}
