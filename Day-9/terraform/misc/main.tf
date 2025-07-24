#VPC
data "aws_vpc" "default_vpc" {
  default = true
}
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}


#east-2a subnet
data "aws_subnet_ids" "subnet_a" {
  vpc_id = data.aws_vpc.default_vpc.id

  filter {
    name   = "availability-zone"
    values = ["us-east-2a"]
  }
}
data "aws_subnet" "public_subnet_a" {
  id = element(data.aws_subnet_ids.subnet_a.ids, 0)
}
#east-2b subnet
data "aws_subnet_ids" "subnet_b" {
  vpc_id = data.aws_vpc.default_vpc.id

  filter {
    name   = "availability-zone"
    values = ["us-east-2b"]
  }
}
data "aws_subnet" "public_subnet_b" {
  id = element(data.aws_subnet_ids.subnet_b.ids, 0)
}


#Subnets
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = data.aws_vpc.default_vpc.id
  cidr_block              = var.public_sub_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "strapi_public_subnet_${count.index + 1}-balaji"
  }
}


#Routes

####PUBLIC SUBNET ROUTES
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = data.aws_vpc.default_vpc.id

  route {
    cidr_block = data.aws_vpc.default_vpc.cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "strapi_public_subnet_routetable-balaji"
  }
}
resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_rt.id
}



#Security Groups
resource "aws_security_group" "public_sg" {
  name                   = "public_sg-balaji"
  description            = "SG for instances in Public Subnet."
  vpc_id                 = data.aws_vpc.default_vpc.id
  egress                 = []
  revoke_rules_on_delete = true

  tags = {
    Name = "strapi_public_security_group-balaji"
  }
}
resource "aws_vpc_security_group_ingress_rule" "http_from_internet_to_public_sg" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow inbound HTTP from internet"
}
resource "aws_vpc_security_group_ingress_rule" "alb_to_ecs_on_1337" {
  security_group_id            = aws_security_group.public_sg.id
  referenced_security_group_id = aws_security_group.public_sg.id
  from_port                    = 1337
  to_port                      = 1337
  ip_protocol                  = "tcp"
  description                  = "Allow ALB to ECS on port 1337"
}
resource "aws_vpc_security_group_ingress_rule" "ecs_to_postgres_5432" {
  security_group_id            = aws_security_group.public_sg.id
  referenced_security_group_id = aws_security_group.public_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Allow ECS to connect to PostgreSQL on port 5432"
}
resource "aws_vpc_security_group_egress_rule" "to_internet_from_public_sg" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allows outbound connections to internet via NAT gateway"
}


#Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb-strapi-balaji"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
  security_groups    = [aws_security_group.public_sg.id]
  internal           = false

  tags = {
    Name = "strapi_load_balancer-balaji"
  }
}
resource "aws_lb_listener" "app_lb_http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
  }

  tags = {
    Name = "app_lb_http_listener-balaji"
  }
}
resource "aws_lb_target_group" "strapi_tg" {
  name        = "strapi-target-group-balaji"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default_vpc.id
  target_type = "ip"

  health_check {
    path                = "/admin"
    protocol            = "HTTP"
    matcher             = "200-299"
    port                = 1337
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "strapi_target_group-balaji"
  }
}


#Database
resource "aws_db_subnet_group" "strapi_postgres_subnet_group" {
  name       = "strapi-postgres-subnet-group-balaji"
  subnet_ids = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]

  tags = {
    Name = "strapi_postgres_subnet_group-balaji"
  }
}
resource "aws_db_instance" "strapi_rds_postgresql" {
  allocated_storage      = 10
  db_name                = var.database_name
  identifier             = "strapi-postgres"
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = "db.t3.micro"
  username               = var.database_username
  password               = var.database_password
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.strapi_postgres_subnet_group.name
  skip_final_snapshot    = true

  tags = {
    Name = "strapi_postgres_DB-balaji"
  }
}


