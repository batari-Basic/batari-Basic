#!/bin/sh
# rebuild dasm for wasm

rm -fr dasm*

# determine DASMRELEASE and DASMSOURCE
. ./version_dasm.sh

export WASI_SDK=/opt/wasi-sdk/
export CC=$WASI_SDK/bin/clang
export CFLAGS="-O2"
export LDFLAGS="-O2 -Wl,--no-entry"

mkdir dasmtmp
TAR=$(basename "$DASMSOURCE")
cd dasmtmp
wget "$DASMSOURCE"
tar -xvzf "$TAR" && rm "$TAR"
cd *
make
cp src/dasm ../../../dasm.wasm
cd ../..
rm -fr dasm*
