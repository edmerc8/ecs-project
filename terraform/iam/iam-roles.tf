# Allows ECS Cluster to pull images from ECR, send logs to cloudwatch, etc
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name      = "ecs-execution-role"
    Project   = "ecs-fargate"
    Owner     = "edm"
    CreatedBy = "terraform"
  }
}

resource "aws_iam_policy" "ecr_access_policy" {
  name = "ecr-access-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ],
        "Resource" : "*" # Update to only provide access to the Private Repo needed for the project
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_access_policy" {
  name = "cloudwatch_logs-access-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*" # Update to only provide access to the group needed for the project
      }
    ]
  })
}

# Attaches Cloudwatch Logs access role to ECS Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_cloudwatch_logs_access" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_access_policy.arn
}

# Attaches ECR access role to ECS Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_ecr_access" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

# Attaches Secrets Manager RDS Credentials role to ECS Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_secrets_manager_rds_creds" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_access.arn
}


resource "aws_iam_role" "cloudtrail_cloudwatch_log_delivery_role" {
  name = "cloudtrail-cloudwatch-log-delivery-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name      = "cloudtrail-cloudwatch-log-delivery-role"
    Project   = "ecs-fargate"
    Owner     = "edm"
    CreatedBy = "terraform"
  }
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs_access_policy" {
  name = "cloudtrail_cloudwatch_logs-access-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*" # Update to only provide access to the group needed for the project (may need to use variable for cloudtrail log group name)
      }
    ]
  })
}

# Attaches Cloudwatch Logs access role to CloudTrail Log Delivery Role
resource "aws_iam_role_policy_attachment" "cloudtrail_role_cloudwatch_logs_access" {
  role       = aws_iam_role.cloudtrail_cloudwatch_log_delivery_role.name
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs_access_policy.arn
}



# Provides access to RDS Credentials in Secrets Manager
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
          data.terraform_remote_state.database.outputs.db_password_arn,
          data.terraform_remote_state.database.outputs.db_host_param_arn,
          data.terraform_remote_state.database.outputs.db_name_param_arn,
          data.terraform_remote_state.database.outputs.db_port_param_arn
        ]
      }
    ]
    }
  )
}


# Placeholder for Backend Role, not currently needed
# RDS access provided by task execution role
resource "aws_iam_role" "ecs_task_role_backend" {
  name = "ecs-task-role-backend"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Project   = "ecs-fargate"
    Owner     = "edm"
    CreatedBy = "terraform"
  }
}

# Placeholder for Frontend Role, not currently needed
resource "aws_iam_role" "ecs_task_role_frontend" {
  name = "ecs-task-role-frontend"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Project   = "ecs-fargate"
    Owner     = "edm"
    CreatedBy = "terraform"
  }
}
