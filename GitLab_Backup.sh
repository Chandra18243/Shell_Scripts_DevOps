#!/bin/bash

# CONFIGURATION
GIT_USER="GitLab_Bakcup_user"
REPO_SSH_URL="git@example.com:namespace/devops-repo.git"   # ← Replace with actual SSH URL
WORK_DIR="/tmp/gitlab_backup"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="DevOps_Repo_${DATE}.tar.gz"
S3_BUCKET="s3://your-bucket-name/devops-backups/"          # ← Replace with your bucket name/path

# Ensure AWS CLI is configured (check credentials/profile)
AWS_PROFILE="default"  # or your custom profile name if used

# Create working directory
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || exit 1

# Clean previous clone if exists
rm -rf repo

echo "[+] Cloning the repository..."
git clone "$REPO_SSH_URL" repo || { echo "❌ Git clone failed"; exit 2; }

echo "[+] Archiving the repository..."
tar -czf "$BACKUP_FILE" repo || { echo "❌ Tar operation failed"; exit 3; }

echo "[+] Uploading to S3 bucket: $S3_BUCKET"
aws s3 cp "$BACKUP_FILE" "$S3_BUCKET" --profile "$AWS_PROFILE" || { echo "❌ S3 upload failed"; exit 4; }

echo "[✔] Backup completed and uploaded: $S3_BUCKET$BACKUP_FILE"
