#! /bin/bash
THISDIR=$PWD
TOPDIR="$THISDIR/../../../../"
echo $TOPDIR
find -name *.patch | while read LINE;
do
	echo "patch = $THISDIR/$LINE"
	PATCH=$THISDIR/$LINE
	REPO=$(echo $LINE | cut -d "/" -f2)
        REPO="$(echo $REPO | cut -d "_" -f1)/$(echo $REPO | cut -d "_" -f2)"
	echo "repo = $REPO"
	cd $TOPDIR
	cd $REPO
	git add .
	git stash
	find -name *.orig | while read LINE; do rm $LINE; done
	find -name *.rej | while read LINE; do rm $LINE; done
	cd $THISDIR
done
