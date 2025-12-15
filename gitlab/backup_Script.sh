#!/bin/bash

# --- Configuration ---
REPO_DIR="/cnu54tw"
BRANCH="cnu54tw"
BACKUP_DIR="/var/opt/gitlab_backup"

# --- Navigate to repo directory ---
cd "$REPO_DIR" || { echo "Repo directory not found"; exit 1; }

# --- Pull latest changes for the branch ---
git fetch origin || { echo "Git fetch failed"; exit 1; }
git checkout "$BRANCH" || { echo "Git checkout failed"; exit 1; }
git pull origin "$BRANCH" || { echo "Git pull failed"; exit 1; }

# --- Create timestamped backup ---
DATE=$(date +%F_%H-%M-%S)
tar -czvf "$BACKUP_DIR/gitlab_backup_${BRANCH}_$DATE.tar.gz" .

echo "Backup completed: $BACKUP_DIR/gitlab_backup_${BRANCH}_$DATE.tar.gz"
