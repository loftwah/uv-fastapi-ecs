# Log groups are created by ECS service
output "log_group_fastapi" {
  value       = "/ecs/${var.project_name}-fastapi-${var.environment}"
  description = "Log group for FastAPI"
}

output "log_group_nginx" {
  value       = "/ecs/${var.project_name}-nginx-${var.environment}"
  description = "Log group for Nginx"
}

output "dashboard_url" {
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.ecs_dashboard.dashboard_name}"
  description = "CloudWatch Dashboard URL"
}