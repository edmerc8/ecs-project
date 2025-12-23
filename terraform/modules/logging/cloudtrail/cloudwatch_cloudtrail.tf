resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail-logs"

  retention_in_days = var.cloudwatch_retention_days # Would be longer in PRD, just for cost savings now
}
