/*
This file will be used to set up the backend for our terraform code
The asw_s3_bucket resource ans aws_s3_bucket_versioning resources
handle the creation of our backend in AWS. The terrafrom backend section 
will need to be initialized and applied separately from the creation
of the resources

Setup
1. The terraform backend section should be commented out to begin
2. Run terraform init to initialize 
3. Run terraform plan and review the changes
4. Run terraform apply to create the resources in AWS

5. Select the terraform backend section and remove the block commenting
it out
6. Run terraform init again to initialize your s3 backend
7. Type 'yes' in the terminal to confirm that you want to copy 
the existing state to a new backend
8. Log into your AWS account and check to make sure the .tfstate
file has been saved to your S3 bucket
*/


resource "aws_s3_bucket" "ecs-project-state-bucket" {
  bucket = "ecs-project-state-bucket"
  region = "us-east-2"

  tags = {
    Name = "ecs-project-state-bucket"
  }
}

resource "aws_s3_bucket_versioning" "state-bucket-versioning" {
  bucket = aws_s3_bucket.ecs-project-state-bucket.id
  region = "us-east-2"
  versioning_configuration {
    status = "Enabled"
  }
}

# terraform {
#   backend "s3" {
#     bucket       = "ecs-project-state-bucket" # Use the bucket name above
#     key          = "backend/terraform.tfstate"
#     region       = "us-east-2"
#     encrypt      = true
#     use_lockfile = true # Use S3 native locking
#   }
# }

