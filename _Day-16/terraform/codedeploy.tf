resource "aws_codedeploy_app" "strapi_codedeploy" {
  name             = "strapi-codedeploy-balaji"
  compute_platform = "ECS"

  tags = {
    Name = "strapi_codedeploy-balaji"
  }
}

resource "aws_codedeploy_deployment_group" "strapi_cd_deployment_group" {
  app_name              = aws_codedeploy_app.strapi_codedeploy.name
  deployment_group_name = "strapi-cd-deployment-group-balaji"
  service_role_arn      = "arn:aws:iam::607700977843:role/codedeploy-role-balaji"

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  ecs_service {
    cluster_name = aws_ecs_cluster.strapi_cluster.name
    service_name = aws_ecs_service.ecs_strapi_service.name
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.app_lb_http_listener.arn]
      }

      target_group {
        name = aws_lb_target_group.strapi_blue_tg.name
      }

      target_group {
        name = aws_lb_target_group.strapi_green_tg.name
      }
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }
  }

  tags = {
    Name = "strapi_cd_deployment-balaji"
  }
}
