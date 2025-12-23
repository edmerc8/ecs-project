# ALB responsible for routing and distributing requests to the ECS Cluster
resource "aws_lb" "alb_ecs_tasks" {
  name               = "alb-ecs-tasks"
  load_balancer_type = var.lb_type # cross zone load balancing enabled by default

  # public subnets the ALB should span
  subnets = var.lb_subnets

  security_groups = var.lb_security_groups
  access_logs {
    bucket  = var.lb_access_logs_bucket
    enabled = true
  }
}

resource "aws_alb_target_group" "frontend_target_group" {
  name        = "frontend-target-group"
  port        = var.frontend_port
  protocol    = var.http_protocol
  vpc_id      = var.vpc_id
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
  port        = var.backend_port
  protocol    = var.http_protocol
  vpc_id      = var.vpc_id
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
  port              = var.http_port
  protocol          = var.http_protocol


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
