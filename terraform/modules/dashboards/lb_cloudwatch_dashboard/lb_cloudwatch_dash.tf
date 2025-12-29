resource "aws_cloudwatch_dashboard" "lb_observability" {
  dashboard_name = "Load_Balancer_Observability"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 2

        properties = {
          markdown = "Load Balancer"
        }
      },
      {
        type = "metric", x = 0, y = 2, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", var.lb_arn_suffix, "TargetGroup", var.frontend_tg_arn_suffix, { stat = "Average", label = "Frontend" }],
            ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", var.lb_arn_suffix, "TargetGroup", var.backend_tg_arn_suffix, { stat = "Average", label = "Backend" }]
          ],
          period = 300, region = var.primary_region, title = "Healthy Targets"
        }
      },
      {
        type = "metric", x = 12, y = 2, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", var.lb_arn_suffix, "TargetGroup", var.frontend_tg_arn_suffix, { stat = "Maximum", label = "Frontend" }],
            ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", var.lb_arn_suffix, "TargetGroup", var.backend_tg_arn_suffix, { stat = "Maximum", label = "Backend" }]
          ],
          period = 300, region = var.primary_region, title = "Unhealthy Targets"
        }
      },
      {
        type = "metric", x = 0, y = 8, width = 12, height = 6,
        properties = {
          metrics = [["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.lb_arn_suffix]],
          period  = 300, stat = "Average", region = var.primary_region, title = "Target Response Time"
        }
      },
      {
        type = "metric", x = 12, y = 8, width = 12, height = 6,
        properties = {
          metrics = [["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.lb_arn_suffix]],
          period  = 300, stat = "Sum", region = var.primary_region, title = "Request Count"
        }
      },
      # ELB 500 Errors
      {
        type = "metric", x = 0, y = 14, width = 12, height = 6,
        properties = {
          metrics = [["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.lb_arn_suffix]],
          period  = 300, stat = "Sum", region = var.primary_region, title = "ELB 5XX Errors"
        }
      },
      {
        type = "metric", x = 12, y = 14, width = 12, height = 6,
        properties = {
          metrics = [["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.lb_arn_suffix]],
          period  = 300, stat = "Sum", region = var.primary_region, title = "Target 5XX Errors"
        }
      },
      # WIDGET 2: ELB 4XX Errors
      {
        type = "metric", x = 0, y = 20, width = 12, height = 6,
        properties = {
          metrics = [["AWS/ApplicationELB", "HTTPCode_ELB_4XX_Count", "LoadBalancer", var.lb_arn_suffix]],
          period  = 300, stat = "Sum", region = var.primary_region, title = "ELB 4XX Errors"
        }
      },
      {
        type = "metric", x = 12, y = 20, width = 12, height = 6,
        properties = {
          metrics = [["AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", var.lb_arn_suffix]],
          period  = 300, stat = "Sum", region = var.primary_region, title = "Active Connection Count"
        }
      },
      {
        type = "metric", x = 0, y = 26, width = 12, height = 6,
        properties = {
          metrics = [["AWS/ApplicationELB", "RejectedConnectionCount", "LoadBalancer", var.lb_arn_suffix]],
          period  = 300, stat = "Sum", region = var.primary_region, title = "Rejected Connection Count"
        }
      },
    ]
  })
}
