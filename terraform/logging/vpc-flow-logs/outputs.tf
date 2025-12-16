output "vpc_flow_log_s3_bucket_arn" {
  description = "ARN of the S3 bucket being used to store VPC Flow Logs"
  value       = aws_s3_bucket.vpc_flow_logs_bucket.arn
}
