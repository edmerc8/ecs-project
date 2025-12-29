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
  network_mode             = var.ecs_network_mode
  cpu                      = var.backend_task_cpu
  memory                   = var.backend_task_memory
  execution_role_arn       = aws_iam_role.ecs_backend_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
  }


  container_definitions = jsonencode([
    {
      "name" : "backend",
      "image" : "${data.aws_ecr_repository.ecr_backend_repo_url.repository_url}:${var.backend_image_name}",
      "cpu" : var.backend_task_cpu,       # full capacity of the task
      "memory" : var.backend_task_memory, # full capacity of the task
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : var.backend_port,
          "hostPort" : var.backend_port,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs", # built in cloudwatch log driver
        "options" : {
          "awslogs-group" : var.ecs_access_logs_bucket, # Reference from logging
          "awslogs-region" : var.primary_region,        # Bucket region
          "awslogs-stream-prefix" : "backend-task"
        }
      },
      "environment" : [
        {
          "name" : "DB_ENGINE",
          "value" : var.db_engine
        },
      ],
      "secrets" : [
        {
          "name" : "PG_HOST",
          "valueFrom" : var.db_host_secret # retrieve from Parameter store
        },
        {
          "name" : "PG_USER",
          "valueFrom" : "${var.db_password_secret}:username::" # arn + key
        },
        {
          "name" : "PG_PASSWORD",
          "valueFrom" : "${var.db_password_secret}:password::" # arn + key
        },
        {
          "name" : "PG_DB",
          "valueFrom" : var.db_name_secret # retrieve from Parameter Store
        },
        {
          "name" : "PG_PORT",
          "valueFrom" : var.db_port_secret
        },
      ]
    }
  ])
}

# Frontend Container Setup
resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.ecs_network_mode
  cpu                      = var.frontend_task_cpu
  memory                   = var.frontend_task_memory
  execution_role_arn       = aws_iam_role.ecs_frontend_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      "name" : "frontend",
      "image" : "${data.aws_ecr_repository.ecr_frontend_repo_url.repository_url}:${var.frontend_image_name}",
      "cpu" : var.frontend_task_cpu,
      "memory" : var.frontend_task_memory,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : var.frontend_port,
          "hostPort" : var.frontend_port,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs", # built in cloudwatch log driver
        "options" : {
          "awslogs-group" : var.ecs_access_logs_bucket, # Reference from logging
          "awslogs-region" : var.primary_region,        # Bucket region
          "awslogs-stream-prefix" : "frontend-task"
        }
      },
      "environment" : [
        {
          "name" : "API_BASE_URL",
          "value" : "http://${var.lb_dns_name}/api" # Public API endpoint; Will likely be modified with an A record
        }
      ]
    }
  ])
}
