resource "aws_cloudwatch_dashboard" "ecs_observability" {
  dashboard_name = "ECS_Observability"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 2

        properties = {
          markdown = "ECS"
        }
      },
      {
        type = "metric", x = 0, y = 2, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.ecs_frontend_service_name, "ClusterName", var.ecs_cluster_name, { stat = "Average", label = "Frontend CPU" }],
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.ecs_backend_service_name, "ClusterName", var.ecs_cluster_name, { stat = "Average", label = "Backend CPU" }]
          ],
          period = 300, region = var.primary_region, title = "CPU Utilization"
        }
      },
      {
        type = "metric", x = 12, y = 2, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ServiceName", var.ecs_frontend_service_name, "ClusterName", var.ecs_cluster_name, { stat = "Average", label = "Frontend Memory" }],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", var.ecs_backend_service_name, "ClusterName", var.ecs_cluster_name, { stat = "Average", label = "Backend Memory" }]
          ],
          period = 300, region = var.primary_region, title = "Memory Utilization"
        }
      },
      {
        type = "metric", x = 0, y = 8, width = 12, height = 6,
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", var.ecs_frontend_service_name, "ClusterName", var.ecs_cluster_name, { stat = "Average", label = "Frontend Tasks" }],
            ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", var.ecs_backend_service_name, "ClusterName", var.ecs_cluster_name, { stat = "Average", label = "Backend Tasks" }],

          ],
          period = 300, stat = "Average", region = var.primary_region, title = "Running Task Count"
        }
      },
    ]
  })
}
