variable "project_name" {
  type = string
}

variable "ecs_network_mode" {
  type = string
}

variable "backend_task_cpu" {
  type = number
}

variable "backend_task_memory" {
  type = number
}

variable "backend_image_name" {
  type = string
}

variable "backend_port" {
  type = number
}

variable "frontend_task_cpu" {
  type = number
}

variable "frontend_task_memory" {
  type = number
}

variable "frontend_image_name" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "db_engine" {
  type = string
}

variable "primary_region" {
  type = string
}

variable "db_host_secret" {
  type = string
}

variable "db_password_secret" {
  type = string
}

variable "db_name_secret" {
  type = string
}

variable "db_port_secret" {
  type = string
}

variable "ecs_access_logs_bucket" {
  type = string
}

variable "lb_dns_name" {
  type = string
}

variable "lb_backend_target_group" {
  type = string
}

variable "lb_frontend_target_group" {
  type = string
}

variable "ecs_subnet_group" {
  type = list(string)
}

variable "ecs_security_groups" {
  type = list(string)
}
