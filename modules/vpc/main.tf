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