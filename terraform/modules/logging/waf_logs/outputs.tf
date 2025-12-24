output "waf_logs_bucket" {
  value = aws_s3_bucket.waf_logs_bucket.arn
}

output "waf_logs_bucket_policy" {
  value = aws_s3_bucket_policy.waf_log_delivery.id
}
