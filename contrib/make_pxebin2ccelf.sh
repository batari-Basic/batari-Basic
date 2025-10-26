#!/bin/sh
# make_pxebin2ccelf utility wasm build wrapper

export WASI_SDK=/opt/wasi-sdk/
export CC=$WASI_SDK/bin/clang
export CFLAGS="-O2"
export LDFLAGS="-O2 -Wl,--no-entry"

rm -fr pxebin2ccelf-1.0
tar -xvzf pxebin2ccelf-1.0.tar.gz
cd pxebin2ccelf-1.0
make
mv pxebin2ccelf ../../pxebin2ccelf.wasm
cd ..
rm -fr pxebin2ccelf-1.0
