; Provided under the CC0 license. See the included LICENSE.txt for details.

; Compute mul1*mul2+acc -> acc:mul1 [mul2 is unchanged]
; Routine courtesy of John Payson (AtariAge member supercat)
 
 ; x and a contain multiplicands, result in a, temp1 contains any overflow

mul16
 sty temp1
 sta temp2
 ldx #8
 dec temp2
loopmul
 lsr
 ror temp1
 bcc noaddmul
 adc temp2
noaddmul
 dex
 bne loopmul
 RETURN

; div int/int
; numerator in A, denom in temp1
; returns with quotient in A, remainder in temp1

div16
 sta temp2 
 sty temp1 
 lda #0
 ldx #8
 asl temp2
div16_1
 rol
 cmp temp1
 bcc div16_2
 sbc temp1
div16_2
 rol temp2
 dex
 bne div16_1
 sta temp1
 lda temp2
 RETURN

