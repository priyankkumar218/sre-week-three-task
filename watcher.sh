#!/bin/bash

# Define variables
NAMESPACE="sre"
DEPLOYMENT_NAME="swype-app"
MAX_RESTARTS=3

while true; do
  # Get pod restarts
  RESTARTS=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  # Display current restart count
  echo "Current restart count for $DEPLOYMENT_NAME: $RESTARTS"

  # Check restart limit
  if [[ $RESTARTS -gt $MAX_RESTARTS ]]; then
    echo "Pod exceeded maximum restarts ($MAX_RESTARTS). Scaling down deployment..."
    kubectl scale deployment/$DEPLOYMENT_NAME --replicas=0 -n $NAMESPACE
    break
  fi

  # Pause for 60 seconds
  sleep 60
done

echo "Monitoring stopped."