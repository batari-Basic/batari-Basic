; Provided under the CC0 license. See the included LICENSE.txt for details.

minikernel ; display up to 6 lives on screen
 sta WSYNC
 ldx #$20
 stx HMP1
 stx VDELP0
 lda lives
 lsr
 lsr
 lsr
 lsr
 lsr
 sta RESP0
 sta RESP1
 stx VDELP1
 tax
 lda lifenusiz0table,x
 sta NUSIZ0
 lda lifenusiz1table,x
 sta NUSIZ1
 lda lifecolor
 sta COLUP0
 sta COLUP1
 lda #$10
 sta HMP0

 lda statusbarlength
 lsr
 lsr
 lsr ; 0-31
 ; 3 cases: 0-7, 8-15, 16-24
 ; if 0-7, temp1=val, temp2=0, temp3=0
 ; if 8-15, temp1=255, temp2=val (rev), temp3=0
 ; if 16-23, temp1=255, temp2=255, temp3=val
 tay

 sta HMOVE ;cycle 74?

 ifconst statusbarcolor
 ; only write COLUPF if color variable exists, otherwise use existing PF color
 lda statusbarcolor
 sta COLUPF
 endif

 cpy #8
 bcc zero_7
 cpy #16
 bcc eight_15
 lda #255
 sta temp1
 sta temp2
 lda statustable-16,y
 sta temp3
 lda statustable,y
 sta temp4
 jmp startlifedisplay

zero_7
 lda #0
 sta temp4
 sta temp3
 sta temp2
 lda statustable,y
 sta temp1
 jmp startlifedisplay
eight_15
 lda #255
 sta temp1
 lda #0
 sta temp4
 sta temp3
 lda statustable+16,y
 sta temp2
startlifedisplay
 ldy #7
lifeloop
 sta WSYNC
 stx PF0
 lda (lifepointer),y
 cpx #0
 bne onelife
 .byte $0C
onelife
 sta GRP0

 cpx #2
 bcs nolives
 .byte $0C
nolives
 sta GRP1
 lda temp4
 sta PF0
 lda temp1
 sta PF2
 lda temp3
 sta PF1
 lda temp2
 sta PF2 ;cycle 48!
 pla ; waste 14 cycles in 4 bytes
 pha ;
 pla ;
 pha ; Shouldn't hurt anything!
 lda #0
 dey
 sta PF1
 bpl lifeloop
 sta WSYNC
 iny
 sty PF0
 sty PF2
 sty PF1
 sty GRP0
 sty GRP1
 rts

 if (<*) > $F5
 align 256
 endif
lifenusiz1table
 .byte 0
lifenusiz0table
 .byte 0,0,0,1,1,3,3,3

statustable ; warning: page-wrapping might cause issues
;0-7 and 16+
 .byte %00000000
 .byte %00000001
 .byte %00000011
 .byte %00000111
 .byte %00001111
 .byte %00011111
 .byte %00111111
 .byte %01111111
 .byte 255
 .byte 255
 .byte 255
 .byte 255
 .byte 255
 .byte 255
 .byte 255
 .byte 255
; 8-15
 .byte 0
 .byte 0
 .byte 0
 .byte 0
 .byte 0
 .byte 0
 .byte 0
 .byte 0
 .byte %00000000
 .byte %10000000
 .byte %11000000
 .byte %11100000
 .byte %11110000
 .byte %11111000
 .byte %11111100
 .byte %11111110

