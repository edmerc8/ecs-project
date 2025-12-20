resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail-logs"

  retention_in_days = 1
}
