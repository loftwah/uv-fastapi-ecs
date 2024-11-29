#!/bin/bash
set -e

AWS_REGION="ap-southeast-4"
CLUSTER_NAME=$(terraform output -raw cluster_name)
SERVICE_NAME=$(terraform output -raw service_name)

echo "Finding running task..."
TASK_ID=$(aws ecs list-tasks \
    --cluster "$CLUSTER_NAME" \
    --service-name "$SERVICE_NAME" \
    --desired-status RUNNING \
    --region "$AWS_REGION" \
    --query 'taskArns[0]' \
    --output text | awk -F'/' '{print $3}')

if [ -z "$TASK_ID" ] || [ "$TASK_ID" == "None" ]; then
    echo "No running tasks found"
    exit 1
fi

echo "Task found: $TASK_ID"
echo "Available containers:"
aws ecs describe-tasks \
    --cluster "$CLUSTER_NAME" \
    --tasks "$TASK_ID" \
    --region "$AWS_REGION" \
    --query 'tasks[0].containers[*].{Name:name,Status:lastStatus}' \
    --output table

read -p "Enter container name to connect to (fastapi/nginx): " CONTAINER_NAME

echo "Connecting to $CONTAINER_NAME container..."
aws ecs execute-command \
    --cluster "$CLUSTER_NAME" \
    --task "$TASK_ID" \
    --container "$CONTAINER_NAME" \
    --region "$AWS_REGION" \
    --command "/bin/bash" \
    --interactive