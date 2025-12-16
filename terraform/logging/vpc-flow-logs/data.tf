# Access outputs from Database Module
data "terraform_remote_state" "database" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "database/terraform.tfstate"
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

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "iam/terraform.tfstate"
    region = "us-east-2"
  }
}
