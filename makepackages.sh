#!/bin/sh
# makepackages.sh
#   apply the release.dat contents to the release text in various sources
#   and documents, and then generate the individual release packages.

RELEASE=$(cat release.dat)
ERELEASE=$(cat release.dat | sed 's/ /_/g')
YEAR=$(date +%Y)

dos2unix 2600bas.c >/dev/null 2>&1
cat 2600bas.c | sed 's/BB_VERSION_INFO .*/BB_VERSION_INFO "batari Basic v'"$RELEASE (c)$YEAR"'\\n"/g' > 2600bas.c.new
mv 2600bas.c.new 2600bas.c
unix2dos 2600bas.c >/dev/null 2>&1

dos2unix README.txt >/dev/null 2>&1
(echo "Batari BASIC v$RELEASE - a Basic Compiler for the Atari 2600" ; \
tail -n +2 README.txt ) > README.txt.new
mv README.txt.new README.txt
unix2dos README.txt >/dev/null 2>&1

make dist

rm -fr packages
mkdir -p packages/bB 2>/dev/null

cp -R includes packages/bB/
cp -R samples packages/bB/
rm -f packages/bB/samples/sizes.ref packages/bB/samples/makefile
rm -f packages/bB/samples/make_test.sh
cp *.TXT *.txt packages/bB/
cp install_ux.sh packages/bB/
cp install_win.bat packages/bB/
cp 2600basic.sh packages/bB/
cp 2600bas.bat packages/bB/
cp *.wasm packages/bB/ ; rm -f packages/bB/makefile.xcmp.wasm
cp dasm.sh packages/bB/dasm
cp dasm.bat packages/bB/
(cd packages ; tar --numeric-owner -cvzf bB-$RELEASE-wasm.tar.gz bB)
(cd packages ; zip -r bB-$RELEASE-wasm.zip bB)
rm -fr packages/bB
