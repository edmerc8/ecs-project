output "cloudtrail_log_s3_bucket_id" {
  description = "ID of the S3 bucket being used to store CloudTrail Logs"
  value       = aws_s3_bucket.cloudtrail_logs_bucket.id
}

