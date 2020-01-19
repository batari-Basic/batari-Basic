#!/bin/sh
RELEASE=2.20.12
BASEURL=https://github.com/dasm-assembler/dasm/releases/download/$RELEASE
for OSARCH in linux@Linux osx@Darwin win@win ; do
	for BITS in x64 x86 ; do
		OS=$(echo $OSARCH | cut -d@ -f1)
		ARCH=$(echo $OSARCH| cut -d@ -f2)
		if [ $OS = win ] ; then
			wget $BASEURL/dasm-$RELEASE-$OS-$BITS.zip
			unzip dasm-$RELEASE-win-$BITS.zip
			cp dasm.exe ../dasm.Windows.$BITS.exe
			mv dasm.exe ../dasm.exe
			rm dasm-$RELEASE-win-$BITS.zip
			rm -fr machines
		else
			wget $BASEURL/dasm-$RELEASE-$OS-$BITS.tar.gz
			tar -xvzf dasm-$RELEASE-$OS-$BITS.tar.gz dasm 
			rm -f ../dasm.$ARCH.$BITS
			mv dasm ../dasm.$ARCH.$BITS
			rm dasm-$RELEASE-$OS-$BITS.tar.gz
			rm -fr machines
		fi
	done
done

cat << EOF > ../dasm.LICENSE.txt
Dasm $RELEASE is distributed here under the terms of the GNU GPL v2 License.

Please see the included LICENSE.txt file for the full GPL v2 license text.

The source code for this version of dasm is available via github at this
location:

   https://github.com/dasm-assembler/dasm/archive/$RELEASE.tar.gz

EOF
