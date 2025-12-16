resource "aws_flow_log" "vpc_flow_log" {
  vpc_id                   = data.terraform_remote_state.networking.outputs.vpc_id
  traffic_type             = "ALL"
  max_aggregation_interval = 600 # For prod it would be lower, but in this scenario we're saving costs

  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.vpc_flow_logs_bucket.arn

  destination_options {
    file_format                = "parquet"
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



