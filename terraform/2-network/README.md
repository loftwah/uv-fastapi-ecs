# Network Infrastructure Module

This module sets up the core networking infrastructure required for running the FastAPI application on ECS.

## Components

- **VPC**: Custom VPC with DNS hostnames enabled
- **Subnets**:
  - 2 public subnets (for ALB and NAT Gateways)
  - 2 private subnets (for ECS tasks)
  - Multi-AZ deployment for high availability
- **NAT Gateway**: Single NAT Gateway in development (can be increased for production)
- **Internet Gateway**: For public subnet internet access
- **Route Tables**:
  - Public route table with internet gateway route
  - Private route tables with NAT gateway routes
- **VPC Endpoints**:
  - Amazon ECR API
  - Amazon ECR Docker
  - CloudWatch Logs
  - Amazon S3 Gateway

## Prerequisites

- AWS credentials configured
- Terraform >= 1.0
- AWS provider ~> 5.0

## Usage

1. Initialize Terraform:

```bash
terraform init
```

2. Review the planned changes:

```bash
terraform plan
```

3. Apply the configuration:

```bash
terraform apply
```

4. To destroy the infrastructure:

```bash
terraform destroy
```

## Variables

| Name                 | Description                         | Type         | Default                                |
| -------------------- | ----------------------------------- | ------------ | -------------------------------------- |
| aws_region           | AWS Region                          | string       | -                                      |
| environment          | Environment name (dev/staging/prod) | string       | -                                      |
| project_name         | Project name for resource naming    | string       | -                                      |
| vpc_cidr             | CIDR block for VPC                  | string       | "10.0.0.0/16"                          |
| public_subnet_cidrs  | CIDR blocks for public subnets      | list(string) | ["10.0.1.0/24", "10.0.2.0/24"]         |
| private_subnet_cidrs | CIDR blocks for private subnets     | list(string) | ["10.0.11.0/24", "10.0.12.0/24"]       |
| availability_zones   | List of availability zones to use   | list(string) | ["ap-southeast-4a", "ap-southeast-4b"] |
| tags                 | Common resource tags                | map(string)  | -                                      |

## Outputs

| Name                           | Description                                |
| ------------------------------ | ------------------------------------------ |
| vpc_id                         | ID of the created VPC                      |
| vpc_cidr                       | The CIDR block of the VPC                  |
| private_subnet_ids             | List of private subnet IDs                 |
| public_subnet_ids              | List of public subnet IDs                  |
| nat_gateway_ids                | List of NAT Gateway IDs                    |
| vpc_endpoint_s3_id             | The ID of S3 VPC endpoint                  |
| vpc_endpoint_security_group_id | The ID of the VPC endpoints security group |

## Security Considerations

- Private subnets are isolated from direct internet access
- NAT Gateway provides secure outbound internet access for private subnets
- VPC Endpoints reduce data transfer costs and increase security
- Security group controls access to VPC endpoints
- Network ACLs can be added for additional subnet-level security

## Cost Considerations

Primary cost components:

- NAT Gateway (hourly + data processing)
- VPC Endpoints (hourly)
- Data transfer costs

To reduce costs in non-production environments:

- Single NAT Gateway is used instead of one per AZ
- Careful consideration of required VPC Endpoints
- Monitoring of data transfer patterns

## Notes

- The VPC CIDR (10.0.0.0/16) provides room for future expansion
- Subnets are spread across different AZs for high availability
- NAT Gateway configuration varies by environment (single for dev, multiple for prod)
- IPv6 is not enabled by default but can be added if required

## Regional Considerations

- This module is configured for the Melbourne (ap-southeast-4) region
- Availability zones are explicitly defined rather than dynamically discovered
- VPC endpoints are region-specific and created in the specified availability zones
