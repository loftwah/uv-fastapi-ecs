variable "aws_region" {
  type        = string
  description = "AWS region to deploy to"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "uv-fastapi"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "allowed_aws_account_arns" {
  type        = list(string)
  description = "List of AWS account ARNs allowed to pull images"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}