# Access outputs from Load Balancing Module
data "terraform_remote_state" "load_balancing" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "load-balancing/terraform.tfstate"
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

# Access outputs from Security Module
data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "security/terraform.tfstate"
    region = "us-east-2"
  }
}

# Access outputs from IAM Module
data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "iam/terraform.tfstate"
    region = "us-east-2"
  }
}

# Access outputs from Database Module
data "terraform_remote_state" "database" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "database/terraform.tfstate"
    region = "us-east-2"
  }
}

# Access outputs from ECR Module
data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "ecr/terraform.tfstate"
    region = "us-east-2"
  }
}
