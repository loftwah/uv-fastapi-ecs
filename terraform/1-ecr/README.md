# ECR Infrastructure

This directory contains the Terraform configuration for creating two Amazon Elastic Container Registry (ECR) repositories that will store our FastAPI and Nginx container images.

## Repositories Created

- `uv-fastapi-fastapi-{environment}`: Stores the FastAPI application images
- `uv-fastapi-nginx-{environment}`: Stores the Nginx reverse proxy images

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 1.0+)
- Docker installed and running

## Configuration

1. Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Adjust the variables in `terraform.tfvars`:

```hcl
aws_region = "ap-southeast-4"  # Melbourne region
environment = "dev"            # or "staging", "prod"
allowed_aws_account_arns = [
  "arn:aws:iam::ACCOUNT_ID:root"  # Replace with your AWS account ARN
]
tags = {
  Project     = "uv-fastapi-ecs"
  Environment = "dev"
  Terraform   = "true"
}
```

## Deployment

1. Initialize Terraform:

```bash
terraform init
```

2. Review the changes:

```bash
terraform plan
```

3. Apply the configuration:

```bash
terraform validate
terraform apply
```

## Building and Pushing Images

Once the ECR repositories are created, you can build and push images using the script in the root directory:

```bash
# From the root directory of the project
./build-and-push.sh
```

This script will:

- Read the repository URLs from Terraform outputs
- Build both FastAPI and Nginx images using buildx for multi-platform support
- Tag images with both latest and git commit hash
- Push images to their respective ECR repositories

## Outputs

The following outputs are available:

- `aws_region`: The AWS region where repositories are created
- `fastapi_repository_url`: The URL for the FastAPI repository
- `fastapi_repository_name`: The name of the FastAPI repository
- `nginx_repository_url`: The URL for the Nginx repository
- `nginx_repository_name`: The name of the Nginx repository

View the outputs using:

```bash
terraform output
```

## Cleanup

To destroy the ECR repositories:

```bash
terraform destroy
```

**Note**: This will delete all images in the repositories. Make sure you have backups if needed.
