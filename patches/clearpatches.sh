#! /bin/bash
THISDIR=$PWD
TOPDIR="$THISDIR/../../../../"
echo $TOPDIR
for LINE in $(ls -l | grep '^d' | awk '{ print $9 }')
do
	clear
	echo "clearing = $LINE"
  	REPO=$(echo ${LINE//_//})
	echo "repo = $TOPDIR$REPO"
	cd $TOPDIR
	cd $REPO
	git add .
	git stash
	find -name *.orig | while read LINE; do rm $LINE; done
	find -name *.rej | while read LINE; do rm $LINE; done
	git clean -f
	git stash clear
	cd $THISDIR
done
