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
/tmp/busybox umount -l /vendor

# create directories
/tmp/busybox mount -o remount,rw /
/tmp/busybox mkdir -p /system
/tmp/busybox mkdir -p /cache
/tmp/busybox mkdir -p /data
/tmp/busybox mkdir -p /vendor

check_mount() {
    local MOUNT_POINT=`/tmp/busybox readlink $1`
    if ! /tmp/busybox test -n "$MOUNT_POINT" ; then
        # readlink does not work on older recoveries for some reason
        # doesn't matter since the path is already correct in that case
        /tmp/busybox echo "Using non-readlink mount point $1"
        MOUNT_POINT=$1
    fi
    if ! /tmp/busybox grep -q $MOUNT_POINT /proc/mounts ; then
        /tmp/busybox mkdir -p $MOUNT_POINT
        /tmp/busybox umount -l $2
        if ! /tmp/busybox mount -t $3 $2 $MOUNT_POINT ; then
            /tmp/busybox echo "Cannot mount $1 ($MOUNT_POINT)."
        exit 1
    fi
fi
}

set_log() {
    rm -rf $1
    exec >> $1 2>&1
}

fix_package_location() {
    local PACKAGE_LOCATION=$1
    # Remove leading /mnt
    PACKAGE_LOCATION=${PACKAGE_LOCATION#/mnt}
    # Convert to modern sdcard path
    PACKAGE_LOCATION=`echo $PACKAGE_LOCATION | /tmp/busybox sed -e "s|^/sdcard|/storage/sdcard0|"`
    PACKAGE_LOCATION=`echo $PACKAGE_LOCATION | /tmp/busybox sed -e "s|^/emmc|/storage/sdcard1|"`
    echo $PACKAGE_LOCATION
}

# make sure sdcard is mounted
check_mount /mnt/sdcard mmcblk0p17 vfat

# everything is logged into /mnt/sdcard/cyanogenmod_bml.log
set_log /mnt/sdcard/cyanogenmod.log

#
# filesystem conversion
#

# format system if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mmcblk0p13 /system ; then
    /tmp/busybox umount /system
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /system /dev/block/mmcblk0p13
fi

# we always need to format vendor.
# if ! /tmp/busybox mount -t ext4 /dev/block/mmcblk0p14 /vendor ; then
    /tmp/busybox umount /vendor
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /vendor /dev/block/mmcblk0p14
# fi

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

# unmount everything
/tmp/busybox umount -l /system
/tmp/busybox umount -l /cache
/tmp/busybox umount -l /data
/tmp/busybox umount -l /vendor

exit 0
