# Generate a random password
resource "random_password" "db-password" {
  length = 16
  special = true
  override_special = "!#%^&*"
}

# Store username and password in Secrets Manager
resource "aws_secretsmanager_secret" "rds-db-creds" {
  name = "ecs-project/rds/creds"
  description = "RDS DB Creds for ECS backend service"
}

resource "aws_secretsmanager_secret_version" "rds-db-creds-version" {
  secret_id = aws_secretsmanager_secret.rds-db-creds.id
  secret_string = jsonencode({
    username = "db-admin"
    password = random_password.db-password.result
  })
}