#! /bin/bash
THISDIR=$PWD
TOPDIR="$THISDIR/../../../../"
echo $TOPDIR
find -name *.patch | while read LINE;
do
	echo "------------------------------------------------------------------------"
	echo "patch = $THISDIR/$LINE"
	echo "------------------------------------------------------------------------"
	PATCH=$THISDIR/$LINE
	REPO=$(dirname ${LINE//_//})
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
	echo ""
        echo ""
	cd $THISDIR
done
