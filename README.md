### About

Batari BASIC v1.7 - a Basic Compiler for the Atari 2600

Copyright 2005-2013 by Fred Quimby

  Additional code contributions and fixes by...

- Bob Montgomery
- Michael Rideout
- David Galloway
- Mike Saarna
- Karl Garrison

...and are Copyright 2005-2020.

### License

**batari Basic** is free of charge and provided under the GPL v2 license. See the included LICENSE.txt for more information.

The license does not apply to Atari 2600 games created with Batari BASIC. You may license your games however you wish. Many **batari Basic** games have been published, and are available for sale on cartridge.

### What is batari-Basic?

**batari Basic** (bB) is a BASIC-like language for creating Atari 2600 games. It is a compiled language that runs on a computer, and it creates a binary file that can be run on an Atari 2600 emulator or the binary file may be used to make a cartridge that will operate on a real Atari 2600.

If you find any bugs, please report them via github.

To learn how to use **batari Basic**, please refer to the documentation found at [Random Terrain](https://www.randomterrain.com/atari-2600-memories-batari-basic-commands.html) and the sample programs included in this release.

### Getting Started

Extract the contents of the zip file to a new directory. The name of the directory doesn't matter, but for consistency with this guide and tutorials, you may wish to use `C:\Atari2600\bB`.

#### MS-DOS/Windows:

**batari Basic** is distributed as a single zip file. Download the latest zip file and unzip to whichever location you desire to use. Make sure your unzip utility creates the expected subdirectories (/docs, /includes, ...) rather than sticking all of the files into one directory.

Windows users should double-click and the provided install_win.bat file and follow the instructions presented.

If install_win.bat reports failure, you should manually set the following variables to point at your batari basic directory.

```bat
set bB=c:\Atari2600\bB
path=%path%;c:\Atari2600\bB
```

This is accomplished differently, depending on your version of Windows. This info is easily found on the Internet - https://tinyurl.com/yx756dug

Once the above is done, switch to a folder containing a bB source file and type:

```sh
2600bas filename
```

where filename is the name of the BASIC source file you wish to compile. The project folder can be any folder you create to store your files.

To test your installation, several sample programs are included in the "`Samples`" folder. Change directories to this location and type:

```sh
2600bas sample.bas
```

If successful, a file called `sample.bas.bin` will be generated that you can run on an emulator, or add to a flash cart. The sample program is not very interesting, but note how simple it was to write. Open sample.bas in a text editor and take a look at how it was written.

#### Getting Started with Linux/OS X/other Unixes

This version of **batari Basic** comes bundled with 32-bit and 64-bit binaries for both OS X and Linux. If you wish to run **batari Basic** on a platform other than those ones, you'll need to rebuild the binaries. (Refer to the provided `COMPILE.txt` document)

The rest of this section assumes you understand what directory you saved the **batari Basic** zip file to, how to extract the zip file, how to open a Unix shell, and how to use the "cd" command to move into in directories.

#### batari Basic for Linux or OS X - the Easy Way
1. Download and unzip the **batari Basic** distribution to your home directory, ensuring the directory structure in the zip is maintained. (i.e., there should be "`includes`" and "`samples`" subdirectories.)
2. Open a terminal window, and "cd" to the unzipped **batari Basic** directory.
3. Run the installer and follow the instructions: ./install_ux.sh

#### batari Basic for Linux or OS X - Manual_Installation

1. Download and unzip the **batari Basic** distribution to your home directory, ensuring the directory structure in the zip is maintained. (_i.e._, There should be "`includes`" and "`samples`" subdirectories.)

2. Ensure these two environment variables are set...
   ```sh
   export bB=$HOME/bB.1.2
   export PATH=$bB:$PATH
   ```

   **Substitute the actual location of the unzipped bB distribution on your system in the first line.**

3. Compile your basic program using the 2600basic.sh script.

   _e.g._, `2600basic.sh myprogram.bas`

   It should produce a binary named after the basic program, but ending with the file extension "`.bin`".

   If it doesn't work, ensure you have set the bB and PATH variables correctly.

### How It Works

Similar to other compilers, batari BASIC uses a 4-step compilation process:

1. Preprocess...
   The preprocessor takes your Basic code, and reformats and tokenizes it so the compiler can understand it. Certain errors can be caught at this stage.

2. Compile...
   The compiler converts your Basic code into assembly language. It will create a temporary file called bB.asm. The Basic code is preserved as comments in this file so that those wishing to study assembly language can learn by studying how the Basic code was converted.

3. Link...
   The linker splits the Basic code into sections if needed, then concatenates them, along with the kernel, modules and compilation directives into a composite assembly language file.

   3a. Optimize...
       An optional stage is a peephole optimizer that looks for redundant and unnecessary code in the composite assembly file.

4. Assemble...
   The assembler converts assembly language to a binary file that contains machine code that can run on an emulator or a real Atari 2600.

### Revision History (pre git)

Note: Lists of changes are not comprehensive.

#### 1.2 updates: July 2013 - Jan 2020 (Mike Saarna)<br/>Initially a fork-release, now official

- Numerous changes to support 64k format.
- Added the "hex" font, for convenient debugging work.
- Fixed `div16` implementation, so the `//` operator is now as-documented.
- Fixed DPC+ kernel ghost pixel that appeared on some TIA revisions.
- Silence the majority of -Wall warnings. Only flex warnings remain.
- Adjusted symbol and list file names to allow easier import into stella.
- Added `-v` version output switch to `2600basic` (`2600bas.c`)
- Added missing `player1color`: check to `findlabel()` in `statements.c`
- Updated `2600bas.c` and `statements.c` to remove first pass output official ROM space left.
- Updated branching handlers in `statements.c` to warn for last page branch accidental hotspot triggering.
- Added necessary padding when pfheights table is used and near the start of a page. (`statements.c`)
- Fixed off-by-one mallocs in `postprocess.c`.
- Fixed `**statement` overrun in `2600bas.c` when code has REM with long horizontal separators.
- Increased `**statement` setup from 50x50 to 100x100 in `2600bas.c`, to match some usage in `statements.c` and avoid overruns.
- Fixed DPC+ kernel screen garbling bug when not using "`set kernel_options collision`". (`DPCplus_kernel.asm`)
- Fixed DPC+ stack range pull. Pulling was restoring in reverse order to pushing, and only pulling the first value. (`statement.c`)
- Fixed DPC+ variable list pull. Pulling was restoring in reverse order to pushing, which batari described as broken. (`statement.c`)
- Fixed DPC+ COLUM0 color bug. (`custom/main.c` and `DPCplus_kernel.asm`)
- Fixed off-by-one bouncy-score bug. (`std_kernel.asm`)
- Removed variable references to other variables in `multisprite.h`, as that was causing dasm label shifting between passes.
- Added pfread for DPC+. (`custom/main.c` and `statement.c`)
- Added "tiny" font to font collection, by popular demand. (score_graphics.asm and score_graphics.asm.tiny)
- Added "dec" command, to do "let" type addition or subtraction in decimal mode. (`statements.c`, `statements.h`, `keywords.c`, `keywords.h`)
- Added scorefade constant into the standard kernel, to allow a gradient/colorbar effect. (`std_kernel.asm`)
- Fixed additional scanline issue in standard kernel when both "set tv pal" and "no_blank_lines" were used.
- Modified regular expression in `preprocess.lex` to allow for `player#-#color:` statements, which enabled batari's existing `player#-#color:` code.
- Added DPC+ pfclear command. (`custom/main.c`, `statements.c`)
- Fixed DPC+ bug whereby a partially displayed virtual sprite at top of the screen would prematurely end positioning for the other virtual sprites. (`custom/main.c`)
- Fixed vertical wrapping of `player0` in DPC+ kernel. (`custom/main.c` and `DPCplus_kernel.asm`)
- Fixed horizontal masking of reflected vsprites. (`custom/main.c`)
- Fixed `pfscore` timing in DPC+ `pfscore` code. (`DPCplus_kernel.asm`)
- Set `COLUBK` to 0 as part of DPC+ kernel, so the partial color wouldn't show up before the first line. (`DPCplus_kernel.asm`)
- Fixed multiplication by powers of two greater than 11 so they still use shifting. (`statement.c`)
- Added makefiles for Linux, OS X, and Windows2. "`make dist`" with the default makefile will build bB binaries for all platforms, assuming you have cross compilers setup..
- Modified 2600bas.sh to work with OS specific binaries, and allow for spaces in path of the bB variable.
- Added includes/indent.sh, a script to tidy 6502/7 assembly source. Used it on the standard and DPC+ kernel sources.
- Added documentation: `ISSUES.txt`, `COMPILE.txt`, `README_UX.txt`, and `ARMCOMPILE.txt`
- Fixed the PF1 data glitch would show up beyond the last line. (`DPCplus_kernel.asm`)
- Squeezed DPC+ kernel for space, and then squeezed more (`custom/main.c`)
- Implemented pfscroll for DPC+. (`statements.c`, `custom/main.c`)
- Added collision(player0,_player1) for just detecting p0+p1 detection. (`statements.c`)
- Fixed cycle overage in the standard kernel that was corrupting the last line when scrolling.  (`std_kernel.asm`)
- Fixed another overage in the standard kernel leading into the last line, which was corrupting the first scanline of the last line when scrolling. (`std_kernel.asm`)
- Changed the DPC+ virtual sprite maximum from a constant to a variable amount. (`custom/main.c`)
- Added quotes to batch file to allow for paths with spaces. (`2600bas.bat`)
- Added missing "-i" to optimize preprocess commands. (`2600bas.bat`)
- Removed "asm" preprocessor expression that was causing an assembly block to continue past "end" if "end" had an empty line above it.
- Added optional start_queue and end_queue arguments to DPC+ pfscroll, to allow for scrolling the color queue, or split screen scrolling. (`statements.c`, `custom/main.c`)
- Enable P0 display on the first scanline. (`DPCplus_kernel.asm`)
- DPC+ bkcolors: and pfcolors: now only use the actual number of colors listed, similar to playfield:. (`statements.c`)
- Disabled fast fetching before the minikernel, and reenabled it after. (`DPCplus_kernel.asm`)
- Batari fixed a bug that messed up the results of an if...then statement containing multiple complex () statements. (`statements.c`)
- Added bbfilter utlity to replace sed for filtering bB symbols out of dasm results.
- Updated `2600basic.sh`, `2600bas.bat` to use `bbfilter`.
- Updated dasm to dasm-2.20.11-update-20140124, put dasm source in `contrib/src`.
- Added `install_win.bat`, which will update bB and PATH variables on Windows. requires Windows XP SP2 and later.
- Fixed bug where dim and const didn't work with a trailing : separator. (`statements.c`)
- Added `install_win.bat`, to permanently set bB and PATH variables on Windows XP SP2 and later versions of Windows.
- Raised statement size and number of statements from 50 t0 200 (`*.c`).
- Defined unused DPC zero page memory as var0->var8. (`DPCplusbB.h`)
- Fixed bug where ; comments were eating lines and had bad linecount. (`preprocess.lex`)
- Fixed page crossing bug with player1colors in last playfield row.
- Add work-around for complex statements causing "Unknown keyword" on "then label".
- Reordered memory in `2600basic.h` so variables var0 to Z are continuous.
- Moved object motion reset prior to user vblank, to allow for Cosmic Ark type effects. (`DPCplus_kernel.asm`)
- Fixed too display line count when using DPC+ and "`const noscore=1`" (`DPCplus_kernel.asm`)
- Stuff I've long forgotten.

#### 1.1d beta: July 28, 2011<br/>DPC+ kernel updates

- Multiple player definitions
- Pfpixel, pfvline and pfhline
- Collision detection:
  - Pixel-perfect collision(player#,player#) where # is 0-9, for any two real or virtual player sprites
  - A kernel_option controls an in-kernel read of a standard hardware collision register (example: `set kernel_options collision(player1,playfield)` will return the y-coordinate where the first such collision occurs, so you can later figure out what sprite it was.) Value is returned in `temp4` after a `drawscreen`.
- Smooth scroll in from left or right (upper two bits of `NUSIZ` control it)

#### 1.1c beta: June 6, 2011<br/>DPC+ kernel updates

- Virtual sprites now move offscreen vertically without corruption.
- COLUM0 and COLUM1 missile color functionality added.

#### 1.1b beta: March 5th, 2011<br/>DPC+ kernel updates

- Support for 10 sprites (player0-player9)
- Pfcolors: now works
- Background colors per line supported (uses new bkcolors: command)
- Scorecolor: command to define score colors per line
- Comments with semicolon now supported
- C-style multiline comments with /* and */
- Use of extra RAM in DPC+ (described below)

#### 1.1a beta: January 30, 2011<br/>Initial intruduction of DPC+ kernel

- Six sprites (one exclusive, five multiplexed, will be increased to 10)
- All sprites have twice the vertical resolution as other bB kernels
- All sprites can be multicolored
- Asymmetric playfield, any resolution
- Multicolored playfield
- Playfield allows independent resolution control for each 8-pixel column
- Both missiles and ball available and may be any height
- Each sprite allows its REFPx and NUSIZx set independently
- Automatic flickering

#### 1.0: February 14, 2007<br/>Official release

- Reinstated exotic illegal opcodes that were removed in version 0.3
- Pfread function for the multisprite kernel
- Sequential data streams >256 bytes
- Superchip support
- Eliminated HMOVE line above score
- Added score to multisprite kernel
- Improved flicker algorithm in multisprite kernel
- No longer need module for multiplication by 16, 32, 64, or 128
- Ability to specify vertical resolution of playfield rows
- Ability to specify the overall height of the playfield rows
- Pfscore bars
- HUDs (minikernels)
    6 lives
    6 lives + status bar
- Display should now have 262 scanlines
- Added ability to set reflection bit for sprites in multisprite kernel
- Optimized multisprite kernel for space
- Reboot command: warm start of current ROM
- Pop command: pulls out of subroutine without needing a return
- 7800 detection
- Batch file invokes sed to limit DASM's output to something more meaningful
- Fixed bugs:
  - Playfield: command in standard kernel now work in all banks rather than just the last
  - Fixed point math assignments only worked when at the end of a line
  - Blank lines in data statements now allowed
  - Two parentheses at beginning of assignment no longer detected as function
  - One bit assigned to another now actually works
  - Unary minus should work now
  - Math modules now work with bankswtiched games

#### Beta 0.99c: June 30, 2006<br/>Unreleased build

- Kernel_options directive, which includes:
  - Paddle reading
  - Multicolored playfield
  - Multicolored players
  - Ability to remove blank lines in playfield

#### Beta 0.99b: March 2, 2006<br/>Unofficial, incomplete release

- Fixed many nasty bugs with fixed point math
- Vblank keyword
- 16-bit random number generator
- Bug with expression evaluator fixed
- Added BSD-style license (see license.txt)
- Improved some modules

#### Beta 0.99a: January 14, 2006<br/>Unofficial, incomplete release

- Multisprite kernel implemented
- Bankswitching
- Full expression evaluation
- Debugging tools
- TV type setting
- Pfclear command
- Playfield: command

#### Alpha 0.35: August 26, 2005<br/>Maintenance release to fix some particularly nasty bugs.

- Include command now works
- Bit operations now compile properly
- 4.4 fixed point math didn't sign-extend when adding to 8.8
- Fixed point math adds/subtracts by 1.xx no longer drop the .xx
- Ballheight or missileXheight of 0 or 1 no longer breaks the kernel
- Fixed batch file to work with Windows 95/98/ME
- More than one || per program now allowed
- Maybe more that I can't remember now

#### Alpha 0.3: August 23, 2005

- Standard kernel now has the ball
- 8.8 and 4.4 fixed point types
   - automatic conversion from one type to another in assignments
   - addition/subtraction routines do automatic conversion if multiple types are used
   - immediate decimal numbers allowed, either negative or positive
   - 8.8 types can be used wherever integers are used
   - 4.4 can't be used anywhere but can be added/subtracted/assigned to other types
- Data statement length keyword
- Remove trailing commas from data statements
- Set optimization for size/speed
- Full divide/multiply
   - optional: multiply can produce a 16-bit result or divide can produce remainder
- Bit operations - assign one bit to another
- For-next loop bug fixed (foward loops by step >1 ended too soon)
- "else" allowed in if-thens
- Able to set the filename of variable alias file
- Set ROM size to 2k or 4k
- Smartbranching now accessed via set instead of rem
- REFPX bug fixed
- Uses includes file for spcifying kernels and organizing modules
- Include additional modules with include command
- Pfread function (determine if pixel is off or on)
- Fixed bug in decreasing for-next loops
- Function declaration for user functions:
   - functions can be in bB or asm
   - optinally can be compiled separately and included as modules
- `Score=score+` var now supports vars other than a-z
- Fixed bugs in if-thens for bit reads
- Longer variable names allowed (50 chars max.)
- Allow arrays as arguments in all functions (in user functions or built-in fns like `pfpixel`)
- Improved error handling/reporting:
   - more descriptive errors
   - line in file now echoed
- Const statement for defining constants
- Optimized code
- Fixed < and > comparisons, and added <= and >=
- Fixed collision checks
- Used lex to help with parsing/preprocessing
- Score=score-1 bug fixed
- Fixed bogus gosub/return errors
- On...goto now allows labels instead of just linenumbers
- Allow negative numbers in code (whew!)

#### Alpha 0.2: July 15, 2005

- Score calculation improved.
- Slight kernel improvements
- Alphanumeric labels allowed, and labels/linenumbers are now optional.
- Blank lines allowed
- Indexing (array-like feature) implemented
- Data statement implemented
- Fixed bug in inline asm where it was impossible to add labels
- One boolean now allowed in an if-then (&&,||)
- Ability to access individual bits
- Fixed bug where return command wasn't recognized
- For-next loops added
- Vastly improved parser - not nearly as sensitive to spacing
- Dim statement for alternate variable names
- Upon compilation, DASM shows bytes free in ROM
- Removed exotic illegal opcodes that would cause problems in some emulators,
- Like PCAE
- Included files are now in cr/lf format to patch a limitation of DASM
- Fixed various bugs in pfpixel and pfhline routines
- On....goto added
- Fixed problem where duplicate labels were created

#### Alpha 0.1: July 7, 2005<br/>Initial release.

### The batari Basic team:

I would like to thank those who have helped me develop bB. Actually, lots of people have helped, but some have helped a great deal. This is not a complete list of contributors or contributions!

- **Michael Rideout**: Wrote the tutorials, added Superchip support, reported countless bugs, made many helpful suggestions, and is instrumental with helping others learn the language.
- **Bob Montgomery**: Rewrote the standard kernel and contributed the multisprite kernel.
- **Kirk Israel**: Hosted the bB webpage, created various bB tools, and suggested many great improvements.
- **Doug Dingus**: Documentation of version 0.1, found numerous bugs and wrote the first playable game.
- **David Galloway**: Wrote the fixed-point math module.
- **Duane Alan** Hahn: Immensely improved the documentation.
- **Chris Read**: Maintains bB game archive.
- **Albert Yarusso**: For Atariage, without which, bB probably never would have been created!

Acknowledgments: **Thomas Jentzsch**, **John Payson**, **Zach Matley**, **Chris Walton**, **Glenn Saunders**, **Manuel Polik**, and **Darrell Spice**.

I can't remember what some of the above people have done, but I'm sure they were helpful in some way. Some people weren't mentioned because I don't know their real names. If I've forgotten anyone, please let me know.
