resource "aws_db_parameter_group" "postgres_rds_params" {
  name   = "postgres-rds-params"
  family = data.aws_rds_engine_version.postgres18.parameter_group_family

  parameter {
    name  = "log_statement"
    value = "mod"
  }

  parameter {
    name  = "log_connections"
    value = "all"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  # Slow Query Logs, 1 second
  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "log_error_verbosity"
    value = "default"
  }


}
