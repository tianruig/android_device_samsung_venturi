#!/tmp/busybox sh
#
# System App Mover Script for Samsung Galaxy Player 5.0 USA
#
# (c) 2011 by Teamhacksung
#

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

/tmp/busybox rm -rf /vendor
/tmp/busybox mv /system/vendor/* /vendor

/tmp/busybox mkdir -p /vendor/app
/tmp/busybox mv /system/app/* /vendor/app

exit 0
