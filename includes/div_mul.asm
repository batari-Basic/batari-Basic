; Provided under the CC0 license. See the included LICENSE.txt for details.

; y and a contain multiplicands, result in a

mul8
 sty temp1
 sta temp2
 lda #0
reptmul8
 lsr temp2
 bcc skipmul8
 clc
 adc temp1
;bcs donemul8 might save cycles?
skipmul8
;beq donemul8 might save cycles?
 asl temp1
 bne reptmul8
donemul8
 RETURN

div8
 ; a=numerator y=denominator, result in a
 cpy #2
 bcc div8end+1;div by 0 = bad, div by 1=no calc needed, so bail out
 sty temp1
 ldy #$ff
div8loop
 sbc temp1
 iny
 bcs div8loop
div8end
 tya
 ; result in a
 RETURN

