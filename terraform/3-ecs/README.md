# ECS Service Module

This module deploys a FastAPI application with Nginx reverse proxy on Amazon ECS using Fargate.

## Important Prerequisites

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

2. SSL Certificate in ACM:

   - Must be in the same region (ap-southeast-4)
   - Get the ARN using:

   ```bash
   aws acm describe-certificate --certificate-arn YOUR_CERT_ARN --region ap-southeast-4
   ```

3. ECR repositories with images (from 1-ecr module)

## Configuration

1. Create terraform.tfvars:

```hcl
aws_region   = "ap-southeast-4"
environment  = "dev"
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

# SSL Certificate
ssl_certificate_arn = "arn:aws:acm:ap-southeast-4:YOUR_ACCOUNT_ID:certificate/CERT_ID"

# Container Configuration
container_port         = 80
task_cpu              = 256
task_memory           = 512
service_desired_count = 1

tags = {
  Project     = "uv-fastapi-ecs"
  Environment = "dev"
  Terraform   = "true"
}
```

## Deployment

1. Initialize and apply:

```bash
terraform init
terraform apply
```

2. Monitor deployment:

```bash
./monitor.sh
```

3. Test the connection:

```bash
./connect.sh
```

## Troubleshooting

1. "No valid subnet" or VPC errors:

   - Ensure you're using current VPC/subnet IDs from network module
   - Run `terraform output` in network module to get current values

2. Certificate errors:

   - Verify certificate ARN is correct and in ap-southeast-4
   - Certificate must be ISSUED status
   - Run ACM describe command to verify

3. Container connection issues:
   - Ensure Session Manager plugin is installed
   - Check task status in monitor.sh
   - Verify IAM roles are correct

## Utility Scripts

- `monitor.sh`: Shows service status, task health, and events
- `connect.sh`: Interactive shell access to containers
