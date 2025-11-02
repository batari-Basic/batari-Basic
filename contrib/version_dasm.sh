#!/bin/sh

MASTER=1 # comment this out for downloading a proper release

if [ ! "$MASTER" ] ; then
	DASMRELEASE=2.20.14.1
	DASMSOURCE=https://github.com/dasm-assembler/dasm/archive/$DASMRELEASE.tar.gz
	exit
fi

# if we're here, then use the MASTER for distribution
rm -fr master.zip dasm-master
wget https://github.com/dasm-assembler/dasm/archive/master.zip
unzip master.zip
export DASMRELEASE=$(grep "^#define" dasm-master/src/version.h | grep  DASM_RELEASE | head -n1 | awk '{print $3}' | tr -d '"')
DASMSOURCE=dasm-$DASMRELEASE
mv dasm-master $DASMSOURCE
tar -cvzf $DASMSOURCE.tgz $DASMSOURCE
rm -fr $DASMSOURCE master.zip
export DASMSOURCE=$DASMSOURCE.tgz
mkdir dasmtmp
mv $DASMSOURCE dasmtmp/
