; Provided under the CC0 license. See the included LICENSE.txt for details.

pfscroll ; for MSK (a=0 up, 1 down)
 bne MSK_scrolldown
 dec playfieldpos
 bpl noshiftdown
 lda pfheight
 sta playfieldpos
 dec PF1pointer
 dec PF2pointer

 ifconst pfscroll_adjust_y
   ldx #8
adjustyloop
   lda objecty,x
   sec
   adc pfheight
   sta objecty,x
   dex
   bpl adjustyloop
 endif

noshiftdown
 RETURN

MSK_scrolldown
 inc playfieldpos
 lda pfheight
 cmp playfieldpos
 bcs noshiftdown
 lda #0
 sta playfieldpos
 inc PF1pointer
 inc PF2pointer

 ifconst pfscroll_adjust_y
   ldx #8
adjustyloop2
   lda objecty,x
   clc
   sbc pfheight
   sta objecty,x
   dex
   bpl adjustyloop2
 endif
 RETURN
