; Provided under the CC0 license. See the included LICENSE.txt for details.

;
; Inclues go below - order is crucial, since this is also the order in which
; they will appear in the generated assembly file
;


; header file
2600basicheader.asm

; standard startup routine.
startup.asm

; standard kernel: two players, two missiles, a ball and an asymmetric playfield.
std_kernel.asm


; below are collections of subroutines and functions
; if you have any more to add, put them immediately below this line.

pf_drawing.asm
pf_scrolling.asm
std_routines.asm

; The overscan routine goes below.  it sets up sprites for the std_kernel.
; if you have any routines that will not run until the overscan period,
; put them immediately below this line.
std_overscan.asm


; below is the generated batari Basic file

bB.asm


; score graphics.
score_graphics.asm

; below is the footer, which contains the score digits and startup vectors.
; If you want to create your own custom score digits, you may hack the file below,
; but first you should rename it to something else.

2600basicfooter.asm
