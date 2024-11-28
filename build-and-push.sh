#!/bin/bash
set -e

# Get repository details and region from Terraform outputs
cd terraform/1-ecr
AWS_REGION=$(terraform output -raw aws_region)
FASTAPI_REPO_URL=$(terraform output -raw fastapi_repository_url)
NGINX_REPO_URL=$(terraform output -raw nginx_repository_url)

if [ -z "$FASTAPI_REPO_URL" ] || [ -z "$NGINX_REPO_URL" ] || [ -z "$AWS_REGION" ]; then
    echo "Error: Could not get repository details from Terraform. Have you run terraform apply?"
    exit 1
fi

# Go back to project root
cd ../..

# Extract account ID from repository URL
ACCOUNT_ID=$(echo $FASTAPI_REPO_URL | cut -d. -f1)
IMAGE_TAG=$(git rev-parse --short HEAD)  # Use git commit hash as tag

echo "Building and pushing to ECR repositories in region: $AWS_REGION"

# Set up buildx
docker buildx create --use --name build --node build --driver-opt network=host

# Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build and push FastAPI image
echo "Building and pushing FastAPI image..."
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --push \
    --tag $FASTAPI_REPO_URL:$IMAGE_TAG \
    --tag $FASTAPI_REPO_URL:latest \
    --file Dockerfile \
    .

# Build and push Nginx image
echo "Building and pushing Nginx image..."
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --push \
    --tag $NGINX_REPO_URL:$IMAGE_TAG \
    --tag $NGINX_REPO_URL:latest \
    --file Dockerfile.nginx \
    .

# Clean up
docker buildx rm build

echo "Successfully built and pushed images:"
echo "FastAPI: $FASTAPI_REPO_URL:$IMAGE_TAG"
echo "Nginx: $NGINX_REPO_URL:$IMAGE_TAG"