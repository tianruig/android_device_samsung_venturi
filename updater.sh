#!/tmp/busybox sh
#
# Filsystem Conversion Script for Samsung Galaxy Player 5.0 USA
# 
# (c) 2011 by Teamhacksung
#

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

# unmount everything
/tmp/busybox umount -l /system
/tmp/busybox umount -l /cache
/tmp/busybox umount -l /data
/tmp/busybox umount -l /system_app

# create directories
/tmp/busybox mount -o remount,rw /
/tmp/busybox mkdir -p /system
/tmp/busybox mkdir -p /cache
/tmp/busybox mkdir -p /data
/tmp/busybox mkdir -p /system_app

# make sure internal sdcard is mounted
if ! /tmp/busybox grep -q /emmc /proc/mounts ; then
    /tmp/busybox mkdir -p /emmc
    /tmp/busybox umount -l /dev/block/mmcblk0p17
    if ! /tmp/busybox mount -t vfat /dev/block/mmcblk0p17 /emmc ; then
        /tmp/busybox echo "Cannot mount internal sdcard."
        exit 1
    fi
fi

# remove old log
rm -rf /emmc/cyanogenmod.log

# everything is logged into /emmc/cyanogenmod.log
exec >> /emmc/cyanogenmod.log 2>&1

#
# filesystem conversion
#

# format system if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mmcblk0p13 /system ; then
    /tmp/busybox umount /system
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /system /dev/block/mmcblk0p13
fi

# format cache if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mmcblk0p15 /cache ; then
    /tmp/busybox umount /cache
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /cache /dev/block/mmcblk0p15
fi

# format data if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mmcblk0p16 /data ; then
    /tmp/busybox umount /data
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /data /dev/block/mmcblk0p16
fi

# format system_app if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mmcblk0p14 /system_app ; then
    /tmp/busybox umount /system_app
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /system_app /dev/block/mmcblk0p14
fi

# unmount everything
/tmp/busybox umount -l /system
/tmp/busybox umount -l /cache
/tmp/busybox umount -l /data
/tmp/busybox umount -l /system_app

exit 0
