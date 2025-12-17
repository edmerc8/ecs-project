resource "aws_cloudwatch_log_group" "ecs_app_logs" {
  name = "ecs-app-logs"

  retention_in_days = 1
}


