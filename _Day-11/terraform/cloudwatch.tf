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
          title = "ECS CPU Utilization (strapi-balaji)",
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name]
          ],
          stat   = "Average",
          region = "us-east-2",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title = "ECS Memory Utilization (strapi-balaji)",
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name]
          ],
          stat   = "Average",
          region = "us-east-2",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title = "Running Task Count (strapi-balaji)",
          metrics = [
            ["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name]
          ],
          stat   = "Average",
          region = "us-east-2",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title = "Network In / Out (Bytes) (strapi-balaji)",
          metrics = [
            ["ECS/ContainerInsights", "NetworkRxBytes", "ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", aws_ecs_service.ecs_strapi_service.name],
            [".", "NetworkTxBytes", ".", ".", ".", "."]
          ],
          stat   = "Sum",
          region = "us-east-2",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 12,
        width  = 12,
        height = 6,
        properties = {
          title = "ALB Target Response Time (strapi-balaji)",
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", local.alb_metric_name]
          ],
          stat   = "Average",
          region = "us-east-2",
          period = 60
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 12,
        width  = 12,
        height = 6,
        properties = {
          title = "Target Group Health Check (strapi-balaji)",
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", local.tg_metric_name, "LoadBalancer", local.alb_metric_name],
            [".", "UnHealthyHostCount", ".", ".", ".", "."]
          ],
          stat   = "Average",
          region = "us-east-2",
          period = 60
        }
      }
    ]
  })
}
