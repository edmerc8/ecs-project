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
