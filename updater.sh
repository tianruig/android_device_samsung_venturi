#!/tmp/busybox sh

SYSTEM_SIZE='629145600' # 600M

warn_repartition() {
    if ! /tmp/busybox test -e /.accept_wipe ; then
        /tmp/busybox touch /.accept_wipe
        exit 9
    fi
    /tmp/busybox rm /.accept_wipe
}

format_partitions() {
    /lvm/sbin/lvm pvcreate /dev/block/mmcblk0p13 /dev/block/mmcblk0p16
    /lvm/sbin/lvm vgcreate lvpool /dev/block/mmcblk0p13 /dev/block/mmcblk0p16
    /lvm/sbin/lvm lvcreate -L ${SYSTEM_SIZE}B -n system lvpool
    /lvm/sbin/lvm lvcreate -l 100%FREE -n data lvpool
}

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:/lvm/sbin:$PATH

# unmount system and data (recovery seems to expect system to be unmounted)
    /tmp/busybox umount -l /system
    /tmp/busybox umount -l /data

    # Resize partitions
    if /tmp/busybox test -e /dev/mapper/lvpool-system ; then
    	if /tmp/busybox test `/tmp/busybox blockdev --getsize64 /dev/mapper/lvpool-system` -ls $SYSTEM_SIZE ; then
        	warn_repartition
        	/lvm/sbin/lvm lvremove -f lvpool
        	format_partitions
    	fi
     else
       	warn_repartition
       	/lvm/sbin/lvm lvremove -f lvpool
       	format_partitions
     fi
	


##########################################################################################
# Filsystem Conversion Script for Samsung Galaxy Player 5.0 USA
#
# (c) 2011 by Teamhacksung
#

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
if ! /tmp/busybox mount -t ext4 /dev/lvpool/system /system ; then
    /tmp/busybox umount /system
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /system /dev/lvpool/system
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
if ! /tmp/busybox mount -t ext4 /dev/lvpool/data /data ; then
    /tmp/busybox umount /data
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /data /dev/lvpool/data
fi

# unmount everything
/tmp/busybox umount -l /system
/tmp/busybox umount -l /cache
/tmp/busybox umount -l /data
/tmp/busybox umount -l /vendor

exit 0
