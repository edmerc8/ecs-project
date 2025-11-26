provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "ecs-project-vpc"
  }
}
