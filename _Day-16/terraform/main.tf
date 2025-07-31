#########################################################################
#VPC
#########################################################################
data "aws_vpc" "default_vpc" {
  default = true
}
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

#########################################################################
#Subnets
#########################################################################
#east-2a subnet
data "aws_subnets" "subnet_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-2a"]
  }
}
data "aws_subnet" "public_subnet_a" {
  id = element(data.aws_subnets.subnet_a.ids, 0)
}
#east-2b subnet
data "aws_subnets" "subnet_b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-2b"]
  }
}
data "aws_subnet" "public_subnet_b" {
  id = element(data.aws_subnets.subnet_b.ids, 0)
}


#########################################################################
#Security Groups
#########################################################################
resource "aws_security_group" "app_lb_sg" {
  name        = "App-lb-sg-balaji"
  description = "Allows HTTP/HTTPS"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "app_lb_security_group-balaji"
  }
}

resource "aws_security_group" "ecs_strapi_sg" {
  name        = "ecs-strapi-sg-balaji"
  description = "Allows ALB to ECS"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.app_lb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_strapi_security_group-balaji"
  }
}

resource "aws_security_group" "db_rds_sg" {
  name        = "db-rds-sg-balaji"
  description = "SG for RDS DB."
  vpc_id      = data.aws_vpc.default_vpc.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_strapi_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DB_RDS_security_group-balaji"
  }
}


#########################################################################
#Load Balancer
#########################################################################
resource "aws_lb" "app_lb" {
  name               = "app-lb-strapi-balaji"
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public_subnet_a.id, data.aws_subnet.public_subnet_b.id]
  security_groups    = [aws_security_group.app_lb_sg.id]
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
    target_group_arn = aws_lb_target_group.strapi_blue_tg.arn
  }

  tags = {
    Name = "app_lb_http_listener-balaji"
  }
}
resource "aws_lb_target_group" "strapi_blue_tg" {
  name        = "strapi-blue-target-group-balaji"
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
    Name = "strapi_blue_target_group-balaji"
  }
}
resource "aws_lb_target_group" "strapi_green_tg" {
  name        = "strapi-green-target-group-balaji"
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
    Name = "strapi_green_target_group-balaji"
  }
}

#########################################################################
#Database
#########################################################################
resource "aws_db_subnet_group" "strapi_postgres_subnet_group" {
  name       = "strapi-postgres-subnet-group-balaji"
  subnet_ids = [data.aws_subnet.public_subnet_a.id, data.aws_subnet.public_subnet_b.id]

  tags = {
    Name = "strapi_postgres_subnet_group-balaji"
  }
}
resource "aws_db_parameter_group" "strapi_postgres_param_group" {
  name        = "strapi-postgres-param-group-balaji"
  family      = "postgres17"
  description = "Custom parameter group for Strapi Postgres"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  tags = {
    Name = "strapi_postgres_param_group-balaji"
  }
}
resource "aws_db_instance" "strapi_rds_postgresql" {
  allocated_storage      = 10
  db_name                = var.database_name
  identifier             = "strapi-postgres-balaji"
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = "db.t3.micro"
  username               = var.database_username
  password               = var.database_password
  snapshot_identifier    = var.snapshot_name
  vpc_security_group_ids = [aws_security_group.db_rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.strapi_postgres_subnet_group.name
  skip_final_snapshot    = true
  parameter_group_name   = aws_db_parameter_group.strapi_postgres_param_group.name

  tags = {
    Name = "strapi_postgres_DB-balaji"
  }
}


