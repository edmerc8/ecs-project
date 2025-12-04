terraform {
  backend "s3" {
    bucket       = "ecs-project-state-bucket"
    key          = "load-balancing/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true # Use S3 native locking
  }
}
