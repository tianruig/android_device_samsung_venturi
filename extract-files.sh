#!/bin/sh

VENDOR=samsung
DEVICE=venturi
BASE=../../../vendor/$VENDOR/$DEVICE/proprietary

rm -rf ../../../vendor/$VENDOR/$DEVICE/*
mkdir -p $BASE

if [ -f "$1" ]; then
	rm -rf tmp
	mkdir tmp
	unzip -q "$1" -d tmp
	if [ $? != 0 ]; then
		echo "$1 is not a valid zip file. Bye."
		exit 1
	fi
	echo "$1 successfully unzipped. Copying files..."
	ZIP="true"
else
	echo "Pulling files..."
	unset ZIP
fi


for FILE in `cat proprietary-files.txt | grep -v ^# | grep -v ^$`; do
	DIR=`dirname $FILE`
	if [ ! -d $BASE/$DIR ]; then
		mkdir -p $BASE/$DIR
	fi
	if [ "$ZIP" ]; then
		cp tmp/system/$FILE $BASE/$FILE
	else
		adb pull /system/$FILE $BASE/$FILE
	fi
done

if [ "$ZIP" ]; then rm -rf tmp ; fi

./setup-makefiles.sh
