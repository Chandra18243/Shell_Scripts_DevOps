#!/bin/bash

REPORT="/var/opt/gitlab_backup/vg_report.csv"
HOST=$(hostname)

# If file doesn't exist, add header
if [ ! -f "$REPORT" ]; then
    echo "Hostname,VG_Name,VG_Size_GiB,VG_Free_GiB" > "$REPORT"
fi

# Append VG stats (all VGs, not just vg0)
vgs --no-headings --units g | grep -i vg00 |awk -v h="$HOST" '{print h "," $1 "," $7 "," $8}' | tr -d 'Gib' >> "$REPORT"

#crontab ti run daily mrng 5am & afternoon 2pm

# 0 5,14 * * * /us/bin/local/vg_report.sh >> /var/log/vg_report.log 2>&1
