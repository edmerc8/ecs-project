resource "aws_cloudwatch_log_group" "ecs_app_logs" {
  name = "ecs-app-logs"

  retention_in_days = var.cloudwatch_retention_days # Would be longer in PRD, just for cost savings now
}


