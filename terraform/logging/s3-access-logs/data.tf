data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "main" {}

# Access outputs from ALB Log Module
data "terraform_remote_state" "alb_access_logs" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "logging/alb-access-logs/terraform.tfstate"
    region = "us-east-2"
  }
}

# Access outputs from Cloudtrail Log Module
data "terraform_remote_state" "cloudtrail_logs" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "logging/cloudtrail-logs/terraform.tfstate"
    region = "us-east-2"
  }
}

# Access outputs from VPC FLow Log Module
data "terraform_remote_state" "vpc_flow_logs" {
  backend = "s3"

  config = {
    bucket = "ecs-project-state-bucket"

    key    = "logging/vpc-flow-logs/terraform.tfstate"
    region = "us-east-2"
  }
}

