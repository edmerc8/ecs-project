resource "aws_cloudtrail" "ecs_project_cloudtrail" {
  depends_on                    = [aws_s3_bucket_policy.cloudtrail_log_delivery]
  name                          = "ecs-project-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs_bucket.id
  include_global_service_events = true

  # Documentation Note: Log stream requires a wildcard so it can access any stream in the group
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_log_delivery_role.arn
}

resource "aws_s3_bucket" "cloudtrail_logs_bucket" {
  bucket_prefix = "cloudtrail-logs-bucket-"
  force_destroy = true

  tags = {
    Name = "cloudtrail-logs-bucket"
  }
}

# Applied by default but should be set explicitly for security
resource "aws_s3_bucket_public_access_block" "cloudtrail_logs_access_block" {
  bucket                  = aws_s3_bucket.cloudtrail_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs_bucket_versioning" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail_logs_ownership" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id
  rule {
    object_ownership = var.s3_object_ownership
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_log_delivery" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowBucketAclCheck"
        Action = "s3:GetBucketAcl"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Resource = aws_s3_bucket.cloudtrail_logs_bucket.arn
      },
      {
        Sid    = "AllowCloudTrailLogWrites"
        Action = "s3:PutObject"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.cloudtrail_logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        # not needed by delivery.logs, but self service upload by cloudtrail does for cross account uploads
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        Sid       = "RejectNonHttpsTraffic"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.cloudtrail_logs_bucket.arn,
          "${aws_s3_bucket.cloudtrail_logs_bucket.arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
    ]
  })
}

# Encryption at Rest
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs_encryption" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Use storage tiers to optimize costs
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_log_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

  rule {
    id     = "transition-logs"
    status = "Enabled"
    transition {
      days          = var.s3_to_glacier_storage_days
      storage_class = "GLACIER"
    }
    expiration {
      days = var.s3_to_expiration_days
    }
  }
}
