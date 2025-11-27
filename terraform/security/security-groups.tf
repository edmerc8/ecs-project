
# ALB Security Group
resource "aws_security_group" "sg-alb-public" {
  name        = "sg-alb-public"
  description = "Allow inbound traffic from anywhere and outbound traffic to ECS cluster"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg-alb-public"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg-alb-ingress" {
  security_group_id = aws_security_group.sg-alb-public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# should be updated to allow traffic to the target group of the alb
resource "aws_vpc_security_group_egress_rule" "sg-alb-egress" {
  security_group_id            = aws_security_group.sg-alb-public.id
  referenced_security_group_id = aws_security_group.sg-ecs.id
  from_port                    = 8080 # ECS Port
  ip_protocol                  = "tcp"
  to_port                      = 8080
}


# ECS Security Group
resource "aws_security_group" "sg-ecs-cluster" {
  name        = "sg-ecs-cluster"
  description = "Allow inbound traffic from ALB and outbound to RDS"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "sg-ecs-cluster"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg-ecs-ingress" {
  security_group_id            = aws_security_group.sg-ecs-cluster.id
  referenced_security_group_id = aws_security_group.sg-alb-public.id
  from_port                    = 8080 # ECS Port
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "sg-ecs-egress" {
  security_group_id            = aws_security_group.sg-ecs-cluster.id
  referenced_security_group_id = "0.0.0.0/0" # aws_security_group.sg-rds.id
  from_port                    = 5432        #RDS Port
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

# Allow traffic from the ECS cluster to RDS
resource "aws_vpc_security_group_egress_rule" "sg-ecs-egress-rds" {
  security_group_id            = aws_security_group.sg-ecs-cluster.id
  referenced_security_group_id = aws_security_group.sg-rds.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

# Allow ECS traffic to reach the internet over https if needed
resource "aws_vpc_security_group_egress_rule" "sg-ecs-egress-internet" {
  security_group_id = aws_security_group.sg-ecs-cluster.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# RDS Security Group
resource "aws_security_group" "sg-rds" {
  name        = "sg-rds"
  description = "Allow inbound traffic from ECS cluster and outbound to ECS Cluster"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "sg-rds"
  }
}

# No egress needed due to stateful nature of security groups
resource "aws_vpc_security_group_ingress_rule" "sg-rds-ingress" {
  security_group_id            = aws_security_group.sg-rds.id
  referenced_security_group_id = aws_security_group.sg-ecs-cluster.id
  from_port                    = 5432 # RDS Port
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

