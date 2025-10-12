#!/bin/sh
rm -fr relocateBB-1.0
tar -xvzf relocateBB-1.0.tar.gz
cd relocateBB-1.0
GOOS=wasip1 GOARCH=wasm go build -o relocateBB.wasm .
mv relocateBB.wasm ../..
cd ..
rm -fr relocateBB-1.0
