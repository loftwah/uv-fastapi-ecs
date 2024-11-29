output "log_group_fastapi" {
  value       = aws_cloudwatch_log_group.fastapi.name
  description = "Log group for FastAPI"
}

output "log_group_nginx" {
  value       = aws_cloudwatch_log_group.nginx.name
  description = "Log group for Nginx"
}

output "dashboard_url" {
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.ecs_dashboard.dashboard_name}"
  description = "CloudWatch Dashboard URL"
}
