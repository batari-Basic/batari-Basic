#!/bin/sh
# 2600basic compilation script (wasm)

# do some quick sanity checking...
if [ ! "$bB" ] ; then
  echo "### WARNING: the bB envionronment variable isn't set."
fi

wasmtime --version 2>&1 > /dev/null
if [ ! $? = 0 ] ; then
    if [ -r "$bB"/2600basic ] ; then
        echo "### WARNING: wasmtime is missing. Compiling with native executables."
        2600basic.native.sh $*
        exit $?
    else
        echo "### WARNING: wasmtime isn't in your PATH."
        echo "    You can install it as follows:"
        echo "      macOS/Linux: curl https://wasmtime.dev/install.sh -sSf | bash"
        echo "    See https://wasmtime.dev for other installation options."
        exit 1
    fi
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

wasmtime run --dir=. --dir="$bB" "$bB/dasm.wasm" "$1.asm" -I"$bB/includes" -f3 -l"$1.lst" -p20 -s"$1.sym" -o"$1.bin" | wasmtime "$bB/bbfilter.wasm"

if [ -f "$bB/relocateBB.wasm" ] ; then
    wasmtime run --dir="$PWD" --dir=. --dir="$bB" "$bB"/relocateBB.wasm "$1.bin" 
else
    echo "relocateBB skipped. A compatible relocateBB wasn't found."
fi

# --- Create a .elf file to flash PXE games to Chameleon Cart ---

# A highly portable function to generate a Version 4 UUID.
# It prefers the system's `uuidgen` command but falls back to a pure
# shell implementation using `/dev/urandom`, which is available on
# Linux, macOS, and BSD systems.
ouruuidgen() {
  if command -v uuidgen >/dev/null 2>&1; then
    uuidgen
    return
  fi

  # Fallback for systems without uuidgen.
  # Uses od to get 16 random bytes from /dev/urandom.
  # This is a highly portable and reliable method.
  local hex_chars
  hex_chars=$(od -N 16 -t x1 -An /dev/urandom | tr -d '[:space:]')

  # Set the version to 4 (the 13th character).
  local part1=${hex_chars:0:12}
  local part2=${hex_chars:13}
  hex_chars="${part1}4${part2}"

  # Set the variant to one of {8, 9, A, B} (the 17th character).
  local char17_val=$((16#${hex_chars:16:1})) # Get decimal value of 17th char
  local variant_val=$(( (char17_val & 3) | 8 )) # (val % 4) + 8
  local variant_char=$(printf '%x' "$variant_val")

  part1=${hex_chars:0:16}
  part2=${hex_chars:17}
  hex_chars="${part1}${variant_char}${part2}"

  # Add hyphens to format as a standard UUID string.
  printf '%s-%s-%s-%s-%s\n' \
    "${hex_chars:0:8}"  \
    "${hex_chars:8:4}"  \
    "${hex_chars:12:4}" \
    "${hex_chars:16:4}" \
    "${hex_chars:20:12}"
}

if [ -f "$bB/pxebin2ccelf.wasm" ]; then
  if [ -z "$PXE_VENDOR_UUID" ]; then
    PXE_VENDOR_UUID=$(ouruuidgen)
  fi
  GameGuid=$(ouruuidgen)

  wasmtime run --dir=. --dir="$bB/includes::/bbincludes" \
    "$bB/pxebin2ccelf.wasm" "$1.bin" "/bbincludes/PXE_CC_pre.arm" "/bbincludes/PXE_CC_post.arm" "$PXE_VENDOR_UUID" "$GameGuid"
else
    echo "pxebin2ccelf skipped. A compatible relocateBB wasn't found."
fi

exit 0
