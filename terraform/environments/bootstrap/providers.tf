provider "aws" {
  region = var.primary_region

  default_tags {
    tags = {
      Project     = "ecs-fargate-app"
      Environment = "bootstrap"
      Owner       = "edm"
      Automation  = "true"
      ManagedBy   = "terraform"
    }
  }
}
