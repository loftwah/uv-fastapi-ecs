output "aws_region" {
  value       = var.aws_region
  description = "The AWS region where resources are deployed"
}

output "fastapi_repository_url" {
  value       = aws_ecr_repository.fastapi.repository_url
  description = "The URL of the FastAPI ECR repository"
}

output "fastapi_repository_name" {
  value       = aws_ecr_repository.fastapi.name
  description = "The name of the FastAPI ECR repository"
}

output "nginx_repository_url" {
  value       = aws_ecr_repository.nginx.repository_url
  description = "The URL of the Nginx ECR repository"
}

output "nginx_repository_name" {
  value       = aws_ecr_repository.nginx.name
  description = "The name of the Nginx ECR repository"
}