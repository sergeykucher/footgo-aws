
resource "aws_vpc" "vpc_net_result" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.vpc_title} VPC"
  }
}

resource "aws_internet_gateway" "igw_result" {
  vpc_id = aws_vpc.vpc_net_result.id
  tags = {
    Name = "${var.vpc_title} IGW"
  }
}

resource "aws_subnet" "public_subnet_a_result" {
  vpc_id                  = aws_vpc.vpc_net_result.id
  availability_zone       = var.public_subnets_az[0]
  cidr_block              = var.public_subnets_vpc_cidr_block[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_title} public subnet A"
  }
}

resource "aws_subnet" "public_subnet_b_result" {
  vpc_id                  = aws_vpc.vpc_net_result.id
  availability_zone       = var.public_subnets_az[1]
  cidr_block              = var.public_subnets_vpc_cidr_block[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_title} public subnet B"
  }
}

resource "aws_subnet" "private_subnet_a_result" {
  vpc_id                  = aws_vpc.vpc_net_result.id
  availability_zone       = var.private_subnets_az[0]
  cidr_block              = var.private_subnets_vpc_cidr_block[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_title} private subnet A"
  }
}

resource "aws_subnet" "private_subnet_b_result" {
  vpc_id                  = aws_vpc.vpc_net_result.id
  availability_zone       = var.private_subnets_az[1]
  cidr_block              = var.private_subnets_vpc_cidr_block[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_title} private subnet B"
  }
}

data "aws_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc_net_result.id
  name   = "default"
}

resource "aws_security_group" "ssh_security_group_result" {
  name        = "${var.vpc_title} SSH security group"
  description = "${var.vpc_title} SSH security group"
  vpc_id      = aws_vpc.vpc_net_result.id
  ingress {
    description = "allow SSH for ${var.ssh_cidr_block}"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]
  }
  egress {
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.destination_cidr_block]
  }
  tags = {
    Name = "${var.vpc_title} SSH security group"
  }
}

resource "aws_security_group" "http_8080_security_group_result" {
  name        = "${var.vpc_title} HTTP, 8080 security group"
  description = "${var.vpc_title} HTTP, 8080 security group"
  vpc_id      = aws_vpc.vpc_net_result.id
  ingress {
    description = "allow HTTP for ${var.http_8080_cidr_block}"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.http_8080_cidr_block]
  }
  ingress {
    description = "allow HTTP:8080 for ${var.http_8080_cidr_block}"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.http_8080_cidr_block]
  }
  egress {
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.destination_cidr_block]
  }
  tags = {
    Name = "${var.vpc_title} HTTP, 8080 security group"
  }
}

resource "aws_route_table" "public_a_route_table" {
  vpc_id = aws_vpc.vpc_net_result.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_result.id
  }
  tags = {
    Name = "${var.vpc_title} public A route table"
  }
}

resource "aws_route_table_association" "public_a_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_a_result.id
  route_table_id = aws_route_table.public_a_route_table.id
}

resource "aws_route_table" "public_b_route_table" {
  vpc_id = aws_vpc.vpc_net_result.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_result.id
  }
  tags = {
    Name = "${var.vpc_title} public B route table"
  }
}

resource "aws_route_table_association" "public_b_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_b_result.id
  route_table_id = aws_route_table.public_b_route_table.id
}

resource "aws_route_table" "private_a_route_table" {
  vpc_id = aws_vpc.vpc_net_result.id
  tags = {
    Name = "${var.vpc_title} private A route table"
  }
}

resource "aws_route_table_association" "private_a_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_a_result.id
  route_table_id = aws_route_table.private_a_route_table.id
}

resource "aws_route_table" "private_b_route_table" {
  vpc_id = aws_vpc.vpc_net_result.id
  tags = {
    Name = "${var.vpc_title} private B route table"
  }
}

resource "aws_route_table_association" "private_b_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_b_result.id
  route_table_id = aws_route_table.private_b_route_table.id
}
