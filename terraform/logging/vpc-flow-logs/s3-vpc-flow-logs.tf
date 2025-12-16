resource "aws_s3_bucket" "vpc_flow_logs_bucket" {
  bucket        = "ecs-project-vpc-flow-logs-bucket"
  region        = "us-east-2"
  force_destroy = true # For now I want to destroy the bucket on delete

  tags = {
    Name = "ecs-project-state-bucket"
  }
}


# Applied by default but should be set explicitly for security
resource "aws_s3_bucket_public_access_block" "ecs_project_state_access_block" {
  bucket                  = aws_s3_bucket.vpc_flow_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "vpc_flow_logs_bucket_versioning" {
  bucket = aws_s3_bucket.vpc_flow_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket policy to allow delivery.logs to write to s3 bucketcoucouc
resource "aws_s3_bucket_policy" "vpc_flow_log_delivery" {
  bucket = aws_s3_bucket.vpc_flow_logs_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetBucketAcl"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = aws_s3_bucket.vpc_flow_logs_bucket.arn
      },
      {
        Action = "s3:PutObject"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.vpc_flow_logs_bucket.arn}/*"
      }
    ]
  })
}

# Encryption at Rest
resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_flow_logs_encryption" {
  bucket = aws_s3_bucket.vpc_flow_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Use storage tiers to optimize costs
resource "aws_s3_bucket_lifecycle_configuration" "vpc_flow_log_lifecycle" {
  bucket = aws_s3_bucket.vpc_flow_logs_bucket.id

  rule {
    id     = "transition-logs"
    status = "Enabled"
    transition {
      days          = 30 # Minimum number of days to transition to IA
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    expiration {
      days = 365
    }
  }
}
