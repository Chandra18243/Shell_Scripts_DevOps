#!/bin/bash

# CONFIGURATION
VG_NAME="vg00"
SNAP_SIZE="1G"
SNAP_LVS=("lv_root" "lv_var_log_messages")

# CREATE SNAPSHOTS
for LV in "${SNAP_LVS[@]}"; do
    SNAP_NAME="${LV}_snap"
    LV_PATH="/dev/${VG_NAME}/${LV}"

    echo "Creating snapshot $SNAP_NAME of $LV..."
    lvcreate --size "$SNAP_SIZE" --snapshot --name "$SNAP_NAME" "$LV_PATH"
    
    if [ $? -eq 0 ]; then
        echo "Snapshot created: /dev/${VG_NAME}/${SNAP_NAME}"
    else
        echo "Failed to create snapshot: $SNAP_NAME"
    fi
done
