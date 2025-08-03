#!/bin/bash

VG_NAME="vg00"
SNAP_LVS=("lv_root" "lv_var_log_messages")

for LV in "${SNAP_LVS[@]}"; do
    SNAP_NAME="${LV}_snap"
    SNAP_PATH="/dev/${VG_NAME}/${SNAP_NAME}"
    ORIG_PATH="/dev/${VG_NAME}/${LV}"

    echo "Reverting snapshot $SNAP_NAME to $LV..."

    # Merge snapshot back to original LV
    lvconvert --merge "$SNAP_PATH"
    if [ $? -ne 0 ]; then
        echo "Failed to merge snapshot $SNAP_NAME"
        continue
    fi

    # Reactivate original LV
    lvchange -ay "$ORIG_PATH"
    if [ $? -eq 0 ]; then
        echo "Successfully reverted $LV from $SNAP_NAME"
    else
        echo "Failed to reactivate $ORIG_PATH"
    fi
done

echo "Reversion process complete."

# Reminder:
echo "Note: You may need to reboot if these volumes are in use (e.g. root filesystem)."
