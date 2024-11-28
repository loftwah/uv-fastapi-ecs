#!/bin/bash
set -e

# Check if region provided
if [ -z "$1" ]; then
    echo "Usage: $0 <aws-region>"
    exit 1
fi

AWS_REGION=$1

# Get repository details from Terraform outputs
cd terraform/1-ecr
REPO_URL=$(terraform output -raw repository_url)
REPO_NAME=$(terraform output -raw repository_name)

if [ -z "$REPO_URL" ] || [ -z "$REPO_NAME" ]; then
    echo "Error: Could not get repository details from Terraform. Have you run terraform apply?"
    exit 1
fi

cd ../..

# Extract account ID from repository URL
ACCOUNT_ID=$(echo $REPO_URL | cut -d. -f1)
IMAGE_TAG=$(git rev-parse --short HEAD)  # Use git commit hash as tag

echo "Building and pushing to ECR repository: $REPO_NAME"
echo "Repository URL: $REPO_URL"

# Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin $REPO_URL

# Build image
echo "Building Docker image..."
docker build -t $REPO_NAME:$IMAGE_TAG .
docker tag $REPO_NAME:$IMAGE_TAG $REPO_URL:$IMAGE_TAG
docker tag $REPO_NAME:$IMAGE_TAG $REPO_URL:latest

# Push to ECR
echo "Pushing to ECR..."
docker push $REPO_URL:$IMAGE_TAG
docker push $REPO_URL:latest

echo "Successfully built and pushed image: $REPO_URL:$IMAGE_TAG"