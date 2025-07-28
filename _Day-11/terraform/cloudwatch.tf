#Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "ecs_strapi_LG" {
  name              = "/ecs/strapi-balaji"
  retention_in_days = 1
}


#CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "strapi-high-cpu-balaji"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.ecs_strapi_service.name
  }

  alarm_description = "This alarm monitors high CPU for the Strapi ECS service"
}
resource "aws_cloudwatch_metric_alarm" "strapi_high_memory" {
  alarm_name          = "strapi-high-memory-utilization-balaji"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.ecs_strapi_service.name
  }

  alarm_description = "Alarm when Strapi ECS memory usage exceeds 80%."
}


#CloudWatch dashboard
resource "aws_cloudwatch_dashboard" "strapi_dashboard" {
  dashboard_name = "strapi-dashboard-balaji"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title = "Strapi ECS CPU Usage"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name]
          ]
          period = 60
          stat   = "Average"
          region = var.aws_region
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title = "Strapi Memory Usage"
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name]
          ]
          period = 60
          stat   = "Average"
          region = var.aws_region
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title = "Running Task Count"
          metrics = [
            ["AWS/ECS", "RunningTaskCount", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name]
          ]
          period = 60
          stat   = "Average"
          region = var.aws_region
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title = "Network In/Out"
          metrics = [
            ["AWS/ECS", "NetworkBytesIn", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name],
            ["AWS/ECS", "NetworkBytesOut", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name]
          ]
          period = 60
          stat   = "Sum"
          region = var.aws_region
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 12,
        width  = 12,
        height = 6,
        properties = {
          title = "Strapi Latency (ALB)"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.app_lb.name, "TargetGroup", aws_lb_target_group.strapi_tg.name]
          ]
          period = 60
          stat   = "Average"
          region = var.aws_region
        }
      },
      {
        "type" : "metric",
        "x" : 0,
        "y" : 18,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "Unhealthy ECS Tasks (via ALB)",
          "metrics" : [
            ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", aws_lb_target_group.strapi_tg.name, "LoadBalancer", aws_lb.app_lb.name]
          ],
          "period" : 60,
          "stat" : "Average",
          "region" : var.aws_region
        }
      }
    ]
  })
}
