resource "aws_cloudwatch_metric_alarm" "ecs_frontend_cpu" {
  alarm_name          = "ecs-frontend-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors frontend ECS CPU utilization over a 5 minute period"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    ServiceName = var.ecs_frontend_service_name
    ClusterName = var.ecs_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_backend_cpu" {
  alarm_name          = "ecs-backend-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors backend ECS CPU utilization over a 5 minute period"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    ServiceName = var.ecs_backend_service_name
    ClusterName = var.ecs_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_frontend_memory" {
  alarm_name          = "ecs-frontend-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors frontend ECS memory utilization over a 5 minute period"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    ServiceName = var.ecs_frontend_service_name
    ClusterName = var.ecs_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_backend_memory" {
  alarm_name          = "ecs-backend-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors backend ECS memory utilization over a 5 minute period"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    ServiceName = var.ecs_backend_service_name
    ClusterName = var.ecs_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lb_5XX_codes" {
  alarm_name          = "lb-5XX-codes-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "This metric monitors the number of 5XX Errors in a 5 minute period"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    LoadBalancer = var.lb_arn_suffix
  }
}
resource "aws_cloudwatch_metric_alarm" "lb_frontend_unhealthy_alarm" {
  alarm_name          = "lb-frontend-unhealthy-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "This metric monitors to see if the LB has unhealthy frontend targets"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    LoadBalancer = var.lb_arn_suffix
    TargetGroup  = var.frontend_tg_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "lb_backend_unhealthy_alarm" {
  alarm_name          = "lb-backend-unhealthy-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "This metric monitors to see if the LB has unhealthy backend targets"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    LoadBalancer = var.lb_arn_suffix
    TargetGroup  = var.backend_tg_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {
  alarm_name          = "rds-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors to see if the RDS CPU > 80% for 10 minutes"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_storage_alarm" {
  alarm_name          = "rds-storage-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5000000000
  alarm_description   = "This metric monitors to see if the RDS storage is below 5 GB for 10 minutes"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarm_topic.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}
