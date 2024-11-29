resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "${var.project_name}-dashboard-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x = 0
        y = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, "ServiceName", var.service_name],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.cluster_name, "ServiceName", var.service_name]
          ]
          title = "ECS Cluster Metrics"
        }
      },
      {
        type = "metric"
        x = 0
        y = 6
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Logs", "IncomingLogEvents", "LogGroupName", "/ecs/${var.project_name}-fastapi-${var.environment}"],
            ["AWS/Logs", "IncomingLogEvents", "LogGroupName", "/ecs/${var.project_name}-nginx-${var.environment}"]
          ]
          title = "Application Logs"
        }
      }
    ]
  })
}
