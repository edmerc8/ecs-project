resource "aws_s3_bucket" "s3_access_logs_bucket" {
  bucket_prefix = "ecs-project-s3-access-logs-bucket-"
  force_destroy = true # For now I want to destroy the bucket on delete

  tags = {
    Name = "s3-access-logs-bucket"
  }
}

# Applied by default but should be set explicitly for security
resource "aws_s3_bucket_public_access_block" "s3_access_logs_access_block" {
  bucket                  = aws_s3_bucket.s3_access_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "s3_access_logs_bucket_versioning" {
  bucket = aws_s3_bucket.s3_access_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_logs_ownership" {
  bucket = aws_s3_bucket.s3_access_logs_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "s3_access_lock_object_lock" {
  bucket = aws_s3_bucket.s3_access_logs_bucket.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}

# Bucket policy to allow delivery.logs to write to s3 bucket
resource "aws_s3_bucket_policy" "s3_access_log_delivery" {
  bucket = aws_s3_bucket.s3_access_logs_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowBucketAclCheck"
        Action = "s3:GetBucketAcl"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Resource = aws_s3_bucket.s3_access_logs_bucket.arn
      },
      {
        Sid    = "AllowS3AccessLogWrites"
        Action = "s3:PutObject"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.s3_access_logs_bucket.arn}/*"
      },
      {
        Sid       = "RejectNonHttpsTraffic"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.s3_access_logs_bucket.arn,
          "${aws_s3_bucket.s3_access_logs_bucket.arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
    ]
  })
}

# Encryption at Rest
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_access_logs_encryption" {
  bucket = aws_s3_bucket.s3_access_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Use storage tiers to optimize costs
resource "aws_s3_bucket_lifecycle_configuration" "s3_access_log_lifecycle" {
  bucket = aws_s3_bucket.s3_access_logs_bucket.id

  rule {
    id     = "transition-logs"
    status = "Enabled"
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    expiration {
      days = 365
    }
    noncurrent_version_expiration {
      noncurrent_days = 10
    }
  }
}
