provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Project     = "ecs-fargate-containerized-app"
      Environment = "prod"
      Owner       = "edm"
      Automation  = "true"
      Managed_By  = "terraform"
    }
  }
}

