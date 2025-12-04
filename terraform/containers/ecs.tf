resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"
  cpu          = "1024"
  memory       = "2048"

  # execution_role_arn = 
  # task_role_arn =


  container_definitions = jsonencode([])

}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
  }

  network_mode = "awsvpc"
  cpu          = "1024"
  memory       = "2048"

  # execution_role_arn = 
  # task_role_arn =


  container_definitions = jsonencode([])
  #jsonencode([])
  /*
  Name
  Image
  Memory
  Port Mappings
  Private Repo Creds
  */

}

resource "aws_ecs_service" "frontend" {
  name          = "frontend"
  cluster       = aws_ecs_cluster.cluster.arn
  desired_count = 0
  # iam_role = 
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  task_definition  = aws_ecs_task_definition.frontend.arn
  load_balancer {
    container_name   = "frontend"
    container_port   = 80
    target_group_arn = data.terraform_remote_state.load_balancing.outputs.frontend_target_group_arn
  }
  network_configuration {
    subnets = [data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2a,
    data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2b]
    security_groups  = [data.terraform_remote_state.security.outputs.ecs_sg_id]
    assign_public_ip = false
  }
}

resource "aws_ecs_service" "backend" {
  name          = "backend"
  cluster       = aws_ecs_cluster.cluster.arn
  desired_count = 0
  # iam_role = 
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  task_definition  = aws_ecs_task_definition.backend.arn
  load_balancer {
    container_name   = "backend"
    container_port   = 8080
    target_group_arn = data.terraform_remote_state.load_balancing.outputs.backend_target_group_arn
  }
  network_configuration {
    subnets = [data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2a,
    data.terraform_remote_state.networking.outputs.private_subnet_id_us_east_2b]
    security_groups  = [data.terraform_remote_state.security.outputs.ecs_sg_id]
    assign_public_ip = false
  }
}
