resource "aws_lb" "alb-for-ecs-tasks" {
  name               = "alb-for-ecs-tasks"
  load_balancer_type = "application" # cross zone load balancing enabled by default

  subnets = [
    data.terraform_remote_state.networking.outputs.subnet_id_us_east_2a,
    data.terraform_remote_state.networking.outputs.subnet_id_us_east_2b
  ]

  security_groups = [data.terraform_remote_state.security.outputs.alb_sg_id]
}

resource "aws_alb_target_group" "ecs-target-group" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    # Currently using all default values
  }

  tags = {
    Name = "ecs-target-group"
  }
}

resource "aws_alb_listener" "alb-for-ecs-listener" {
  load_balancer_arn = aws_lb.alb-for-ecs-tasks.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
  }
}
