#------------------------------------ VPC ------------------------------------#
data "aws_availability_zones" "availability" {}

# Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Deploy private subnets
resource "aws_subnet" "ecs_private_subnets" {
  for_each = var.ecs_private_subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.availability.names)[((each.value%2)) == 1 ? 1 : 2]
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "cronjob_private_subnets" {
  for_each = var.cronjob_private_subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.availability.names)[((each.value%2)) == 1 ? 1 : 2]
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "rds_private_subnets" {
  for_each = var.rds_private_subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.availability.names)[(each.value%2) == 1 ? 1 : 2]
  tags = {
    Name = each.key
  }
}

# Deploy public subnets
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value+100)
  availability_zone = tolist(data.aws_availability_zones.availability.names)[(each.value%2) == 1 ? 1 : 2]
  map_public_ip_on_launch = true
  tags = {
    Name = each.key
  }
}

# Create route table for public and private subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_rtb"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private_rtb"
  }
}

resource "aws_route_table_association" "public" {
  depends_on = [ aws_subnet.public_subnets ]
  route_table_id = aws_route_table.public_route_table.id
  for_each = aws_subnet.public_subnets
  subnet_id = each.value.id
}

resource "aws_route_table_association" "ecs_private" {
  depends_on = [ aws_subnet.ecs_private_subnets ]
  route_table_id = aws_route_table.private_route_table.id
  for_each = aws_subnet.ecs_private_subnets
  subnet_id = each.value.id
}

resource "aws_route_table_association" "cronjob_private" {
  depends_on = [ aws_subnet.cronjob_private_subnets ]
  route_table_id = aws_route_table.private_route_table.id
  for_each = aws_subnet.cronjob_private_subnets
  subnet_id = each.value.id
}

# Define internet_gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

# Create EIP for Nat Gateway
resource "aws_eip" "nat_gateway_eip" {
  depends_on = [ aws_internet_gateway.internet_gateway ]
  tags = {
    Name = "igw_eip"
  }
}

# Define Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [ aws_subnet.public_subnets ]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id = aws_subnet.public_subnets["public_subnet_1"].id
  tags = {
    Name = "nat_gateway"
  }
}
#------------------------------------ VPC ------------------------------------#


#------------------------------------ Secutiry Group ------------------------------------#
# Security Group for ALB
resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.vpc.id
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
  vpc_id = aws_vpc.vpc.id
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
  vpc_id = aws_vpc.vpc.id
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
  vpc_id = aws_vpc.vpc.id
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
#------------------------------------ Secutiry Group ------------------------------------#

#------------------------------------ ALB ------------------------------------#
resource "aws_lb" "custom_alb" {
  depends_on = [ aws_subnet.public_subnets, aws_security_group.alb ]
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_subnets["public_subnet_1"].id, aws_subnet.public_subnets["public_subnet_2"].id]

  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "ecs_target_group_blue" {
  name        = "${var.alb_name}-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "ecs_target_group_green" {
  name        = "${var.alb_name}-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "ecs1-blue" {
  load_balancer_arn = aws_lb.custom_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group_blue.arn
  }
}
#------------------------------------ ALB ------------------------------------#

###############################################################