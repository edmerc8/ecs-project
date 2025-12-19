output "alb_access_log_s3_bucket_id" {
  description = "ID of the S3 bucket being used to store ALB Access Logs"
  value       = aws_s3_bucket.alb_access_logs_bucket.id
}
