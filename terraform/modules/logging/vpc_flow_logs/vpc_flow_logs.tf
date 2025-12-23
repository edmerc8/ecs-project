resource "aws_flow_log" "vpc_flow_log" {
  vpc_id                   = var.vpc_id
  traffic_type             = var.vpc_flow_logs_traffic_type
  max_aggregation_interval = var.vpc_flow_log_max_agg_interval # For prod it would be lower, but in this scenario we're saving costs

  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.vpc_flow_logs_bucket.arn

  destination_options {
    file_format                = var.vpc_flow_log_file_format
    hive_compatible_partitions = true
    per_hour_partition         = true
  }

  log_format = (join(" ", [
    "$${version}", "$${account-id}", "$${interface-id}",
    "$${srcaddr}", "$${dstaddr}", "$${srcport}", "$${dstport}",
    "$${protocol}", "$${packets}", "$${bytes}", "$${start}",
    "$${end}", "$${action}", "$${log-status}", "$${vpc-id}",
    "$${flow-direction}", "$${tcp-flags}"
  ]))
}



