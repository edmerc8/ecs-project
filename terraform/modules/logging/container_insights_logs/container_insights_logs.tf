# Needs to run before containers module

resource "aws_cloudwatch_log_group" "container_insights_logs" {
  name = "/aws/ecs/containerinsights/cluster/performance" # rename /cluster/ using a variable based on ecs-cluster name

  retention_in_days = var.cloudwatch_retention_days # Would be longer in PRD, just for cost savings now
}


