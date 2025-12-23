variable "lb_type" {
  type = string
}

variable "lb_subnets" {
  type = list(string)
}

variable "lb_security_groups" {
  type = list(string)
}

variable "lb_access_logs_bucket" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "http_protocol" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "backend_port" {
  type = number
}

variable "http_port" {
  type = number
}
