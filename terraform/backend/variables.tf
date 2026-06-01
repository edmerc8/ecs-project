variable "bucket_name" {
  description = "The name of the S3 bucket for terraform state"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}