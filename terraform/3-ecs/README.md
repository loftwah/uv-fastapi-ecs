# ECS Service Module

This module deploys a FastAPI application with Nginx reverse proxy on Amazon ECS using Fargate.

## Architecture

- FastAPI application container
- Nginx reverse proxy container
- Application Load Balancer with HTTPS termination
- ECS Fargate service in private subnets
- Auto-scaling capabilities

## Prerequisites

- ECR repositories with images (from 1-ecr module)
- VPC with public/private subnets (from 2-network module)
- ACM certificate for HTTPS

## Components

- ALB with HTTP to HTTPS redirection
- ECS Cluster with Container Insights
- Fargate Service with blue/green deployment support
- IAM roles for task execution and runtime
- CloudWatch log groups for containers
- Security groups for ALB and tasks

## Usage

1. Configure required variables:

```hcl
# terraform.tfvars
aws_region   = "ap-southeast-4"
environment  = "dev"
project_name = "uv-fastapi-ecs"

# Network configuration
vpc_id             = "vpc-xxx"
private_subnet_ids = ["subnet-xxx", "subnet-yyy"]
public_subnet_ids  = ["subnet-aaa", "subnet-bbb"]

# SSL Certificate
ssl_certificate_arn = "arn:aws:acm:ap-southeast-4:123456789012:certificate/xxx"
```

2. Initialize and apply:

```bash
terraform init
terraform apply
```

## Testing the Deployment

```bash
# Get your ALB DNS name from terraform output
ALB_DNS=$(terraform output -raw alb_dns_name)

# Test HTTP to HTTPS redirect (shows the redirect happening)
curl -v http://$ALB_DNS

# Test HTTP to HTTPS redirect (follows the redirect automatically)
curl -L http://$ALB_DNS

# Test HTTPS endpoint directly (with certificate bypass)
curl -k https://$ALB_DNS

# Test HTTPS endpoint with verbose output for debugging
curl -k -v https://$ALB_DNS
```

## Monitoring

Monitor the service using:

```bash
# View service events
./monitor.sh

# Check container logs
aws logs get-log-events \
    --log-group-name "/ecs/uv-fastapi-ecs-fastapi-dev" \
    --log-stream-name $(aws logs describe-log-streams --log-group-name "/ecs/uv-fastapi-ecs-fastapi-dev" --order-by LastEventTime --descending --limit 1 --query 'logStreams[0].logStreamName' --output text) \
    --region ap-southeast-4

# Connect to containers
./connect.sh
```

## Common Issues

1. 301 Redirect:

   - Expected when accessing HTTP endpoint (port 80)
   - ALB automatically redirects to HTTPS (port 443)
   - Use curl with `-L` flag to follow redirects

2. SSL Certificate Warning:

   - Expected when using ALB's DNS name
   - Use `-k` with curl to skip verification
   - Add proper DNS record when using custom domain

3. Task Deployment Issues:
   - Check ECS events with `monitor.sh`
   - Verify ECR image access
   - Check CloudWatch logs
