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
  role = aws_iam_role.ecs-execution-role.name
  policy_arn = aws_iam_policy.ecr-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-execution-role-secrets-manager-rds-creds" {
  role = aws_iam_role.ecs-execution-role.name
  policy_arn = aws_iam_policy.ecs-secrets-access.arn
}


resource "aws_iam_policy" "ecs-secrets-access" {
  name = "ecs-secrets-access"
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

# resource "aws_iam_role_policy_attachment" "ecs-secrets-manager-rds-creds" {
#   role = aws_iam_role.ecs-task-role-rds
#   policy_arn = aws_iam_policy.ecs-secrets-access.arn
# }

# resource "aws_iam_role" "ecs-task-role-rds" {
#   name = "ecs-task-role-rds"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })

#   tags = {
#     Name      = "ecs-task-role-rds"
#     Project   = "ecs-fargate"
#     Owner     = "edm"
#     CreatedBy = "terraform"
#   }
# }

# Need to figure out how to manage rds access using secrets manager for security

# resource "aws_iam_role" "rds-access-policy" {
#   name = "rds-access-policy"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }



# resource "aws_iam_role" "frontend-task-role" {
#   assume_role_policy = jsondecode()

#   tags = {
#     Project   = "ecs-fargate"
#     Owner     = "edm"
#     CreatedBy = "terraform"
#   }
# }
