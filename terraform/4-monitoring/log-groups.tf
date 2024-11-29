resource "aws_cloudwatch_log_group" "fastapi" {
  name              = "/ecs/${var.project_name}-fastapi-${var.environment}"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/ecs/${var.project_name}-nginx-${var.environment}"
  retention_in_days = 30
  tags              = var.tags
}
