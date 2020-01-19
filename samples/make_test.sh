#!/bin/sh
echo "batari Basic build test, using $(which 2600basic.sh)"
echo "    [$(2600basic.sh -v)]"
make all >/dev/null 2>&1
for FILE in $(cat sizes.ref | awk '{print $1}') ; do	
	RECORDEDSIZE=$(grep "$FILE" sizes.ref | awk '{print $2}')
	REALSIZE=$(du -sb "$FILE" | awk '{print $1}')
	if [ "$RECORDEDSIZE" = "$REALSIZE" ] ; then
		echo "    "PASS: $FILE
	else
		echo "    "FAIL: $FILE
	fi
done
make clean >/dev/null 2>&1
