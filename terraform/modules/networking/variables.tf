variable "project_name" {
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

variable "eip_domain" {
  type = string
}


variable "public_subnets" {
  type = map(object({
    cidr_offset = number
    az_index    = number
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr_offset = number
    az_index    = number
  }))
}
