resource "aws_cloudwatch_dashboard" "rds_observability" {
  dashboard_name = "RDS_Observability"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 2

        properties = {
          markdown = "RDS"
        }
      },
      {
        type = "metric", x = 0, y = 2, width = 12, height = 6,
        properties = {
          metrics = [["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_id]],
          period  = 300, stat = "Average", region = var.primary_region, title = "CPU Utilization"
        }
      },
      {
        type = "metric", x = 12, y = 2, width = 12, height = 6,
        properties = {
          metrics = [["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.db_instance_id]],
          period  = 300, stat = "Average", region = var.primary_region, title = "DB Connections"
        }
      },
      {
        type = "metric", x = 0, y = 8, width = 12, height = 6,
        properties = {
          metrics = [["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.db_instance_id]],
          period  = 300, stat = "Average", region = var.primary_region, title = "Storage Remaining"
        }
      },
      {
        type = "metric", x = 12, y = 8, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", var.db_instance_id, { stat = "Average", label = "Read Latency" }],
            ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", var.db_instance_id, { stat = "Average", label = "Write Latency" }]
          ],
          period = 300, region = var.primary_region, title = "Read/Write Latency"
        }
      },
      # ELB 500 Errors
      {
        type = "metric", x = 0, y = 14, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", var.db_instance_id, { stat = "Average", label = "Read IOPS" }],
            ["AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", var.db_instance_id, { stat = "Average", label = "Write IOPS" }]
          ],
          period = 300, region = var.primary_region, title = "Read/Write IOPS"
        }
      },
    ]
  })
}
