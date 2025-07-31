variable "aws_region" {
  type    = string
  default = "us-east-2"
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable "database_client" {
  type    = string
  default = "postgres" #Default is "postgres"
}

variable "database_port" {
  type    = string
  default = "5432"
}

variable "database_name" {
  type    = string
  default = "strapi"
}

variable "database_username" {
  type    = string
  default = "strapi" #Enter Your DB User - Default is "strapi"
}

variable "database_password" {
  type    = string
  default = "password" #Enter Your DB Password - Default is "password"
}

variable "image_tag" {
  description = "Docker image tag" #Will be passed by Github Actions
  type        = string
  default     = "strapi-v19"
}

variable "ecr_repo" {
  description = "ECR REPO NAME"
  type        = string
  default     = "607700977843.dkr.ecr.us-east-2.amazonaws.com/kbalaji2212/projects"
}

variable "snapshot_name" {
  description = "RDS Snapshot NAME"
  type        = string
  default     = "strapi-postgres-balaji-snapshot"
}

locals {
  database_host   = aws_db_instance.strapi_rds_postgresql.address
  alb_metric_name = replace(aws_lb.app_lb.arn_suffix, "loadbalancer/", "")
}

output "app_lb_endpoint" {
  value = aws_lb.app_lb.dns_name
}
output "strapi_TD_arn" {
  value = aws_ecs_task_definition.strapi_TD.arn
}
