#ECS cluster for strapi
resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster-balaji"

  tags = {
    Name = "strapi_ecs_cluster-balaji"
  }
}
resource "aws_cloudwatch_log_group" "ecs_strapi_LG" {
  name              = "/ecs/strapi-balaji"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "strapi_TD" {
  family                   = "Strapi-Balaji"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = "arn:aws:iam::607700977843:role/ecs-task-execution-role"
  container_definitions = jsonencode([
    {
      name      = "strapi-balaji",
      image = "${var.ecr_repo}:${var.image_tag}", #My image in ECR
      essential = true,
      portMappings = [
        {
          containerPort = 1337,
          protocol      = "tcp"
        }
      ],
      environment = [
        { name = "DATABASE_CLIENT", value = var.database_client },
        { name = "DATABASE_HOST", value = local.database_host },
        { name = "DATABASE_PORT", value = var.database_port },
        { name = "DATABASE_NAME", value = var.database_name },
        { name = "DATABASE_USERNAME", value = var.database_username },
        { name = "DATABASE_PASSWORD", value = var.database_password },
        { name = "DATABASE_SSL", value = "false" },
      ],


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/strapi-balaji"
          awslogs-region        = "us-east-2"
          awslogs-stream-prefix = "ecs-strapi"
        }
      }
    }
  ])
  tags = {
    Name = "strapi_ecs_TD-balaji"
  }
}

resource "aws_ecs_service" "ecs_strapi_service" {
  name            = "strapi-balaji"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.strapi_TD.arn
  desired_count   = 1

  network_configuration {
    subnets          = [data.aws_subnet.public_subnet_a.id, data.aws_subnet.public_subnet_b.id]
    security_groups  = [aws_security_group.public_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi-balaji"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.app_lb_http_listener]

  tags = {
    Name = "strapi_ecs_service-balaji"
  }
}
