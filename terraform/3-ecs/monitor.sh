#!/bin/bash
set -e

AWS_REGION="ap-southeast-4"
CLUSTER_NAME=$(terraform output -raw cluster_name)
SERVICE_NAME=$(terraform output -raw service_name)

echo "Monitoring ECS service: $SERVICE_NAME"
echo "Press Ctrl+C to exit"
echo "----------------------------------------"

while true; do
    clear
    echo "Current time: $(date)"
    echo "----------------------------------------"
    
    # Show service status
    aws ecs describe-services \
        --cluster "$CLUSTER_NAME" \
        --services "$SERVICE_NAME" \
        --region "$AWS_REGION" \
        --query 'services[0].{DesiredCount:desiredCount,RunningCount:runningCount,Status:status}' \
        --output table
    
    echo "\nTasks Status:"
    # Get all running tasks and their health
    aws ecs list-tasks \
        --cluster "$CLUSTER_NAME" \
        --service-name "$SERVICE_NAME" \
        --region "$AWS_REGION" \
        --query 'taskArns[]' \
        --output text | tr '\t' '\n' | while read -r task; do
        
        if [ -n "$task" ]; then
            echo "Task: $(basename "$task")"
            aws ecs describe-tasks \
                --cluster "$CLUSTER_NAME" \
                --tasks "$task" \
                --region "$AWS_REGION" \
                --query 'tasks[0].containers[*].{Name:name,Status:lastStatus,Health:healthStatus,Reason:reason}' \
                --output table
        fi
    done

    echo "\nRecent Events:"
    aws ecs describe-services \
        --cluster "$CLUSTER_NAME" \
        --services "$SERVICE_NAME" \
        --region "$AWS_REGION" \
        --query 'services[0].events[:5]' \
        --output table

    sleep 10
done