variable "project_name" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_storage" {
  type = number
}

variable "db_max_storage" {
  type = number
}

variable "db_backup_retention_days" {
  type = number
}

variable "db_backup_window" {
  type = string
}

variable "db_maintenance_window" {
  type = string
}

variable "vpc_security_groups" {
  type = list(string)
}

variable "db_subnet_groups" {
  type = list(string)
}
