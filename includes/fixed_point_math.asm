; Provided under the CC0 license. See the included LICENSE.txt for details.

; Fixed point math routines - created by AtariAge member djmips
; some changes by Fred Quimby

;assignment from 8.8 to 4.4

Assign88to44:

      ; A(4.4) = A,X(8.8)

       stx temp1
       rol temp1
       asl
       rol temp1
       asl
       rol temp1
       asl
       rol temp1
       asl
       rts

;assignment from 4.4 to 8.8
;

Assign44to88:

      ; A,X(8.8) = A(4.4)

       sta temp1
       lda #0
       asl temp1
       sbc #0   ;
       eor #$ff ; do sign extend
       rol
       asl temp1
       rol
       asl temp1
       rol
       asl temp1
       rol
       ldx temp1
       rts

 ifconst bankswitch
Assign88to44bs:

      ; A(4.4) = A,X(8.8)

       stx temp1
       rol temp1
       asl
       rol temp1
       asl
       rol temp1
       asl
       rol temp1
       asl
       RETURN

;assignment from 4.4 to 8.8
;

Assign44to88bs:

      ; A,X(8.8) = A(4.4)

       sta temp1
       lda #0
       asl temp1
       sbc #0   ;
       eor #$ff ; do sign extend
       rol
       asl temp1
       rol
       asl temp1
       rol
       asl temp1
       rol
       ldx temp1
       RETURN
 endif

;
;Addition/subtraction asm procedures:

;add/sub 8.8 to/from 4.4

Add88to44:

      ; A(4.4) = A,X(8.8) + Y(4.4)

       jsr Assign88to44
       sty temp1
       clc
       adc temp1
       rts

Sub88from44:

      ; A(4.4) = A,X(8.8) - Y(4.4)

       jsr Assign88to44
       sty temp1
       sec
       sbc temp1
       rts


Add44to88:

      ; A,X(8.8) = A,X(8.8) + Y(4.4)

       sta temp2
       stx temp3
       tya
       jsr Assign44to88
       clc
       sta temp1
       txa
       adc temp3
       tax
       lda temp1
       adc temp2
       rts


Sub44from88:

      ; A,X(8.8) = A,X(8.8) - Y(4.4)

       sta temp2
       stx temp3
       tya
       jsr Assign44to88
       sec
       sta temp1
       lda temp3
       stx temp3
       sbc temp3
       tax
       lda temp2
       sbc temp1
       rts

