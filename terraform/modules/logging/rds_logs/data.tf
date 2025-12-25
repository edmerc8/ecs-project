data "aws_rds_engine_version" "postgres17" {
  engine  = "postgres"
  version = var.db_engine_version
}
