resource "aws_s3_bucket_logging" "alb_access_bucket_logging" {
  bucket        = data.terraform_remote_state.alb_access_logs.outputs.alb_access_log_s3_bucket_id
  target_bucket = aws_s3_bucket.s3_access_logs_bucket.id
  target_prefix = "alb-access-logs/"
}

resource "aws_s3_bucket_logging" "cloudtrail_access_bucket_logging" {
  bucket        = data.terraform_remote_state.cloudtrail_logs.outputs.cloudtrail_log_s3_bucket_id
  target_bucket = aws_s3_bucket.s3_access_logs_bucket.id
  target_prefix = "cloudtrail-access-logs/"
}

resource "aws_s3_bucket_logging" "vpc_flow_access_bucket_logging" {
  bucket        = data.terraform_remote_state.vpc_flow_logs.outputs.vpc_flow_log_s3_bucket_id
  target_bucket = aws_s3_bucket.s3_access_logs_bucket.id
  target_prefix = "vpc-flow-access-logs/"
}
