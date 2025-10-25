#!/bin/sh
# 2600basic compilation script (wasm)

# do some quick sanity checking...
if [ ! "$bB" ] ; then
  echo "### WARNING: the bB envionronment variable isn't set."
fi

wasmtime --version 2>&1 > /dev/null
if [ ! $? = 0 ] ; then
    echo "### WARNING: wasmtime isn't in your PATH."
    echo "    You can install it as follows:"
    echo "      macOS/Linux: curl https://wasmtime.dev/install.sh -sSf | bash"
    echo "    See https://wasmtime.dev for other installation options."
    exit 1
fi

echo "  basic version:  "$(wasmtime $bB/2600basic.wasm -v 2>/dev/null)

echo "  "dasm version:"  " $(wasmtime $bB/dasm.wasm 2>/dev/null| head -n1)

if [ "$1" = "-v" ] ; then
  #this is just a version check. we already displayed the version earlier,
  #so just exit.
  exit
fi

if [ ! -f "$1" ]; then
    echo "### ERROR: Source file \"$1\" not found."
    exit 2
fi

echo

echo "Starting build of $1"
 wasmtime run --dir=. --dir="$bB" "$bB/preprocess.wasm" <"$1" | \
 wasmtime run --dir=. --dir="$bB"  "$bB/2600basic.wasm" -i "$bB" > bB.asm

if [ "$?" -ne "0" ]
 then
  echo "Compilation failed."
  exit
fi

if [ "$2" = "-O" ]
  then
   wasmtime run --dir=. --dir="$bB" "$bB/postprocess.wasm" -i "$bB" | wasmtime run --dir=. --dir="$bB"  "$bB/optimize.wasm" > "$1.asm"
  else
   wasmtime run --dir=. --dir="$bB" "$bB/postprocess.wasm" -i "$bB" > "$1.asm"
fi

wasmtime run --dir=. --dir="$bB" "$bB/dasm.wasm" "$1.asm" -I"$bB/includes" -f3 -l"$1.list.txt" -p20 -s"$1.symbol.txt" -o"$1.bin" | wasmtime "$bB/bbfilter.wasm"

wasmtime run --dir="$PWD" --dir=. --dir="$bB" "$bB"/relocateBB.wasm "$1.bin" 

exit 0
