# Monitoring Module

This module sets up logging, monitoring, and alerting for the FastAPI application and Nginx proxy deployed on ECS.

## Prerequisites

Before applying this module, ensure you have:

1. Network Infrastructure (from 2-network module):

   ```bash
   cd ../2-network
   terraform output
   ```

   Copy these values for your tfvars:

   - vpc_id
   - private_subnet_ids
   - public_subnet_ids

2. ECS Service Details (from 3-ecs module):
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
aws_region = "ap-southeast-4"
environment = "dev"
project_name = "uv-fastapi-ecs"

# Network configuration (from terraform/2-network/terraform output)
vpc_id             = "vpc-01da9ae3b1f1bd39d"     # Get from network output
private_subnet_ids = [
  "subnet-08f8c6eceab4df2be",                    # Get from network output
  "subnet-0db67a5d261155fc8"
]
public_subnet_ids  = [
  "subnet-0ed7a5fc23178a38e",                    # Get from network output
  "subnet-0ffdfe7d2eed82670"
]

# ECS configuration (from terraform/3-ecs/terraform output)
cluster_name = "uv-fastapi-ecs-cluster-dev"      # Get from ECS output
service_name = "uv-fastapi-ecs-service-dev"      # Get from ECS output

# Email for alerts
alert_email = "your-email@example.com"

tags = {
  Project     = "uv-fastapi-ecs"
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

- CloudWatch Log Groups for FastAPI and Nginx logs
- CloudWatch Alarms for high CPU usage
- CloudWatch Dashboard for ECS metrics and logs
- SNS Topic for alert notifications

## Accessing Dashboards

After deployment, get the dashboard URL:

```bash
terraform output dashboard_url
```
