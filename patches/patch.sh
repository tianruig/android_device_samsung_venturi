#!/bin/bash
THISDIR=$PWD
UNATTENDED=${1}
TOPDIR="$THISDIR/../../../../"
echo $TOPDIR
for LINE in $(find -name *.patch)
do
	if [[ $UNATTENDED -ne 1 ]]; then
		clear
	fi
	echo "------------------------------------------------------------------------"
	echo "patch = $THISDIR/$LINE"
	echo "------------------------------------------------------------------------"
	PATCH=$THISDIR/$LINE
	REPO=$(dirname $LINE)
	echo "repo = $REPO"
	cd $TOPDIR
	cd $REPO
	RESULT=$(patch -p1 --no-backup-if-mismatch < $PATCH)
	echo -e "${RESULT}"
	if [[ $(echo $RESULT | grep -c FAILED) -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		if [[ $UNATTENDED -eq 1 ]]; then
			exit 9
		else
			read -p "Patch Failed!" yn
			break;
		fi
	fi
	if [[ $(echo $RESULT | grep -c "saving rejects to file") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		if [[ $UNATTENDED -eq 1 ]]; then
			exit 9
		else
			read -p "Patch Rejects!" yn
			break;
		fi
	fi
	if [[ $(echo $RESULT | grep -c "Skip this patch") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		if [[ $UNATTENDED -eq 1 ]]; then
			exit 9
		else
			read -p "Patch Skipped!" yn
			break;
		fi
	fi
	cd $THISDIR
done

for LINE in $(find -name *.apply)
do
	if [[ $UNATTENDED -ne 1 ]]; then
		clear
	fi
	echo "------------------------------------------------------------------------"
	echo "patch = $THISDIR/$LINE"
	echo "------------------------------------------------------------------------"
	PATCH=$THISDIR/$LINE
	REPO=$(dirname $LINE)
	echo "repo = $REPO"
	cd $TOPDIR
	cd $REPO
	RESULT=$(git apply --whitespace=nowarn -v $PATCH 2>&1)
	echo -e "${RESULT}"
	if [[ $(echo $RESULT | grep -c error:) -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		if [[ $UNATTENDED -eq 1 ]]; then
			exit 9
		else
			read -p "Patch Error!" yn
			break;
		fi
	fi
	cd $THISDIR
done
