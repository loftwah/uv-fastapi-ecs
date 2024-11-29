# Monitoring Module

This module sets up logging, monitoring, and alerting for the FastAPI application and Nginx proxy deployed on ECS.

## Prerequisites

Before applying this module, ensure you have:

1. ECS Service Details (from 3-ecs module):
   ```bash
   cd ../3-ecs
   terraform output
   ```
   Copy these values for your tfvars:
   - cluster_name
   - service_name

## Configuration

1. Create terraform.tfvars:

```hcl
# AWS Region
aws_region = "ap-southeast-4"

# Environment name
environment = "dev"

# Project name for tagging and naming resources
project_name = "uv-fastapi-ecs"

# From terraform/3-ecs/terraform output
cluster_name = "uv-fastapi-ecs-cluster-dev"
service_name = "uv-fastapi-ecs-service-dev"

# Email address for alert notifications
alert_email = "your-email@example.com"

# Tags
tags = {
  Owner       = "your-name"
  Environment = "dev"
  Terraform   = "true"
}
```

## Deployment

Initialize and apply:

```bash
terraform init
terraform apply
```

## Features

- CloudWatch Alarms for high CPU usage (triggers at 80%)
- CloudWatch Dashboard for ECS metrics and logs
- SNS Topic for email alerts
- Integration with existing ECS log groups

## Accessing Dashboards

After deployment, get the dashboard URL:

```bash
terraform output dashboard_url
```
