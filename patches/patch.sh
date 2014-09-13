#!/bin/bash
THISDIR=$PWD
TOPDIR="$THISDIR/../../../../"
echo $TOPDIR
for LINE in $(find -name *.patch)
do
	clear
	echo "------------------------------------------------------------------------"
	echo "patch = $THISDIR/$LINE"
	echo "------------------------------------------------------------------------"
	PATCH=$THISDIR/$LINE
	REPO=$(dirname ${LINE//_//})
	echo "repo = $REPO"
	cd $TOPDIR
	cd $REPO
	RESULT=$(patch -p1 < $PATCH)
	echo -e "${RESULT}"
	if [[ $(echo $RESULT | grep -c FAILED) -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		read -p "Patch Failed!" yn
		break;
	fi
	if [[ $(echo $RESULT | grep -c "saving rejects to file") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		read -p "Patch Rejected!" yn
		break;
	fi
	if [[ $(echo $RESULT | grep -c "Skip this patch") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		read -p "Patch Skipped!" yn
		break;
	fi
	echo ""
        echo ""
	cd $THISDIR
done

for LINE in $(find -name *.apply)
do
	echo "------------------------------------------------------------------------"
	echo "patch = $THISDIR/$LINE"
	echo "------------------------------------------------------------------------"
	PATCH=$THISDIR/$LINE
	REPO=$(dirname ${LINE//_//})
	echo "repo = $REPO"
	cd $TOPDIR
	cd $REPO
	RESULT=$(git apply --whitespace=nowarn -v $PATCH 2>&1)
	echo -e "${RESULT}"
	if [[ $(echo $RESULT | grep -c error:) -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		read -p "Patch Error!" yn
		break;
	fi
	echo ""
        echo ""
	cd $THISDIR
done
