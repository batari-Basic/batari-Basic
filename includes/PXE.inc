; Provided under the CC0 license. See the included LICENSE.txt for details.

;
; Inclues go below - order is crucial, since this is also the order in which
; they will appear in the generated assembly file
;


; header file
PXEheader.asm



; PXE startup routine
PXEstartup.asm

; PXE kernel
PXE_kernel.asm

; The overscan routine goes below.  it sets up sprites for the std_kernel.
; if you have any routines that will not run until the overscan period,
; put them immediately below this line.

; do we need an overscan routine?

; below is the generated batari Basic file

bB.asm

; rest of bB stuff, ending with graphics
bB2.asm

; below is the footer, which contains the score digits and startup vectors.
; If you want to create your own custom score digits, you may hack the file below,
; but first you should rename it to something else.

; score graphics
score_graphics.asm

PXEfooter.asm
