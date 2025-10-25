#!/bin/sh
# Wrapper for wasmtime with dynamic include directories

if ! command -v wasmtime >/dev/null 2>&1; then
  echo "### ERROR: wasmtime not found in PATH"
  exit 1
fi

BNAME=$(basename "$0" | cut -d. -f1)

# Build up list of --dir arguments
DIRS="--dir=. "

for arg in "$@"; do
  case "$arg" in
    -I*)
      inc="${arg#-I}"
      DIRS="$DIRS --dir=$inc"
      ;;
  esac
done

# Run wasmtime with all dirs and original arguments
exec wasmtime run $DIRS "$bB/$BNAME.wasm" "$@"

