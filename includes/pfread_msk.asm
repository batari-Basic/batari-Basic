; Provided under the CC0 license. See the included LICENSE.txt for details.

pfread
 cmp #16
 bcc lefthalf
 eor #31 ; 16-31 converted to 15-0
lefthalf
 tax
 lda bytemask,x
 cpx #8
 bcc bytedone
 and (PF2pointer),y
 .byte $0C
bytedone
 and (PF1pointer),y
 RETURN
bytemask
 .byte $80,$40,$20,$10,8,4,2,1
 .byte 1,2,4,8,$10,$20,$40,$80
