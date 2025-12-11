/*
This file contains the main terraform code for our ECS configuration. 
This will be an ECS Fargate cluster that will run two types of containers.
One will be for the frontend of the application and the other will be for the backend.
The ECS Cluster will be spread across two availability zones for High Availability.
*/

resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}

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
      ]
      "secrets" : [
        {
          "name" : "PG_HOST",
          "valueFrom" : "${data.terraform_remote_state.database.outputs.db_password_arn}:host::" # arn + key
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
          "valueFrom" : "${data.terraform_remote_state.database.outputs.db_password_arn}:dbname::" # arn + key
        },
      ]
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name             = "backend"
  cluster          = aws_ecs_cluster.cluster.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  task_definition  = aws_ecs_task_definition.backend.arn

  load_balancer {
    container_name   = "backend"
    container_port   = 3000
    target_group_arn = data.terraform_remote_state.load_balancing.outputs.backend_target_group_arn
  }

  network_configuration {
    subnets = [
      data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2a,
      data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2b
    ]
    security_groups = [
      data.terraform_remote_state.security.outputs.ecs_sg_id
    ]
    assign_public_ip = false
  }
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
      "environment" : [
        {
          "name" : "API_BASE_URL",
          "value" : "http://${data.terraform_remote_state.load_balancing.outputs.alb_dns_name}/api" # Public API endpoint
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "frontend" {
  name             = "frontend"
  cluster          = aws_ecs_cluster.cluster.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  task_definition  = aws_ecs_task_definition.frontend.arn

  load_balancer {
    container_name   = "frontend"
    container_port   = 80
    target_group_arn = data.terraform_remote_state.load_balancing.outputs.frontend_target_group_arn
  }

  network_configuration {
    subnets = [
      data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2a,
      data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2b
    ]
    security_groups = [
      data.terraform_remote_state.security.outputs.ecs_sg_id
    ]
    assign_public_ip = false
  }
}
