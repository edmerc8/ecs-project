# Allows ECS Cluster to pull images from ECR, send logs to cloudwatch, etc
resource "aws_iam_role" "ecs-execution-role" {
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

resource "aws_iam_policy" "ecr-access-policy" {
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
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*" # Update to only provide access to the Private Repo needed for the project
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-execution-role-ecr-access" {
  role       = aws_iam_role.ecs-execution-role.name
  policy_arn = aws_iam_policy.ecr-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-execution-role-secrets-manager-rds-creds" {
  role       = aws_iam_role.ecs-execution-role.name
  policy_arn = aws_iam_policy.ecs-secrets-access.arn
}


resource "aws_iam_policy" "ecs-secrets-access" {
  name        = "ecs-secrets-access"
  description = "Allows ECS task to read the RDS DB credentials"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = data.terraform_remote_state.database.outputs.db_password_arn
      }
    ]
    }
  )
}


# Placeholder for Backend Role, not currently needed
# RDS access provided by task execution role
resource "aws_iam_role" "ecs-task-role-backend" {
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
resource "aws_iam_role" "ecs-task-role-frontend" {
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
