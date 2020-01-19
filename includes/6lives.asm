; Provided under the CC0 license. See the included LICENSE.txt for details.

minikernel ; display up to 6 lives on screen
 sta WSYNC
 sleep 10 ; can we optimize this?
 lda #0
 ldy #7
 sta VDELP0
 sta VDELP1
 ifnconst lives_compact
 ifnconst lives_centered
 sta RESP0
 endif
 lda.w lives
 ifnconst lives_centered
 sta RESP1
 endif
 lsr
 lsr
 lsr
 lsr
 ifconst lives_centered
 sta RESP0
 endif
 lsr
 tax
 ifconst lives_centered
 sta RESP1
 endif
 lda lifenusiz0table,x
 sta NUSIZ0
 lda lifenusiz1table,x
 sta NUSIZ1
 lda lifecolor
 sta COLUP0
 sta COLUP1
 lda #$b0
 sta HMP0

 else

 ifnconst lives_centered
 sta.w RESP0
 sta RESP1
 endif
 lda lives
 lsr
 lsr
 lsr
 lsr
 lsr
 tax
 lda lifenusiz0table,x
 ifconst lives_centered
 sta RESP0
 sta RESP1
 sta.w NUSIZ0
 else
 sta NUSIZ0
 endif
 lda lifenusiz1table,x
 sta NUSIZ1
 lda lifecolor
 sta COLUP0
 sta COLUP1
 lda #$10
 sta HMP1

 endif

 sta HMOVE ; cycle 73

lifeloop
 cpx #0
 beq skipall
 lda (lifepointer),y
 sta GRP0
 cpx #1
 beq skipall
 sta GRP1
skipall
 dey
 sta WSYNC
 bpl lifeloop
 iny
 sty GRP0
 sty GRP1
 rts

 if (<*) > $F5
 align 256
 endif
 ifconst lives_compact
lifenusiz1table
 .byte 0
lifenusiz0table
 .byte 0,0,0,1,1,3,3,3
 else
lifenusiz1table
 .byte 0
lifenusiz0table
 .byte 0,0,0,2,2,6,6,6
 endif
