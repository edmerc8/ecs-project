/*
This directory creates the S3 bucket that every other directory (including
this one) uses as its Terraform remote backend, so it has a chicken-and-egg
problem: the bucket referenced below doesn't exist on a fresh AWS account
until this directory has already been applied once.

Setup
1. Leave the terraform backend "s3" block below commented out
2. terraform init
3. terraform plan
4. terraform apply -auto-approve
5. Uncomment the backend "s3" block below
6. terraform init again, and type "yes" to copy the existing local state
   into the new S3 backend
7. Confirm the state file now lives at s3://<bucket>/bootstrap/terraform.tfstate
*/

# terraform {
#   backend "s3" {
#     bucket       = "ecs-project-state-bucket" # Must match var.state_bucket_name
#     key          = "bootstrap/terraform.tfstate"
#     region       = "us-east-2"
#     encrypt      = true
#     use_lockfile = true # Use S3 native locking
#   }
# }
