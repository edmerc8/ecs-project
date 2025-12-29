# Allows ECS Cluster to pull images from ECR, send logs to cloudwatch, etc
resource "aws_iam_role" "ecs_backend_execution_role" {
  name = "ecs-backend-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "ecs-execution-role"
  }
}

# Allows ECS Cluster to pull images from ECR, send logs to cloudwatch, etc
resource "aws_iam_role" "ecs_frontend_execution_role" {
  name = "ecs-frontend-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "ecs-execution-role"
  }
}

# ECR Access Policy
resource "aws_iam_policy" "ecr_access_policy" {
  name = "ecr-access-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = [
          data.aws_ecr_repository.ecr_frontend_repo_url.arn,
          data.aws_ecr_repository.ecr_backend_repo_url.arn
        ]
      }
    ]
  })
}

# CloudWatch Logs Policy
resource "aws_iam_policy" "cloudwatch_logs_access_policy" {
  name = "cloudwatch_logs-access-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:ecs-app-logs:*"
      }
    ]
  })
}

# Secrets Manager & SSM Policy
resource "aws_iam_policy" "ecs_secrets_access" {
  name        = "ecs-secrets-access"
  description = "Allows ECS task to read the RDS DB credentials"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "ssm:GetParameters"
        ]
        Resource = [
          var.db_host_secret,
          var.db_password_secret,
          var.db_name_secret,
          var.db_port_secret
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_backend_execution_role_ecr_access" {
  role       = aws_iam_role.ecs_backend_execution_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_backend_execution_role_cloudwatch_logs_access" {
  role       = aws_iam_role.ecs_backend_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_backend_execution_role_secrets_manager_rds_creds" {
  role       = aws_iam_role.ecs_backend_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_access.arn
}

resource "aws_iam_role_policy_attachment" "ecs_frontend_execution_role_ecr_access" {
  role       = aws_iam_role.ecs_frontend_execution_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_frontend_execution_role_cloudwatch_logs_access" {
  role       = aws_iam_role.ecs_frontend_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_access_policy.arn
}
