# Secure remote backend for Networking state with native locking enabled
terraform {
  backend "s3" {
    bucket       = "ecs-project-state-bucket"
    key          = "networking/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true # Use S3 native locking
  }
}
