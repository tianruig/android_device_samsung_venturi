#! /bin/bash
THISDIR=$PWD
TOPDIR="$THISDIR/../../../../"
echo $TOPDIR
find -name *.patch | while read LINE;
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
		echo "Fix the patch!"
		break;
	fi
	if [[ $(echo $RESULT | grep -c "saving rejects to file") -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		read throwaway
		break;
	fi
	echo ""
        echo ""
	cd $THISDIR
done

find -name *.apply | while read LINE;
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
	RESULT=$(git apply --whitespace=nowarn -v $PATCH 2>&1)
	echo -e "${RESULT}"
	if [[ $(echo $RESULT | grep -c error:) -gt 0 ]] ; then
		echo ""
		echo "Fail!"
		echo "Fix the patch!"
		read throwaway
		break;
	fi
	echo ""
        echo ""
	cd $THISDIR
done
