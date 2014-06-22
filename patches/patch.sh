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
	RESULT=$(patch -p1 < $PATCH)
	echo $RESULT
	if [[ $(echo $RESULT | grep -c FAILED) -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		break;
	fi
	if [[ $(echo $RESULT | grep -c "saving rejects to file") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		break;
	fi
	cd $THISDIR
done
