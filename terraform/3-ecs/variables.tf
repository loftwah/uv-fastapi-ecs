variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container"
  default     = 80
}

variable "task_cpu" {
  type        = number
  description = "CPU units for the task (1 vCPU = 1024 units)"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "Memory for the task in MB"
  default     = 512
}

variable "service_desired_count" {
  type        = number
  description = "Desired number of tasks running in the service"
  default     = 1
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all resources"
}

variable "container_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables for the FastAPI container"
  default     = []
}

variable "ssl_certificate_arn" {
  type        = string
  description = "ARN of ACM certificate for HTTPS"
}