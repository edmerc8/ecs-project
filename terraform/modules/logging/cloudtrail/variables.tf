variable "project_name" {
  type = string
}

variable "cloudwatch_retention_days" {
  type = number
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
