#!/tmp/busybox sh
#
# Recovery Check Script for the Galaxy Player 5
#
# (c) 2014 Meticulus
#
# This script checks to see if recovery update is needed due to SELinux setperm
# implemented in 4.3. If we are below that version then we need an update. so
# we flash the kernel and reboot back to recovery.

if [[ -e /cache/recovery/recoveryupgraded ]]; then
    rm /cache/recovery/recoveryupgraded
    exit 0
fi

VERSION=""
THISZIP=""
NEEDUPGRADE=0
NEEDRECOVERYPRECOMMAND=0
NEEDZIPPATHCORRECTION=0
NEEDFORMATCACHE=0

# Stock gingerbread didn't have much in the default.prop but new version
# of android do, check here first then use getprop.
if [[ "$VERSION" == "" ]]; then
    while read LINE
    do
	    PROP=$(echo $LINE | cut -d '=' -f1)
	    if [[ "$PROP" == "ro.build.version.release" ]]; then
		VERSION=$(echo $LINE | cut -d '=' -f2)
		break
	    fi
    done < /default.prop
fi
if [[ "$VERSION" == "" ]]; then
    VERSION=$(getprop ro.build.version.release)
fi

if [[ "$VERSION" == "" ]]; then
    echo "Unable to find android version!" >> /tmp/recovery.log
    NEEDUPGRADE=1
fi

MAJOR=$(echo "$VERSION" | cut -d '.' -f1)
MINOR=$(echo "$VERSION" | cut -d '.' -f2)

echo "Android version = $VERSION" >> /tmp/recovery.log
if [[ $MAJOR -lt 4 ]]; then

    NEEDUPGRADE=1

    NEEDZIPPATHCORRECTION=1
  
    NEEDFORMATCACHE=1

fi 
if [[ $MAJOR -eq 4 ]]; then
    if [[ $MINOR -lt 3 ]]; then

    	NEEDUPGRADE=1

        NEEDRECOVERYPRECOMMAND=1

        NEEDZIPPATHCORRECTION=1

    fi
fi

if [[ $MAJOR -eq 4 ]]; then
    if [[ $MINOR -lt 4 ]]; then

        NEEDRECOVERYPRECOMMAND=1

    fi
fi

# Find the path of the zip we are flashing...
while read LINE
do
    PROP=$(echo $LINE | cut -d ':' -f1)
    if [[ "$PROP" == "-- Installing" ]]; then
        THISZIP=$(echo $(echo $LINE | cut -d ':' -f2) | tr -d ' ')

	# For Gingerbread, paths need to be switched for new CWM paths.
	if [[ $NEEDZIPPATHCORRECTION -eq 1 ]]; then
            echo "$THISZIP" > /tmp/path.txt
            sed 's/\/sdcard/\external_sd/g' /tmp/path.txt > /tmp/path2.txt
            sed 's/\/emmc/\/sdcard/g' /tmp/path2.txt > /tmp/path3.txt
            THISZIP=$(cat /tmp/path3.txt)
	fi
	# don't break here, we want the last one
    fi
done < /tmp/recovery.log

if [[ $NEEDUPGRADE -eq 1 ]]; then
    if [[ -e /tmp/recoveryupdate.img ]]; then

        # Flash the kernel with update recovery in it.
	/tmp/busybox dd if=/tmp/recoveryupdate.img of=/dev/block/mmcblk0p11

        if [[ $NEEDFORMATCACHE -eq 1 ]]; then
            /tmp/busybox umount /cache
            /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 /dev/block/mmcblk0p15 /cache
        fi
        /tmp/busybox mount /cache

        # create automatic installation recovery script.
        mkdir -p /cache/recovery
	echo "Updating Recovery" >> /tmp/recovery.log
        echo "run_program(\"/sbin/busybox\", \"touch\", \"/tmp/noreboot\");" > /cache/recovery/extendedcommand
        echo "format(\"/cache\");" >> /cache/recovery/extendedcommand
        echo "install_zip(\"$THISZIP\");" >> /cache/recovery/extendedcommand
        
        # Marker so we can skip this on first reboot to new recovery
        touch /cache/recovery/recoveryupgraded

	sleep 10
	cp /tmp/recovery.log /cache/recovery
	if [[ $NEEDRECOVERYPRECOMMAND -eq 1 ]]; then
		echo "1" > /cache/.startrecovery
		reboot
	else
		reboot recovery
	fi
    else
	echo "recoveryupdate.img missing?" >> /tmp/recovery.log
        cp /tmp/recovery.log /cache/recovery
	exit 9
    fi
else
   echo "Recovery update not needed" >> /tmp/recovery.log
fi
cp /tmp/recovery.log /cache/recovery
exit 0
