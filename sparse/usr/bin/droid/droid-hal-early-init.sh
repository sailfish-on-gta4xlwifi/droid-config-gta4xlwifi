#!/bin/bash
# Verbose script for mounting dynamic partitions
# Credit to: https://github.com/SailfishOS-vayu/droid-config-vayu/blob/master/sparse/usr/bin/droid/droid-hal-early-init.sh
# Edit partitions according to your fixup-mountpoints, fstab and dynamic partitions layout
super_part=/dev/sda25

# Partition Metadata
metadata_part=/dev/sda24
 
dmesg_info() {
    echo "[mount-partitions.sh] $@" > /dev/kmsg
}
 
dmesg_info "Map dynamic partitions"
dmsetup create --concise "$(/usr/bin/parse-android-dynparts $super_part)"
 
dmesg_info "Dynamic partitions: $(ls /dev/mapper/dynpart-*)"
 
dmesg_info "Mount dynamic partitions"
mkdir -p /system_root /system_ext /vendor /odm2 /product /mnt /metadata
 
dmesg_info "$(mount -v -o ro /dev/mapper/dynpart-system  /system_root)"
dmesg_info "$(mount --bind /system_root/system /system)"
dmesg_info "$(mount -v -o ro /dev/mapper/dynpart-system_ext /system_ext)"
dmesg_info "$(mount -v -o ro /dev/mapper/dynpart-vendor  /vendor)""
dmesg_info "$(mount -v -o ro /dev/mapper/dynpart-odm   /odm2)"
dmesg_info "$(mount -v -o ro /dev/mapper/dynpart-product /product)"
 
dmesg_info "Mount metadata*"
dmesg_info "$(mount -v $metadata_part   /metadata)"
 
# comment out when everything works
dmesg_info "$(findmnt)"

