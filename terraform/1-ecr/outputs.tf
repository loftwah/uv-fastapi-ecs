output "repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "The URL of the ECR repository"
}

output "repository_name" {
  value       = aws_ecr_repository.app.name
  description = "The name of the ECR repository"
}

output "repository_arn" {
  value       = aws_ecr_repository.app.arn
  description = "The ARN of the ECR repository"
}