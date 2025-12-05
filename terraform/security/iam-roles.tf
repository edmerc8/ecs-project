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

resource "aws_iam_role_policy" "ecr-access-policy" {
  name = "ecr-access-policy"
  role = aws_iam_role.ecs-execution-role.name

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

resource "aws_iam_role" "ecs-task-role-rds" {
  name = "ecs-task-role-rds"
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
    Name      = "ecs-task-role-rds"
    Project   = "ecs-fargate"
    Owner     = "edm"
    CreatedBy = "terraform"
  }
}

# Need to figure out how to manage rds access using secrets manager for security

# resource "aws_iam_role_policy" "rds-access-policy" {
#   name = "ecr-access-policy"
#   role = aws_iam_role.ecs-execution-role.name

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : "rds-db:connect"
#         "Resource" : [
#           ""
#         ]
#       }
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
