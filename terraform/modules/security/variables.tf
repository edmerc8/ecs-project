variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_range" {
  type = string
}

variable "subnet_cidr_range" {
  type = string
}

variable "cidr_range_all" {
  type = string
}

variable "https_port" {
  type = number
}

variable "http_port" {
  type = number
}

variable "backend_port" {
  type = number
}

variable "frontend_port" {
  type = number
}

variable "db_port" {
  type = number
}
