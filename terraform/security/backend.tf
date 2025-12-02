terraform {
  backend "s3" {
    bucket       = "ecs-project-state-bucket"
    key          = "security/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true # Use S3 native locking
  }
}
