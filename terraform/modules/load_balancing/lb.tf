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

  lifecycle {
    create_before_destroy = true
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

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "backend-target-group"
  }
}

resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb_ecs_tasks.arn
  port              = var.https_port
  protocol          = var.https_protocol

  # Need cert before this step
  ssl_policy      = var.ssl_policy_version # Use TLS 1.3 (Modern Best Practice)
  certificate_arn = aws_acm_certificate_validation.cert_verify.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend_target_group.arn
  }
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_lb.alb_ecs_tasks.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = var.https_protocol
      status_code = "HTTP_301" # Webpage moved to new URL
    }
  }
}

# for the frontend and backend to be handled by different containers, the alb will
# have to handle routing traffic between the two, potentially using path based routing
resource "aws_lb_listener_rule" "listener_backend_rule" {
  listener_arn = aws_alb_listener.https_listener.arn
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
