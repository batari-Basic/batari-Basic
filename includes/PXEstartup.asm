; Provided under the CC0 license. See the included LICENSE.txt for details.

start
 sei
 cld
 ldy #0
 lda $D0
 cmp #$2C               ;check RAM location #1
 bne MachineIs2600
 lda $D1
 cmp #$A9               ;check RAM location #2
 bne MachineIs2600
 dey
MachineIs2600
 ldx #0
 txa
clearmem
 inx
 txs
 pha
 bne clearmem
 sty temp1
 ldx #8
 stx playfieldpos
 stx FASTFETCH
 ldx #15
 lda #224
inityloop
 sta player1y,x
 dex
 bpl inityloop
 stx $2d ; Default score color to last colubk

 lda #1
 sta CTRLPF
 lda INTIM
 sta RWRITE0
 lda #0
 STA DF0FRACINC
 STA DF1FRACINC
 STA DF2FRACINC
 STA DF3FRACINC
 STA DF4FRACINC
 STA DF6FRACINC
 lda #<USERSTACK
 STA DF7LOW
 lda #(>USERSTACK)
 STA DF7HI
 lda #255
 sta CALLFUNCTION ; zero-fill fetcher

   jmp game
