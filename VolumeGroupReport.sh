#!/bin/bash

SERVER_LIST="/tmp/servers.lst"
CSV_REPORT="vg_size_report.csv"
VG_NAME="vg01"
THRESHOLD_GB=20

# Initialize CSV
echo "server_name,vg_name,vgsize(GB)" > "$CSV_REPORT"

# Loop through each server
while read -r SERVER; do
    echo "Checking $SERVER..."
    
    VG_SIZE=$(ssh -o BatchMode=yes -o ConnectTimeout=5 sysappl@"$SERVER" "sudo vgs --noheadings -o vg_name,vg_size | grep $VG_NAME" 2>/dev/null)

    if [[ -n "$VG_SIZE" ]]; then
        VG_SIZE_ONLY=$(echo "$VG_SIZE" | awk '{print $2}' | tr -d 'gG')  # Extract size and remove 'g'
        VG_SIZE_INT=${VG_SIZE_ONLY%.*}  # Remove decimal for comparison

        if (( VG_SIZE_INT < THRESHOLD_GB )); then
            echo "$SERVER,$VG_NAME,${VG_SIZE_ONLY}G" >> "$CSV_REPORT"
        fi
    else
        echo "$SERVER - VG $VG_NAME not found or unreachable"
    fi
done < "$SERVER_LIST"

echo "Report generated: $CSV_REPORT"
