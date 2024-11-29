#!/bin/bash

# We know we're in Melbourne
AWS_REGION="ap-southeast-4"

# Get cluster and service names from terraform output
CLUSTER_NAME=$(terraform output -raw cluster_name)
SERVICE_NAME=$(terraform output -raw service_name)

# Get the task ID of the running task
TASK_ID=$(aws ecs list-tasks \
    --cluster "$CLUSTER_NAME" \
    --service-name "$SERVICE_NAME" \
    --region "$AWS_REGION" \
    --query 'taskArns[0]' \
    --output text | awk -F'/' '{print $3}')

if [ -z "$TASK_ID" ]; then
    echo "No running tasks found"
    exit 1
fi

echo "Connecting to task: $TASK_ID"
echo "Available containers:"
aws ecs describe-tasks \
    --cluster "$CLUSTER_NAME" \
    --tasks "$TASK_ID" \
    --region "$AWS_REGION" \
    --query 'tasks[0].containers[*].name' \
    --output table

read -p "Enter container name to connect to (fastapi/nginx): " CONTAINER_NAME

# Execute command in the container
aws ecs execute-command \
    --cluster "$CLUSTER_NAME" \
    --task "$TASK_ID" \
    --container "$CONTAINER_NAME" \
    --region "$AWS_REGION" \
    --command "/bin/bash" \
    --interactive