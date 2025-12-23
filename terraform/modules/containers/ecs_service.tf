/*
This file contains the terraform code for the ECS container services. 
The ECS Fargate cluster will run two types of containers.
One will be for the frontend of the application and the other will be for the backend.
The ECS Cluster will be spread across two availability zones for High Availability.
*/

resource "aws_ecs_service" "backend" {
  name             = "backend"
  cluster          = aws_ecs_cluster.cluster.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  task_definition  = aws_ecs_task_definition.backend.arn

  load_balancer {
    container_name   = "backend"
    container_port   = var.backend_port
    target_group_arn = var.lb_backend_target_group
  }

  network_configuration {
    subnets          = var.ecs_subnet_group
    security_groups  = var.ecs_security_groups
    assign_public_ip = false
  }
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
    container_port   = var.frontend_port
    target_group_arn = var.lb_frontend_target_group
  }

  network_configuration {
    subnets          = var.ecs_subnet_group
    security_groups  = var.ecs_security_groups
    assign_public_ip = false
  }
}
