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

#populate architecture neutral stuff into the dist directory
cp -R includes packages/bB/
cp -R samples packages/bB/
rm packages/bB/samples/sizes.ref packages/bB/samples/makefile
rm packages/bB/samples/make_test.sh
cp *.TXT *.txt packages/bB/

for OSARCH in linux@Linux osx@Darwin win@Windows ; do
	for BITS in x64 x86 ; do
		OS=$(echo $OSARCH | cut -d@ -f1)
		ARCH=$(echo $OSARCH| cut -d@ -f2)
		if [ $OS = win ] ; then
			rm -f packages/bB/2600basic.sh
			rm -f packages/bB/install_ux.sh
			cp 2600bas.bat packages/bB/
			cp install_win.bat packages/bB/
			touch packages/bB/sed.exe
			for FILE in *"$ARCH"."$BITS".exe ; do
			  cp "$FILE" packages/bB/
			  SHORT=$(echo $FILE | cut -d. -f1)
			  mv "packages/bB/$FILE" "packages/bB/$SHORT.exe"
                        done
                        (cd packages ; zip -r bB-$ERELEASE-$OS-$BITS.zip bB)
			for FILE in *"$ARCH"."$BITS".exe ; do
			   SHORT=$(echo $FILE | cut -d. -f1)
			   rm "packages/bB/$SHORT" 2>/dev/null
                        done
                else
			rm -f packages/bB/2600bas.bat
			rm -f packages/bB/install_win.bat
			rm -f packages/bB/sed.exe
			cp install_ux.sh packages/bB/
			cp 2600basic.sh packages/bB/
			for FILE in *"$ARCH"."$BITS" ; do
			  cp "$FILE" packages/bB/
			  SHORT=$(echo $FILE | cut -d. -f1)
			  mv "packages/bB/$FILE" "packages/bB/$SHORT"
			done
                        (cd packages ; tar --numeric-owner -cvzf bB-$ERELEASE-$OS-$BITS.tar.gz bB)
			for FILE in *"$ARCH"."$BITS" ; do
			   SHORT=$(echo $FILE | cut -d. -f1)
			   rm "packages/bB/$SHORT" 2>/dev/null
			done
                fi
        done
done

cp *.exe *.Linux.x* *.Darwin.x* install_ux.sh install_win.bat 2600bas.bat 2600basic.sh packages/bB

#32-bit windows is default, for now
for FILE in *.Windows.x86.* ; do
	SHORT=$(echo $FILE | cut -d. -f1)
	mv "packages/bB/$FILE" "packages/bB/$SHORT.exe"
done

touch packages/bB/sed.exe

# make the ALL package with source code and all binaries...
cp *.c *.h *.sh *.bat make* *.lex release* *.txt packages/bB/
cp -R samples includes contrib packages/bB/
(cd packages ; tar --numeric-owner -cvzf bB-$ERELEASE-ALL.tar.gz bB)
(cd packages ; zip -r bB-$ERELEASE-ALL.zip bB)

rm -f packages/bB/sed.exe

# make the SRC packages. gotta remove the binaries
rm packages/bB/*exe
rm packages/bB/*.x64 packages/bB/*.x86 

(cd packages ; tar --numeric-owner -cvzf bB-$ERELEASE-SRC.tar.gz bB)
(cd packages ; zip -r bB-$ERELEASE-SRC.zip bB)

rm -fr packages/bB
