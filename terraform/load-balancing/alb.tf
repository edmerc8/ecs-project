# ALB responsible for routing and distributing requests to the ECS Cluster
resource "aws_lb" "alb_ecs_tasks" {
  name               = "alb-ecs-tasks"
  load_balancer_type = "application" # cross zone load balancing enabled by default

  # public subnets the ALB should span
  subnets = [
    data.terraform_remote_state.networking.outputs.public_subnet_id_us_east_2a,
    data.terraform_remote_state.networking.outputs.public_subnet_id_us_east_2b
  ]

  security_groups = [data.terraform_remote_state.security.outputs.alb_sg_id]

  access_logs {
    bucket  = data.terraform_remote_state.alb-access-logs.outputs.alb_access_log_s3_bucket_id
    enabled = true
  }
}

resource "aws_alb_target_group" "frontend_target_group" {
  name        = "frontend-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id
  target_type = "ip"

  # Currently using all default values for Health Check
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "frontend-target-group"
  }
}

resource "aws_alb_target_group" "backend_target_group" {
  name        = "backend-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id
  target_type = "ip"

  # Currently using all default values for Health Check
  health_check {
    path                = "/api/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "backend-target-group"
  }
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_lb.alb_ecs_tasks.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend_target_group.arn
  }
}

# for the frontend and backend to be handled by different containers, the alb will
# have to handle routing traffic between the two, potentially using path based routing
resource "aws_lb_listener_rule" "listener_backend_rule" {
  listener_arn = aws_alb_listener.listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.backend_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
