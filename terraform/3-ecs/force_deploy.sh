#!/bin/bash

AWS_REGION="ap-southeast-4"

# Get cluster and service names from terraform output
CLUSTER_NAME=$(terraform output -raw cluster_name)
SERVICE_NAME=$(terraform output -raw service_name)

echo "Forcing new deployment of service: $SERVICE_NAME in cluster: $CLUSTER_NAME"

# Force new deployment
aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE_NAME" \
    --force-new-deployment \
    --region "$AWS_REGION"

echo "Deployment started. Monitoring progress..."

# Monitor deployment
./monitor.sh