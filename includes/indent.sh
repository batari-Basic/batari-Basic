#!/bin/sh
# 6502/7 assembly tidying script...

if [ ! "$1" ] ; then
  echo $0 expects an assembly file as an argument.
  echo Usage: $0 file.asm > file.new.asm
  exit 1
fi

INDENTSOURCE="                                                              "
INDENTLEVEL=1

IFS=""
#read in and pull off existing formatting...
cat $1 | sed 's/^;/ ;/g' | tr '\t' ' ' | tr -s ' ' | while read RASMLINE ; do
   
   echo "$RASMLINE" | grep -iv '[;].* else' | grep -Ei "endif|else" >/dev/null
   if [ $? = 0 ] ; then
      #decrease indent before printing out this line
      INDENTLEVEL=$(($INDENTLEVEL-1))
   fi
   INDENTSPACES="$(echo $INDENTSOURCE | cut -c 1-$(($INDENTLEVEL*4)) )"
   ASMLINE=$(echo $RASMLINE | sed "s/^[a-zA-Z0-9\.]* /&$INDENTSPACES/g")
   echo $ASMLINE
   echo "$RASMLINE" | grep -iv endif | grep -iv '[;].* if' | grep -Ei " if |^if |#if |ifconst |ifnconst | else|^else" >/dev/null
   if [ $? = 0 ] ; then
      #increase indent after printing out this line
      INDENTLEVEL=$(($INDENTLEVEL+1))
   fi
done 
