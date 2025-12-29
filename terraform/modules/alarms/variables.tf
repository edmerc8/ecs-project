variable "primary_region" {
  type = string
}

variable "alarm_email" {
  type = string
}

variable "ecs_frontend_service_name" {
  type = string
}

variable "ecs_backend_service_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "lb_arn_suffix" {
  type = string
}

variable "backend_tg_arn_suffix" {
  type = string
}

variable "frontend_tg_arn_suffix" {
  type = string
}

variable "db_instance_id" {
  type = string
}

