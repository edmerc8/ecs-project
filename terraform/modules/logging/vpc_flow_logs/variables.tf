variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_flow_logs_traffic_type" {
  type = string
}

variable "vpc_flow_log_max_agg_interval" {
  type = number
}

variable "vpc_flow_log_file_format" {
  type = string
}

variable "s3_object_ownership" {
  type = string
}

variable "s3_to_glacier_storage_days" {
  type = number
}

variable "s3_to_expiration_days" {
  type = number
}
