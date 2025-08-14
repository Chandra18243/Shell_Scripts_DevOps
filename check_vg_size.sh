#!/bin/bash

# Get VG size in GB (integer part)
vg_size=$(vgs --no-headings --units g --nosuffix | grep vg00 | awk '{print int($5)}')

# Get hostname
hostname=$(cat /etc/hostname)

if [ "$vg_size" -lt 20 ]; then
  echo "vg00 is less than 20GB on $hostname" | mail -s "ALERT: vg00 size low on $hostname" chandra_mail.ice.int
fi
