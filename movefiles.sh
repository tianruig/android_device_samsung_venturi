#!/tmp/busybox sh
#
# Filsystem Conversion Script for Samsung Galaxy Player 5.0 USA
# 
# (c) 2011 by Teamhacksung
#

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

/tmp/busybox mv /system/app/* /system_app/

exit 0
