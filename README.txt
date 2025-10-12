Batari BASIC v1.9 - a Basic Compiler for the Atari 2600

	Copyright 2005-2013 by Fred Quimby
	Additional code contributions and fixes by various
	contributors Copyright 2005-2025

	Special thanks to OG contributors who kept the
	dream of simplified coding on the 2600 alive:

		Bob Montgomery
		Michael Rideout
		David Galloway
		Mike Saarna
		Karl Garrison

____________________________________________________________________________

batari Basic is free of charge and provided under the GPL v2 license. See 
the included LICENSE.txt for more information.

The license does not apply to Atari 2600 games created with Batari BASIC.
You may license your games however you wish.  Many batari Basic games have
been published, and are available for sale on cartridge.  
____________________________________________________________________________


WHAT IT IS:
___________

batari Basic (bB) is a BASIC-like language for creating Atari 2600 games.  
It is a compiled language that runs on a computer, and it creates a binary
file that can be run on an Atari 2600 emulator or the binary file may be used 
to make a cartridge that will operate on a real Atari 2600.

If you find any bugs, please report them via github.

To learn how to use Batari Basic, please refer to the documentation found at:
 https://www.randomterrain.com/atari-2600-memories-batari-basic-commands.html 
and the sample programs included in this release.

____________________________________________________________________________


GETTING STARTED:
________________

Extract the contents of the zip file to a new directory.  The name of the
directory doesn't matter, but for consistency with this guide and tutorials,
you may wish to use C:\Atari2600\bB

bB is distributed in the form of universal web-assembly programs. To run 
these, you'll need the "wasmtime" interpreter installed. This can be 
accomplished by running one of the following commands:

  * macOS/Linux: curl https://wasmtime.dev/install.sh -sSf | bash
  * Windows: winget install BytecodeAlliance.Wasmtime.Portable


MS-DOS/Windows:
_______________

batari Basic is distributed as a single zip file. Download the latest zip
file and unzip to whichever location you desire to use. Make sure your
unzip utility creates the expected subdirectories (/docs, /includes, ...)
rather than sticking all of the files into one directory.

Windows users should double-click and the provided install_win.bat file
and follow the instructions presented.

If install_win.bat reports failure, you should manually set the following
variables to point at your batari basic directory.

	set bB=c:\Atari2600\bB
	path=%path%;c:\Atari2600\bB

This is accomplished differently, depending on your version of Windows. This
info is easily found on the Internet - https://tinyurl.com/yx756dug

Once the above is done, switch to a folder containing a bB source file and 
type:

	2600bas filename

where filename is the name of the BASIC source file you wish to compile. The
 project folder can be any folder you create to store your files.

To test your installation, several sample programs are included in the 
"Samples" folder. Change directories to this location and type:

	2600bas sample.bas

If successful, a file called sample.bas.bin will be generated that you can 
run on an emulator, or add to a flash cart. The sample program is not very 
interesting, but note how simple it was to write. Open sample.bas in a text 
editor and take a look at how it was written.


batari Basic for Linux or OS X
______________________________

 1. download and extract the batari Basic distribution to your home directory,
    ensuring the directory structure in the tarball is maintained. I.e. there
    should be "includes" and "samples" subdirectories.

 2. open a terminal window, and "cd" to the unzipped batari Basic directory.

 3. run the installer and follow the instructions: ./install_ux.sh

 4. Testing...

Once the previous steps are done, switch to a folder containing a bB source 
file and type:

	2600bas filename

where filename is the name of the BASIC source file you wish to compile. The
 project folder can be any folder you create to store your files.

To test your installation, several sample programs are included in the 
"Samples" folder. Change directories to this location and type:

	2600bas sample.bas

If successful, a file called sample.bas.bin will be generated that you can 
run on an emulator, or add to a flash cart. The sample program is not very 
interesting, but note how simple it was to write. Open sample.bas in a text 
editor and take a look at how it was written.


HOW IT WORKS:
_____________

Not unlike other compilers, batari BASIC uses a 4-step compilation process:

1. Preprocess..._
   The preprocessor takes your Basic code, and reformats and tokenizes it 
   so the compiler can understand it.  Certain errors can be caught at this 
   stage.

2. Compile..._
   The compiler converts your Basic code into assembly language.  It will 
   create a temporary file called bB.asm.  The Basic code is preserved as 
   comments in this file so that those wishing to study assembly language
   can learn by studying how the Basic code was converted.

3. Link...
   The linker splits the Basic code into sections if needed, then 
   concatenates them, along with the kernel, modules and compilation 
   directives into a composite assembly language file.

[3a. Optimize...]
   An optional stage is a peephole optimizer that looks for redundant 
   and unnecessary code in the composite assembly file.

4. Assemble...
   The assembler converts assembly language to a binary file that contains 
   machine code that can run on an emulator or a real Atari 2600.

