variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "ecs-fargate-app"
}

variable "primary_region" {
  description = "Primary Region Hosting the Architecture"
  type        = string
  default     = "us-east-2"
}
# Networking

#### vpc.tf
variable "vpc_cidr_range" {
  description = "CIDR range of the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

#### subnets.tf
variable "subnet_cidr_range" {
  description = "CIDR range of each subnet"
  type        = string
  default     = "10.0.0.0/24"
}

#### route-table.tf
variable "cidr_range_all" {
  description = "CIDR range allowing all traffic"
  type        = string
  default     = "0.0.0.0/0"
}

#### eips.tf
variable "eip_domain" {
  description = "Domain of the NAT Gateway Elastic IPs"
  type        = string
  default     = "vpc"
}

# Security
#### security-groups.tf
variable "https_port" {
  description = "Port used for HTTPS traffic"
  type        = number
  default     = 443
}

variable "http_port" {
  description = "Port used for HTTP traffic"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port used for backend traffic"
  type        = number
  default     = 3000
}

variable "frontend_port" {
  description = "Port used for frontend traffic"
  type        = number
  default     = 80
}

variable "db_port" {
  description = "Port used for database traffic"
  type        = number
  default     = 5432
}

variable "db_engine" {
  description = "DB Engine"
  type        = string
  default     = "postgres"
}

variable "db_instance_class" {
  description = "DB Instance Class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_storage" {
  description = "Allocated Storage for DB"
  type        = number
  default     = 20
}

variable "db_max_storage" {
  description = "Max Allocated Storage for DB"
  type        = number
  default     = 100
}

variable "db_backup_retention_days" {
  description = "How long DB backups are stored"
  type        = number
  default     = 3
}

variable "db_backup_window" {
  description = "Timeframe for DB Backups"
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "Timeframe for DB Maintenance"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

# IAM
#### iam-roles.tf
# going to need variables for resource locations to include in patterns

# Load Balancing
#### alb.tf
variable "lb_type" {
  description = "Type of ELB"
  type        = string
  default     = "application"
}

variable "http_protocol" {
  description = "HTTP Protocol"
  type        = string
  default     = "HTTP"
}

# Containers
#### ecs-task-definition.tf

variable "ecs_network_mode" {
  description = "Network Mode for ECS Task"
  type        = string
  default     = "awsvpc"
}
variable "backend_task_cpu" {
  description = "CPU for Backend ECS Task"
  type        = number
  default     = 1024
}

variable "backend_task_memory" {
  description = "Memory for Backend ECS Task"
  type        = number
  default     = 2048
}

variable "backend_image_name" {
  description = "Name of Backend ECS Image"
  type        = string
  default     = "backend-v1"
}

variable "frontend_task_cpu" {
  description = "CPU for Frontend ECS Task"
  type        = number
  default     = 1024
}

variable "frontend_task_memory" {
  description = "Memory for Frontend ECS Task"
  type        = number
  default     = 2048
}

variable "frontend_image_name" {
  description = "Name of Frontend ECS Image"
  type        = number
  default     = 443
}

# VPC Flow Logs

#### s3-vpc-flow-logs.tf

variable "s3_object_ownership" {
  description = "S3 Bucket Object Ownership Policy"
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "s3_to_glacier_storage_days" {
  description = "Number of days before Objects are transitioned to Glacier Storage"
  type        = number
  default     = 90
}

variable "s3_to_expiration_days" {
  description = "Number of days before Objects in S3 expire"
  type        = number
  default     = 365
}

variable "cloudwatch_retention_days" {
  description = "Number of days for CloudWatch Logs to be stored"
  type        = number
  default     = 1
}

variable "vpc_flow_logs_traffic_type" {
  description = "Type of traffic captured by VPC Flow Logs"
  type        = string
  default     = "ALL"
}

variable "vpc_flow_log_max_agg_interval" {
  description = "Maximum Aggregated Interval for VPC flow logs"
  type        = number
  default     = 600
}

variable "vpc_flow_log_file_format" {
  description = "File Format of the VPC Flow Logs"
  type        = string
  default     = "parquet"
}

