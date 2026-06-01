/*
This file will be used to set up the backend for our terraform code
The asw_s3_bucket resource and aws_s3_bucket_versioning resources
handle the creation of our backend in AWS. The terrafrom backend section 
will need to be initialized and applied separately from the creation
of the resources
*/


resource "aws_s3_bucket" "sandbox_state_bucket" {
  bucket = var.bucket_name

  object_lock_enabled = true
  tags = {
    Name = "sandbox-state-bucket"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Applied by default but should be set explicitly for security
resource "aws_s3_bucket_public_access_block" "sandbox_state_access_block" {
  bucket                  = aws_s3_bucket.sandbox_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Retains records for governance purposes
resource "aws_s3_bucket_object_lock_configuration" "state_lock_config" {
  bucket = aws_s3_bucket.sandbox_state_bucket.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 1
    }
  }
}

# Default encryption managed by SSE
resource "aws_s3_bucket_server_side_encryption_configuration" "sandbox_state_encryption" {
  bucket = aws_s3_bucket.sandbox_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable Versioning for objects stored in the S3 bucket
resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.sandbox_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}