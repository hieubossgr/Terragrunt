# Security Group for ALB
resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id
  name = var.sg_alb_name

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Security Group for ECS
resource "aws_security_group" "ecs" {
  vpc_id = var.vpc_id
  name = var.sg_ecs_name
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
        aws_security_group.alb.id,
        aws_security_group.cronjob.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}

# Security Group for Cronjob
resource "aws_security_group" "cronjob" {
  vpc_id = var.vpc_id
  name = var.sg_cronjob_name
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cronjob-sg"
  }
}

# Security Group for Aurora RDS
resource "aws_security_group" "rds" {
  vpc_id = var.vpc_id
  name = var.sg_rds_name
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.cronjob.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}