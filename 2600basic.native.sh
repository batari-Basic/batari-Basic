#!/bin/sh
# 2600basic compilation script (native executables)

# do some quick sanity checking...
if [ ! "$bB" ] ; then
  echo "### WARNING: the bB envionronment variable isn't set."
fi
if [ ! -f "$bB/dasm" ] ; then
  DDIR=$(dirname $(which dasm 2>/dev/null))
  if [ ! -f "$DDIR/dasm" ] ; then
    echo "  ABORT: couldn't find natively compiled dasm!"
    exit 1
  else
    echo "### WARNING: dasm wasn't found in the bB directory. Using an external dasm."
    echo "    bB error reporting features have minimum dasm version requirements."
    echo 
  fi
else
  DDIR="$bB"
fi

echo "  basic version:  "$($bB/2600basic -v 2>/dev/null)

echo "  "dasm version:"  " $($DDIR/dasm 2>/dev/null| head -n1)

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
 $bB/preprocess <"$1" | \
 $bB/2600basic -i "$bB" > bB.asm

if [ "$?" -ne "0" ]
 then
  echo "Compilation failed."
  exit
fi

if [ "$2" = "-O" ]
  then
   $bB/postprocess -i "$bB" | $bB/optimize > "$1.asm"
  else
   $bB/postprocess -i "$bB" > "$1.asm"
fi

$DDIR/dasm "$1.asm" -I"$bB/includes" -f3 -l"$1.lst" -p20 -s"$1.sym" -o"$1.bin" | $bB/bbfilter

if [ -f "$bB/relocateBB" ]; then
  $bB/relocateBB "$1.bin" 
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

if [ -f "$bB/pxebin2ccelf" ]; then
  if [ -z "$PXE_VENDOR_UUID" ]; then
    PXE_VENDOR_UUID=$(ouruuidgen)
  fi
  GameGuid=$(ouruuidgen)

  $bB/pxebin2ccelf "$1.bin" "$bB/includes/PXE_CC_pre.arm" "$bB/includes/PXE_CC_post.arm" "$PXE_VENDOR_UUID" "$GameGuid"
fi

exit 0
