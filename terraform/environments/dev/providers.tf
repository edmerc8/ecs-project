provider "aws" {
  region = var.primary_region

  default_tags {
    tags = {
      Project     = "ecs-fargate-app"
      Environment = "dev"
      Owner       = "edm"
      Automation  = "true"
      ManagedBy   = "terraform"
    }
  }
}

