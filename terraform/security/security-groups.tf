
# ALB Security Group
resource "aws_security_group" "alb_sg_public" {
  name        = "alb-sg-public"
  description = "Allow inbound traffic from anywhere and outbound traffic to ECS cluster"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  tags = {
    Name = "alb-sg-public"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress_https" {
  security_group_id = aws_security_group.alb_sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress_http" {
  security_group_id = aws_security_group.alb_sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# should be updated to allow traffic to the target group of the alb
resource "aws_vpc_security_group_egress_rule" "alb_sg_egress" {
  security_group_id            = aws_security_group.alb_sg_public.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}


# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow inbound traffic from ALB and outbound to RDS"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id
  tags = {
    Name = "ecs-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_sg_ingress" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg_public.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}


# Allow traffic from the ECS cluster to RDS
resource "aws_vpc_security_group_egress_rule" "ecs_sg_egress_rds" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.rds_sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

# Allow ECS traffic to reach the internet over https if needed
resource "aws_vpc_security_group_egress_rule" "ecs_sg_egress_internet" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow inbound traffic from ECS cluster and outbound to ECS Cluster"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id
  tags = {
    Name = "rds-sg"
  }
}

# No egress needed due to stateful nature of security groups
resource "aws_vpc_security_group_ingress_rule" "rds_sg_ingress" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 5432 # RDS Port
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

