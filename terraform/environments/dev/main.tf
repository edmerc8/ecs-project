module "networking" {
  source = "../../modules/networking"
  # local variables
  project_name      = var.project_name
  vpc_cidr_range    = var.vpc_cidr_range
  subnet_cidr_range = var.subnet_cidr_range
  cidr_range_all    = var.cidr_range_all
  eip_domain        = var.eip_domain
  public_subnets = {
    public-1 = {
      "cidr_offset" = 1
      "az_index"    = 0
    }
    public-2 = {
      "cidr_offset" = 2
      "az_index"    = 1
    }
  }
  private_subnets = {
    private-1 = {
      "cidr_offset" = 11
      "az_index"    = 0
    }
    private-2 = {
      "cidr_offset" = 12
      "az_index"    = 1
    }
  }
}

module "security" {
  source = "../../modules/security"

  # local variables
  project_name      = var.project_name
  vpc_cidr_range    = var.vpc_cidr_range
  subnet_cidr_range = var.subnet_cidr_range
  cidr_range_all    = var.cidr_range_all
  https_port        = var.https_port
  http_port         = var.http_port
  backend_port      = var.backend_port
  frontend_port     = var.frontend_port
  db_port           = var.db_port

  # networking module outputs
  vpc_id = module.networking.vpc_id
}

module "alb_access_logs" {
  source = "../../modules/logging/alb_access_logs"

  # local variables
  project_name               = var.project_name
  s3_object_ownership        = var.s3_object_ownership        # BucketOwnerEnforced
  s3_to_glacier_storage_days = var.s3_to_glacier_storage_days # 90
  s3_to_expiration_days      = var.s3_to_expiration_days      # 365
}

module "cloudtrail" {
  source = "../../modules/logging/cloudtrail"

  # local variables
  project_name               = var.project_name
  cloudwatch_retention_days  = var.cloudwatch_retention_days  # 1
  s3_object_ownership        = var.s3_object_ownership        # BucketOwnerEnforced
  s3_to_glacier_storage_days = var.s3_to_glacier_storage_days # 90
  s3_to_expiration_days      = var.s3_to_expiration_days      # 365
}

module "ecs_app_logs" {
  source = "../../modules/logging/ecs_app_logs"

  # local variables
  project_name              = var.project_name
  cloudwatch_retention_days = var.cloudwatch_retention_days
}

module "vpc_flow_logs" {
  source = "../../modules/logging/vpc_flow_logs"

  # local variables
  project_name                  = var.project_name
  vpc_flow_logs_traffic_type    = var.vpc_flow_logs_traffic_type
  vpc_flow_log_max_agg_interval = var.vpc_flow_log_max_agg_interval
  vpc_flow_log_file_format      = var.vpc_flow_log_file_format
  s3_object_ownership           = var.s3_object_ownership
  s3_to_glacier_storage_days    = var.s3_to_glacier_storage_days
  s3_to_expiration_days         = var.s3_to_expiration_days

  # networking module outputs
  vpc_id = module.networking.vpc_id
}

module "rds_logs" {
  source = "../../modules/logging/rds_logs"

  db_name                   = var.db_name
  db_engine_version         = var.db_engine_version
  cloudwatch_retention_days = var.cloudwatch_retention_days
}

module "waf_logs" {
  source = "../../modules/logging/waf_logs"

  # local variables
  s3_object_ownership        = var.s3_object_ownership
  s3_to_glacier_storage_days = var.s3_to_glacier_storage_days
  s3_to_expiration_days      = var.s3_to_expiration_days
}

module "database" {
  source = "../../modules/database"

  # local variables
  project_name              = var.project_name
  db_name                   = var.db_name
  db_engine                 = var.db_engine
  db_engine_version         = var.db_engine_version
  db_instance_class         = var.db_instance_class
  db_storage                = var.db_storage
  db_max_storage            = var.db_max_storage
  db_backup_retention_days  = var.db_backup_retention_days
  db_backup_window          = var.db_backup_window
  db_maintenance_window     = var.db_maintenance_window
  cloudwatch_retention_days = var.cloudwatch_retention_days

  # networking module outputs
  db_subnet_groups = module.networking.private_subnet_ids


  # security module outputs
  vpc_security_groups = [
    module.security.rds_sg_id
  ]

  # rds logs module outputs
  log_group_params_name = module.rds_logs.rds_parameter_group_name

  depends_on = [module.security.rds_sg_id]
}

module "load_balancing" {
  source = "../../modules/load_balancing"

  # local variables
  lb_type            = var.lb_type
  frontend_port      = var.frontend_port
  backend_port       = var.backend_port
  http_protocol      = var.http_protocol
  http_port          = var.http_port
  https_protocol     = var.https_protocol
  https_port         = var.https_port
  alias_domain       = var.alias_domain
  ssl_policy_version = var.ssl_policy_version


  # networking module outputs
  vpc_id     = module.networking.vpc_id
  lb_subnets = module.networking.public_subnet_ids


  # security module outputs
  lb_security_groups = [
    module.security.alb_sg_id
  ]

  # alb access logs module outputs
  lb_access_logs_bucket = module.alb_access_logs.alb_access_log_s3_bucket_id

}


module "waf" {
  source = "../../modules/waf"

  # load-balancing module outputs
  lb_resource = module.load_balancing.lb_arn

  # waf logs module outputs
  waf_logs_bucket        = module.waf_logs.waf_logs_bucket
  waf_logs_bucket_policy = module.waf_logs.waf_logs_bucket_policy
}

module "containers" {
  source = "../../modules/containers"

  project_name         = var.project_name
  ecs_network_mode     = var.ecs_network_mode
  backend_task_cpu     = var.backend_task_cpu
  backend_task_memory  = var.backend_task_memory
  backend_image_name   = var.backend_image_name
  backend_port         = var.backend_port
  frontend_task_cpu    = var.frontend_task_cpu
  frontend_task_memory = var.frontend_task_memory
  frontend_image_name  = var.frontend_image_name
  frontend_port        = var.frontend_port
  db_engine            = var.db_engine
  primary_region       = var.primary_region
  cluster_name         = var.cluster_name

  # networking module outputs
  ecs_subnet_group = module.networking.private_subnet_ids

  # database module outputs
  db_host_secret     = module.database.db_host_param_arn
  db_password_secret = module.database.db_password_arn
  db_name_secret     = module.database.db_name_param_arn
  db_port_secret     = module.database.db_port_param_arn

  # ecs app logs module outputs
  ecs_access_logs_bucket = module.ecs_app_logs.ecs_log_group_name

  # load balancing module outputs
  lb_dns_name              = var.alias_domain
  lb_backend_target_group  = module.load_balancing.backend_target_group
  lb_frontend_target_group = module.load_balancing.frontend_target_group

  # security module outputs
  ecs_security_groups = [
    module.security.ecs_sg_id
  ]
}

module "lb_dashboard" {
  source = "../../modules/dashboards/lb_cloudwatch_dashboard"

  primary_region = var.primary_region

  lb_arn_suffix          = module.load_balancing.lb_arn_suffix
  backend_tg_arn_suffix  = module.load_balancing.backend_target_group_arn_suffix
  frontend_tg_arn_suffix = module.load_balancing.frontend_target_group_arn_suffix
}

module "ecs_dashboard" {
  source = "../../modules/dashboards/ecs_cloudwatch_dashboard"

  primary_region = var.primary_region

  ecs_cluster_name          = module.containers.cluster_name
  ecs_frontend_service_name = module.containers.ecs_frontend_service_name
  ecs_backend_service_name  = module.containers.ecs_backend_service_name
}

module "rds_dashboard" {
  source = "../../modules/dashboards/rds_cloudwatch_dashboard"

  primary_region = var.primary_region

  db_instance_id = module.database.db_instance_id
}
