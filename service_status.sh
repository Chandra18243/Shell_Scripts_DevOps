#!/bin/bash

# List of services to monitor
services=("nginx" "sshd" "docker")

# Get current timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "==================================="
echo " Service Health Check Report"
echo " Timestamp: $timestamp"
echo "==================================="

# Function to check and restart service if needed
check_service() {
    local service=$1
    echo "Checking service: $service"

    if systemctl is-active --quiet "$service"; then
        echo "$service is ✅ RUNNING"
    else
        echo "$service is ❌ STOPPED"
        echo "Attempting to restart $service..."

        # Restart the service with sudo (no prompt)
        if sudo systemctl restart "$service"; then
            # Confirm restart was successful
            if systemctl is-active --quiet "$service"; then
                echo "$service has been ✅ restarted successfully."
            else
                echo "⚠️  $service restart attempted but still not running."
            fi
        else
            echo "❌ Failed to restart $service. Check logs or permissions."
        fi
    fi

    echo "-----------------------------------"
}

# Loop through each service
for svc in "${services[@]}"; do
    check_service "$svc"
done

echo "✅ Service health check completed."
