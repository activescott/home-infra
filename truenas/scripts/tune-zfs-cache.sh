#!/bin/sh

# Thanks to dirtyfreebooter at https://www.truenas.com/community/threads/scale-using-only-50-of-ram-for-zfs-by-default.95247/#post-764691

#ARC_PCT="90"
#ARC_BYTES=$(grep '^MemTotal' /proc/meminfo | awk -v pct=${ARC_PCT} '{printf "%d", $2 * 1024 * (pct / 100.0)}')
#echo ${ARC_BYTES} > /sys/module/zfs/parameters/zfs_arc_max

#SYS_FREE_BYTES=$((8*1024*1024*1024))
#echo ${SYS_FREE_BYTES} > /sys/module/zfs/parameters/zfs_arc_sys_free


ARC_MAX_PCT="30"
ARC_MAX_BYTES=$(grep '^MemTotal' /proc/meminfo | awk -v pct=${ARC_MAX_PCT} '{printf "%d", $2 * 1024 * (pct / 100.0)}')
echo "Setting zfs_arc_max to ${ARC_MAX_BYTES} (${ARC_MAX_PCT}% of memory; $((ARC_MAX_BYTES / 1024 / 1024 / 1024)) GB)"

echo "/sys/module/zfs/parameters/zfs_arc_max before: $(cat /sys/module/zfs/parameters/zfs_arc_max)"

echo ${ARC_MAX_BYTES} > /sys/module/zfs/parameters/zfs_arc_max

if [ $? -ne 0 ]; then
    echo "Failed to set zfs_arc_max. You may need to run this script as root."
    exit 1
fi

echo "/sys/module/zfs/parameters/zfs_arc_max after: $(cat /sys/module/zfs/parameters/zfs_arc_max)"