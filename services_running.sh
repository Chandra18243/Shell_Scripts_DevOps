#!/bin/bash

# Output file
REPORT="/var/log/services_running.txt"

# If file doesn't exist, add header
if [ ! -f "$REPORT" ]; then
    echo "Service_Name" > "$REPORT"
fi

# List running services, strip suffix, and overwrite file
systemctl list-units --type=service --state=running --no-legend | awk '{print $1}' | cut -d '.' -f1 
