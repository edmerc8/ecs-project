
# ALB Security Group
resource "aws_security_group" "alb_sg_public" {
  name        = "alb-sg-public"
  description = "Allow inbound traffic from anywhere and outbound traffic to ECS cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb-sg-public"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress_https" {
  security_group_id = aws_security_group.alb_sg_public.id
  cidr_ipv4         = var.cidr_range_all
  from_port         = var.https_port
  ip_protocol       = "tcp"
  to_port           = var.https_port
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress_http" {
  security_group_id = aws_security_group.alb_sg_public.id
  cidr_ipv4         = var.cidr_range_all
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
}

# should be updated to allow traffic to the target group of the alb - the ecs frontend
resource "aws_vpc_security_group_egress_rule" "alb_sg_egress_ecs_frontend" {
  security_group_id            = aws_security_group.alb_sg_public.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = var.frontend_port
  ip_protocol                  = "tcp"
  to_port                      = var.frontend_port
}

# should be updated to allow traffic to the target group of the alb - the ecs backend
resource "aws_vpc_security_group_egress_rule" "alb_sg_egress_ecs_backend" {
  security_group_id            = aws_security_group.alb_sg_public.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = var.backend_port
  ip_protocol                  = "tcp"
  to_port                      = var.backend_port
}


# ECS Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow inbound traffic from ALB and outbound to RDS"
  vpc_id      = var.vpc_id
  tags = {
    Name = "ecs-sg"
  }
}

# Allow alb traffic on port 8080
resource "aws_vpc_security_group_ingress_rule" "ecs_sg_ingress" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg_public.id
  from_port                    = var.frontend_port
  ip_protocol                  = "tcp"
  to_port                      = var.frontend_port
}

# Allow alb traffic on port 3000
resource "aws_vpc_security_group_ingress_rule" "ecs_sg_ingress_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg_public.id
  from_port                    = var.backend_port
  ip_protocol                  = "tcp"
  to_port                      = var.backend_port
}


# Allow traffic from the ECS cluster to RDS
resource "aws_vpc_security_group_egress_rule" "ecs_sg_egress_rds" {
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.rds_sg.id
  from_port                    = var.db_port
  ip_protocol                  = "tcp"
  to_port                      = var.db_port
}

# Allow ECS traffic to reach the internet if needed
resource "aws_vpc_security_group_egress_rule" "ecs_sg_egress_internet" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = var.cidr_range_all
  ip_protocol       = "-1"
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow inbound traffic from ECS cluster and outbound to ECS Cluster"
  vpc_id      = var.vpc_id
  tags = {
    Name = "rds-sg"
  }
}

# Allow traffic from ECS to RDS
resource "aws_vpc_security_group_ingress_rule" "rds_sg_ingress" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = var.db_port # RDS Port
  ip_protocol                  = "tcp"
  to_port                      = var.db_port
}

