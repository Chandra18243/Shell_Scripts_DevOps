#!/bin/bash

SOURCE="/var/lib/jenkins/workspace"
BACKUP_DIR="/backup/jenkins"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

echo "===================================="
echo " Jenkins Workspace Backup"
echo " Start Time : $(date)"
echo "===================================="

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/workspace_$DATE.tar.gz" "$SOURCE"

if [ $? -eq 0 ]; then
    echo "Backup Status : SUCCESS"
    echo "Backup File   : $BACKUP_DIR/workspace_$DATE.tar.gz"
else
    echo "Backup Status : FAILED"
    exit 1
fi

echo "Removing backups older than 7 days..."

find "$BACKUP_DIR" -name "workspace_*.tar.gz" -mtime +7 -exec rm -f {} \;

echo "Old backups removed."

echo "===================================="
echo " Backup Completed"
echo " End Time : $(date)"


#crontab -e:
0 2 * * * /path/to/jenkins_workspace_backup.sh >> /var/log/jenkins_backup.log 2>&1
echo "===================================="
