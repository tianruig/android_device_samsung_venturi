#!/tmp/busybox sh
#
# LVM Update Script for the Galaxy Player 5
#
# (c) 2013 Meticulus
#
SYSTEM_SIZE='629145600' # 600M

warn_repartition() {
    if ! /tmp/busybox test -e /.accept_wipe ; then
        /tmp/busybox touch /.accept_wipe
#        exit 9
    fi
    /tmp/busybox rm /.accept_wipe
}

format_partitions() {
    /lvm/sbin/lvm pvcreate /dev/block/mmcblk0p13 /dev/block/mmcblk0p14 /dev/block/mmcblk0p16
    /lvm/sbin/lvm vgcreate lvpool /dev/block/mmcblk0p13 /dev/block/mmcblk0p16
    /lvm/sbin/lvm lvcreate -L ${SYSTEM_SIZE}B -n system lvpool
    /lvm/sbin/lvm lvcreate -l 100%FREE -n data lvpool
    #format data (system will be formatted by later)
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /data /dev/lvpool/data
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
rm -rf /emmc/recovery.log

# everything is logged into /emmc/recovery.log
exec >> /emmc/recovery.log 2>&1
exit 0
