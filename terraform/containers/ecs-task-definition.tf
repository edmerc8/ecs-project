/*
This file contains the terraform code for the ECS task definitions. 
The ECS Fargate cluster will run two types of containers.
One will be for the frontend of the application and the other will be for the backend.
The ECS Cluster will be spread across two availability zones for High Availability.
*/

# Backend Container Setup
resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = data.terraform_remote_state.iam.outputs.task_execution_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
  }


  container_definitions = jsonencode([
    {
      "name" : "backend",
      "image" : "${data.terraform_remote_state.ecr.outputs.ecr_repo_url}:backend-v1",
      "cpu" : 1024,    # full capacity of the task
      "memory" : 2048, # full capacity of the task
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs", # built in cloudwatch log driver
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : data.terraform_remote_state.ecs_app_logs.outputs.ecs_log_group_name, # Reference from logging
          "awslogs-region" : "us-east-2",                                                        # Bucket region
          "awslogs-stream-prefix" : "backend"                                                    # double check this
        }
      },
      "secrets" : [
        {
          "name" : "PG_HOST",
          "valueFrom" : "${data.terraform_remote_state.database.outputs.db_host_param_arn}" # retrieve from Parameter store
        },
        {
          "name" : "PG_USER",
          "valueFrom" : "${data.terraform_remote_state.database.outputs.db_password_arn}:username::" # arn + key
        },
        {
          "name" : "PG_PASSWORD",
          "valueFrom" : "${data.terraform_remote_state.database.outputs.db_password_arn}:password::" # arn + key
        },
        {
          "name" : "PG_DB",
          "valueFrom" : "${data.terraform_remote_state.database.outputs.db_name_param_arn}" # retrieve from Parameter Store
        },
      ]
    }
  ])
}

# Frontend Container Setup
resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = data.terraform_remote_state.iam.outputs.task_execution_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      "name" : "frontend",
      "image" : "${data.terraform_remote_state.ecr.outputs.ecr_repo_url}:frontend-v1",
      "cpu" : 1024,
      "memory" : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs", # built in cloudwatch log driver
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : data.terraform_remote_state.ecs_app_logs.outputs.ecs_log_group_name, # Reference from logging
          "awslogs-region" : "us-east-2",                                                        # Bucket region
          "awslogs-stream-prefix" : "frontend"                                                   # double check this
        }
      },
      "environment" : [
        {
          "name" : "API_BASE_URL",
          "value" : "http://${data.terraform_remote_state.load_balancing.outputs.alb_dns_name}/api" # Public API endpoint; Will likely be modified with an A record
        }
      ]
    }
  ])
}
