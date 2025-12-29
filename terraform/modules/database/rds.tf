resource "aws_db_instance" "rds_db" {
  db_name                     = var.db_name
  identifier                  = var.db_name
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  allocated_storage           = var.db_storage
  max_allocated_storage       = var.db_max_storage
  multi_az                    = true
  backup_retention_period     = var.db_backup_retention_days
  copy_tags_to_snapshot       = true
  backup_window               = var.db_backup_window # set outside of working hours
  maintenance_window          = var.db_maintenance_window
  manage_master_user_password = true
  username                    = "dbadmin"
  skip_final_snapshot         = true # don't need data to be recoverable in our situation
  vpc_security_group_ids      = var.vpc_security_groups
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_groups.name

  enabled_cloudwatch_logs_exports = ["postgresql"]
  parameter_group_name            = var.log_group_params_name

  performance_insights_enabled          = true
  performance_insights_retention_period = 465
  database_insights_mode                = "advanced"

  tags = {
    Name = "esc-project-db"
  }
}

resource "aws_db_subnet_group" "rds_subnet_groups" {
  name       = "rds-subnet-groups"
  subnet_ids = var.db_subnet_groups
}

# RDS Secrets for SSM Parameter Store
resource "aws_ssm_parameter" "db_host" {
  name  = "/ecs-project/database/host"
  type  = "String"
  value = aws_db_instance.rds_db.address
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/ecs-project/database/name"
  type  = "String"
  value = aws_db_instance.rds_db.db_name
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/ecs-project/database/port"
  type  = "String"
  value = tostring(aws_db_instance.rds_db.port)
}

