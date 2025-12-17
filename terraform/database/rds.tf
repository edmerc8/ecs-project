/* TODO
- Link with Security Groups
- Link with IAM Roles
- Cloudwatch
*/

resource "aws_db_instance" "rds_db" {
  db_name                     = "ecsprojectdb"
  engine                      = "postgres"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  max_allocated_storage       = 100
  multi_az                    = true
  backup_retention_period     = 3
  copy_tags_to_snapshot       = true
  backup_window               = "03:00-04:00" # set outside of working hours
  maintenance_window          = "Mon:00:00-Mon:03:00"
  manage_master_user_password = true
  username                    = "dbadmin"
  skip_final_snapshot         = true # don't need data to be recoverable in our situation
  vpc_security_group_ids      = [data.terraform_remote_state.security.outputs.rds_sg_id]
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_groups.name


  tags = {
    Name = "esc-project-db"
  }
}

resource "aws_db_subnet_group" "rds_subnet_groups" {
  name = "rds-subnet-groups"
  subnet_ids = [
    data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2a,
    data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2b,
  ]
}

# RDS Secrets for SSM Parameter Store
resource "aws_ssm_parameter" "db_host" {
  name  = "/ecs-project/database/host"
  type  = "String"
  value = aws_db_instance.rds_db.address
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/ecs-project/database/port"
  type  = "String"
  value = tostring(aws_db_instance.rds_db.port)
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/ecs-project/database/name"
  type  = "String"
  value = aws_db_instance.rds_db.db_name
}
