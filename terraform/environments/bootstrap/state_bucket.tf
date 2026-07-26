/*
Creates the S3 bucket used as the Terraform remote backend for every
directory in this project, including this bootstrap directory itself.
See backend.tf for the two-step process required to migrate this
directory's own state into the bucket once it exists.
*/

resource "aws_s3_bucket" "ecs_project_state_bucket" {
  bucket = var.state_bucket_name

  tags = {
    Name = var.state_bucket_name
  }
}

# Applied by default but should be set explicitly for security
resource "aws_s3_bucket_public_access_block" "ecs_project_state_access_block" {
  bucket                  = aws_s3_bucket.ecs_project_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.ecs_project_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.ecs_project_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
