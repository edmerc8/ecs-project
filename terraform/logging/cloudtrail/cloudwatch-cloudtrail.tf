resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail-logs"

  retention_in_days = 1 # Would be longer in PRD, just for cost savings now
}
