#!/bin/sh

# do some quick sanity checking...

if [ ! "$bB" ] ; then
  echo "### WARNING: the bB envionronment variable isn't set."
fi

OSTYPE=$(uname -s)
ARCH=$(uname -m)
for EXT in "" .$OSTYPE.x86 .$OSTYPE.x64 .$OSTYPE.$ARCH .$OSTYPE ; do
  echo | preprocess$EXT 2>/dev/null >&2 && break
done

echo | preprocess$EXT 2>/dev/null >&2 && break
if [ ! $? = 0 ] ; then
  echo "### ERROR: couldn't find bB binaries for $OSTYPE($ARCH). Exiting."
  exit 1
fi

#do dasm separately, because it's distributed separately
for DASMEXT in "" .$OSTYPE.x86 .$OSTYPE.x64 .$OSTYPE.$ARCH .$OSTYPE ; do
  dasm$DASMEXT 2>/dev/null >&2 
  [ $? = 1 ] && break
done
dasm$DASMEXT 2>/dev/null >&2 
if [ ! $? = 1 ] ; then
  echo "### ERROR: couldn't find dasm binary for $OSTYPE($ARCH). Exiting."
  exit 1
fi

if [ "$1" = "-v" ] ; then
  #this is just a version check. pass it along to the 2600basic binary
  2600basic$EXT -v
  exit
fi
  
DV=$(dasm$DASMEXT 2>/dev/null | grep ^DASM | head -n1)
echo "Found dasm version: $DV"

echo "Starting build of $1"
preprocess$EXT<$1 | 2600basic$EXT -i "$bB" >bB.asm
#preprocess$EXT<$1 | valgrind --leak-check=yes 2600basic$EXT -i "$bB" >bB.asm
if [ "$?" -ne "0" ]
 then
  echo "Compilation failed."
  exit
fi
if [ "$2" = "-O" ]
  then
   postprocess$EXT -i "$bB" | optimize$EXT>$1.asm
  else
   postprocess$EXT -i "$bB" >$1.asm
fi
dasm$DASMEXT $1.asm -I"$bB/includes" -f3 -l$1.lst -s$1.sym -o$1.bin | bbfilter$EXT
if [ "$?" -ne "0" ]
 then
  echo "Assembly failed."
  exit
fi
echo "Build complete."
exit

