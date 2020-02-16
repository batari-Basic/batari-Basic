drawscreen
     lda #1
     sta CXCLR
     sta COLUBK ; REVENG - don't start with the lastline color

fufu
     lda INTIM
     bmi fufu

     VERTICAL_SYNC

     lda #41+128;was 37 - do more w/c code
     sta TIM64T

     ; adjust for pfpos?

     ; set zero to properly enter C code
     lda #<C_function
     sta DF0LOW
     lda #(>C_function) & $0F
     sta DF0HI
     lda #0
     sta DF0WRITE

     ; REVENG - pass the number of vsprites we want...
     ifnconst dpcspritemax
       ifconst readpaddle
          lda #8
       else
          lda #9
       endif
     else
       lda #dpcspritemax
     endif
     sta DF0WRITE 

     lda player0x
     sta player0xcoll ; detect p0x colls

     ; copy RAM to fetcher for C-code
     lda #<(CcodeData + RAMcopylength)
     sta DF0LOW
     lda #(>(CcodeData + RAMcopylength)) & $0F
     sta DF0HI
     ldx #RAMcopylength-1
copy2fetcherloop
     lda RAMcopybegin,x
     sta DF0PUSH
     dex
     bpl copy2fetcherloop

     lda #255
     sta CALLFUNCTION

     ; copy modified data back (just need first 6 bytes, which is sprite sort data)
     ldx #256-19
copyfromfetcherloop
     lda DF0DATA
     sta RAMcopybegin+19,x
     inx
     bmi copyfromfetcherloop

     jsr kernel_setup
     sta WSYNC
     ldy #$80
     sty HMP0
     sty HMP1
     sty HMM0 
     sty HMM1
     sty HMBL

     ; run possible vblank bB code
     ifconst vblank_bB_code
         jsr vblank_bB_code
     endif

     jsr set_fetchers

     ldx #7
setloopfrac
     lda dffraclow,x
     sta DF0FRACLOW,x
     lda dffrachi,x
     sta DF0FRACHI,x
     dex
     bpl setloopfrac
     ; lda #255
     STx DF5FRACINC ; x=255 right now
     STx DF7FRACINC
     lda DF5FRACDATA ; priming read
     lda DF7FRACDATA ; priming read

     ldx SpriteGfxIndex
     lda _NUSIZ1,x ; top NUSIZ/REFP
     sta NUSIZ1
     sta REFP1

     ;REVENG - allow P0 to wrap at the top
startwrapfix
     lda #255
     sta temp2
     clc
     lda player0y
     adc player0height
     sec
     cmp player0height
     bcc skipwrapfix
     lda #0
     sta temp2
skipwrapfix

     sec
     lda #<P0GFX
     sbc player0y
     sta DF2LOW
     lda #>P0GFX
     ;sbc #0
     sbc temp2
     sta DF2HI
     lda #<(P0GFX-1)
     sta DF2TOP
     sec
     adc player0height
     sta DF2BOT

     ;REVENG - 1/2 of the COLUM0 fix. the rest is in main.c
     lda #<(P0COLOR)
     sta DF0LOW
     sta temp2
     lda #>(P0COLOR)
     sta DF0HI

     ; ball
     lda #<(P1GFX-1)
     clc
     adc bally
     sta DF3TOP
     sec
     adc ballheight
     sta DF3BOT

     ; missile0
     lda temp2
     clc
     adc missile0y
     sta DF0TOP
     sec
     adc missile0height
     sta DF0BOT


fuu
     lda INTIM
     bmi fuu
     sta WSYNC
;     ldy #$80
;     sty HMP0
;     sty HMP1
;     sty HMM0 
;     sty HMM1
;     sty HMBL
; relocated code above prior to vblank, to allow for Cosmic Ark starfield
; and/or skewed players
 sleep 17 

     lda #KERNEL_LINES
     sta TIM64T
     lda #1
     sta VDELBL
     sta VDELP0

     ; missile1
     lda #<(P1COLOR-1)
     clc
     adc missile1y
     sta DF1TOP
     sec
     adc missile1height
     sta DF1BOT

     lda #0
     sta VBLANK
     sta FASTFETCH
     ;sleep 7
     lda #<DF2DATAW         ; REVENG - added so GRP0 is at TOP
     STA GRP0 ; 36 (VDEL)   ; ""
     sleep 2                ; ""

     lda #<DF0FRACDATA
     sta PF1 ; (PF1L)

     ; enter at cycle ??
loop:
     lda #<DF0DATA ;74
     STA COLUP0 ; 1
     lda #<DF1DATA ;3
loop2
     STA COLUP1 ; 6
     lda #<DF3DATA
     STA GRP1 ; 11
     lda #<DF0FLAG
     STA ENAM0 ; 16

     lda #<DF6FRACDATA
     sta COLUBK ; 21
     lda #<DF4FRACDATA
     sta COLUPF ; 26
     lda #<DF1FRACDATA
     sta PF2 ; 31 (PF2L)
loop3
     lda #<DF2DATAW
     STA GRP0 ; 36 (VDEL)
     lda #<DF3FLAG
     STA ENABL ; 41 (VDEL)
     ldx #$70 ;in case we get kernel 6
     lda #<DF2FRACDATA ;45
     sta PF2 ; 48
     sty HMP1 ; 51 ; from prev. cycle: $80=nomove
     lda #<DF3FRACDATA ;53
     sta PF1 ; 56
     lda #<DF4DATA ; 58 this is the repos info
     beq repo ;60/61
norepo     ; 60
     tay ; 62
     lda #<DF0DATA ; 64

     ldx INTIM ; 68 timed for 192 lines
     beq exitkernel; 70/71
     sta HMOVE ; 73

     STA COLUP0 ; 0
     lda #<DF1DATA ;2
     STA COLUP1 ;5
     lda #<DF3DATA
     STA GRP1 ; 10
     lda #<DF1FLAG
     STA ENAM1 ; 15
     lda #<DF0FRACDATA
     sta PF1 ; 20 (PF1L)
     lda #<DF1FRACDATA
     sta PF2 ; 25 (PF2L)
     lda #<DF2DATAW
     STA GRP0 ; 30 (VDEL)
     lda #<DF3FLAG
     STA ENABL ; 35 (VDEL)
     dey ; 37
     STY DF4PUSH ; 41
     ldy #$80 ; 43 no movement next line
     lda #<DF2FRACDATA ;45
     sta PF2 ; 48
     sty HMP1 ; 51 ; from prev. cycle: $80=nomove
     lda #<DF3FRACDATA ;53
     sta PF1 ; 56
     ifnconst DPC_kernel_options
         ;sleep 8 ; REVENG - timing is off - results in a garbled screen
         sleep 5 ; this is better
     else
         bit DPC_kernel_options
         if (DPC_kernel_options > $3F)
             bmi COLfound
         else
             bpl COLfound
         endif
     endif
     stx temp4 ; +3

getbackearly
     lda #<DF0FRACDATA ; +2
     sta PF1 ; 69 (PF1L) too early?
     JMP loop+$4000 ; 72

     ifconst DPC_kernel_options
COLfound
         lda DF0FRACDATA
         sta PF1 ; 69 (PF1L) too early?
         JMP loop+$4000 ; 72
     endif

repo     
     ldy DF7FRACDATA ; 65
     lda #<DF0FRACDATA ; 67 preload PF1L for next line
     if ((>repo) > (>norepo))
         STA PF1
     else
         STA.w PF1 ; 71 ; sta.w if page doesn't wrap
     endif
     lda #<DF0DATA ;73
     STA COLUP0 ; 0
     lda #<DF1DATA 
     STA COLUP1 ;5
     lda #<DF3DATA
     STA GRP1 ; 10
     lda #<DF1FLAG
     STA ENAM1 ; 15
     ; repos info holds HMMx
     jmp (DF5DATA) ; 20 grabs df6/df7=lo/hi

exitkernel     ; exit the kernel
     jsr scorekernel+$4000 ; 1
exit
     ldx #255
     stx FASTFETCH
     sta WSYNC
     lda #2
     STA VBLANK
     lda #OVERSCAN_LINES
     sta TIM64T
     sec
     lda #KERNEL_LINES
     sbc temp4
     tax
     lsr
     lsr 
     sta temp3 ; div4
     lsr
     lsr
     sta temp2 ; div16
     lsr
     sta temp1 ; div32
     clc
     txa
     adc temp2
     adc temp1
     sec
     sbc temp3
     sta temp4 ; approx line of first pf coll
     RETURN

     ; jmp exit

     ; kernels resp1 23/28/33/38/43/48/53/58/63/68/73

kernel1
     sta RESP1 ; 23
     lda #<DF2DATAW
     STA GRP0 ; 28 (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 33
     lda #<DF3FLAG
     STA ENABL ; 38 (VDEL)
     sleep 5
     lda #<DF2FRACDATA ;45
     sta PF2 ; 48
     lda #<DF3FRACDATA ;50
     sta PF1 ; 53
     lda #<DF5FRACDATA ; NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1 ; 58
     STA REFP1 ; 61
     jmp getbackearly ;64

kernel2
     lda #<DF2DATAW
     STA GRP0 ; 25 (VDEL)
     sta RESP1 ;28
     lda #<DF1FRACDATA
     STA PF2 ; 33
     lda #<DF3FLAG
     STA ENABL ; 38 (VDEL)
     sleep 5
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     lda #<DF5FRACDATA ; NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1
     STA REFP1
     jmp getbackearly ;64

kernel3
     lda #<DF2DATAW
     STA GRP0 ; 25 (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 30
     sta RESP1 ;33
     lda #<DF3FLAG
     STA ENABL ; 38 (VDEL)
     sleep 5
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     lda #<DF5FRACDATA ; NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1
     STA REFP1
     JMP getbackearly ; 64

kernel4
     lda #<DF2DATAW
     STA GRP0 ; 25 (VDEL)
     lda #<DF3FLAG
     STA ENABL ; 30(VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     sta RESP1 ;38
     sleep 5
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     lda #<DF5FRACDATA ; NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1 ; 58
     STA REFP1 ; 61
     JMP getbackearly ; 64

kernel5
     lda #<DF2DATAW
     STA GRP0 ; (VDEL)
     lda #<DF3FLAG
     STA ENABL ; (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     sleep 5
     sta RESP1 ;43
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     lda #<DF5FRACDATA ; NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1
     STA REFP1
     JMP getbackearly ; 64

kernel6
     lda #<DF2DATAW
     STA GRP0 ; 25 (VDEL)
     lda #<DF3FLAG
     STA ENABL ; 30 (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     lda #<DF5FRACDATA ; 37 NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1 ; 40
     STA REFP1 ; 43
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta RESP1 ;53
     ; do a move right by 15
     sta PF1 ; 56
     stx HMP1 ; 59
     lda #<DF1FRACDATA
     sta PF2 ; 64 (PF2L)
     lda #<DF0FRACDATA
     sta PF1 ; 69 (PF1L) too early?
     lda #<DF0DATA ; 71
     sta HMOVE ; 74 adjust to +15 right

     STA COLUP0 ; 1
     lda #<DF1DATA
     sta COLUP1 ; 6
     lda #<DF3DATA
     STA GRP1 ; 11
     lda #<DF0FLAG
     STA ENAM0 ; 16
     lda #<DF6FRACDATA
     STA COLUBK ; 21
     lda #<DF4FRACDATA
     sta COLUPF ; 26
     sleep 2
     jmp loop3 ; 31

kernel7
     lda #<DF2DATAW
     STA GRP0 ; 25 (VDEL)
     lda #<DF3FLAG
     STA ENABL ; 30 (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     lda #<DF5FRACDATA ; 37 NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1 ; 40
     STA REFP1 ; 43
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     sleep 2
     sta RESP1 ;53
     lda #<DF3FRACDATA;55
     sta PF1 ; 58
     sleep 3
     JMP getbackearly ; 64

kernel8
     lda #<DF2DATAW
     STA GRP0 ; (VDEL)
     lda #<DF3FLAG
     STA ENABL ; (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     lda #<DF5FRACDATA ; 37 NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1 ; 40
     STA REFP1 ; 43
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     sleep 2
     sta RESP1 ;58
     sleep 3
     JMP getbackearly ; 64

kernel9
     lda #<DF2DATAW
     STA GRP0 ; (VDEL)
     lda #<DF3FLAG
     STA ENABL ; (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     lda #<DF5FRACDATA ; 37 NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1 ; 40
     STA REFP1 ; 43
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     sleep 5
     lda #<DF0FRACDATA
     sta RESP1 ;63
     sleep 3
     sta PF1 ; 69 (PF1L) too early?
     jmp loop ;72

kernel10
     lda #<DF2DATAW
     STA GRP0 ; 25 (VDEL)
     lda #<DF3FLAG
     STA ENABL ; 30 (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     lda #<DF5FRACDATA ; 37 NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1 ; 40
     STA REFP1 ; 43
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     sleep 6
     lda #<DF0FRACDATA
     LDX DF0DATA ; 65
     sta RESP1 ; 68
     STA PF1 ; 71
     lda #<DF1DATA ; 74
     STX COLUP0 ; 0
     jmp loop2 ; 3

kernel11
     lda #<DF2DATAW
     STA GRP0 ; (VDEL)
     lda #<DF3FLAG
     STA ENABL ; (VDEL)
     lda #<DF1FRACDATA
     STA PF2 ; 35
     lda #<DF5FRACDATA ; NUSIZ/RESP info (OK here, GRP1 off)
     STA NUSIZ1
     STA REFP1
     lda #<DF2FRACDATA;45
     sta PF2 ; 48
     lda #<DF3FRACDATA;50
     sta PF1 ; 53
     sleep 3
     lda #<DF1FRACDATA;45
     sta PF2 ; 61
     LDX DF0DATA ; 65

     lda #<DF0FRACDATA ; 67
     sta PF1 ; 70
     sta RESP1 ; 73
     STX COLUP0 ; 0
     lda #<DF1DATA ; 2
     sta COLUP1 ; 5
     lda #<DF3DATA
     STA GRP1 ; 10
     lda #<DF0FLAG
     STA ENAM0 ; 25
     lda #<DF6FRACDATA
     STA COLUBK ; 20
     lda #<DF4FRACDATA
     sta COLUPF ; 25
     sleep 3
     jmp loop3 ; 31

set_fetchers
     lda dflow
     sta DF0LOW
     lda dfhigh
     sta DF0HI

     lda dflow+1
     sta DF1LOW
     lda dfhigh+1
     sta DF1HI

     lda dflow+2
     sta DF2LOW
     lda dfhigh+2
     sta DF2HI

set_fetchers36 ; sets just 3-6
     lda dflow+3
     sta DF3LOW
     lda dfhigh+3
     sta DF3HI

     lda dflow+4
     sta DF4LOW
     lda dfhigh+4
     sta DF4HI

     lda dflow+5
     sta DF5LOW
     lda dfhigh+5
     sta DF5HI

     lda dflow+6
     sta DF6LOW
     lda dfhigh+6
     sta DF6HI

     rts

     ;9d bad
     ; the below isn't quite right
     ;DF0DATA: COLUP0
     ;DF1DATA: COLUP1
     ;DF2DATAW: GRP0
     ;DF3DATA: GRP1 
     ;DF4DATA: 2lk lines until repos/HMP1
     ;DF5DATA: low byte of repo kernels (xpos mod 15)
     ;DF6DATA: High byte of repo kernels (x pos div 15)
     ;DF7DATA: Programmer's stack
     ;DF0FRACDATA: PF1L
     ;DF1FRACDATA: PF2L
     ;DF4FRACDATA: COLUPF
     ;DF2FRACDATA: PF2R
     ;DF3FRACDATA: PF2L
     ;DF5FRACDATA: Sprite NUSIZ1/REFP1 (only during repos)
     ;DF6FRACDATA: COLUBK
     ;DF7FRACDATA: HMP1
     ;DF3FLAG: kernel exit loop ?? (use flags instead?)
     ;DF0FLAG: ENAM0
     ;DF1FLAG: ENAM1 
     ;DF3FLAG: ENABL 

fetcher_address_table
kernello
     .byte <kernel1
     .byte <kernel2
     .byte <kernel3
     .byte <kernel4
     .byte <kernel5
     .byte <kernel6
     .byte <kernel7
     .byte <kernel8
     .byte <kernel9
     .byte <kernel10
     .byte <kernel11
kernelhi
     .byte >kernel1
     .byte >kernel2
     .byte >kernel3
     .byte >kernel4
     .byte >kernel5
     .byte >kernel6
     .byte >kernel7
     .byte >kernel8
     .byte >kernel9
     .byte >kernel10
     .byte >kernel11
dflow     
     .byte <P0COLOR
     .byte <P1COLOR
     .byte <P0GFX
     .byte <P1GFX
     .byte <P1SKIP
     .byte <JUMPTABLELO
     .byte <JUMPTABLEHI
     .byte <USERSTACK
dfhigh
     .byte (>P0COLOR) & $0F
     .byte (>P1COLOR) & $0F
     .byte (>P0GFX) & $0F
     .byte (>P1GFX) & $0F
     .byte (>P1SKIP) & $0F
     .byte (>JUMPTABLELO) & $0F
     .byte (>JUMPTABLEHI) & $0F
     .byte (>USERSTACK) & $0F
dffraclow
     .byte <PF1L
     .byte <PF2L
     .byte <PF1R
     .byte <PF2R
     .byte <PFCOLS
     .byte <NUSIZREFP
     .byte <BKCOLS
     .byte <P1HMP
dffrachi
     .byte (>PF1L) & $0F
     .byte (>PF2L) & $0F
     .byte (>PF1R) & $0F
     .byte (>PF2R) & $0F
     .byte (>PFCOLS) & $0F
     .byte (>NUSIZREFP) & $0F 
     .byte (>BKCOLS) & $0F
     .byte (>P1HMP) & $0F
scorepointer
     .byte <scoretable
     .byte ((>scoretable) & $0f) | (((>scoretable) / 2) & $70)
scoresetup     ; pointers to digit graphics
     .byte <scoredata
     .byte (>scoredata) & $0F
Hmval; 112 wuz first
     .byte 96, 80, 64, 48, 32, 16, 1, 240
Hmval74
     .byte 224, 208, 192, 176, 160, 144, 128
     .byte 96, 80, 64, 48, 32, 16, 1, 240, 224, 208, 192, 176, 160, 144, 128, 96
     .byte 80, 64, 48, 32, 16, 1, 240, 224, 208, 192, 176, 160, 144, 128, 96, 80
     .byte 64, 48, 32, 16, 1, 240, 224, 208, 192, 176, 160, 144, 128, 96, 80, 64
     .byte 48, 32, 16, 1, 240, 224, 208, 192, 176, 160, 144, 128, 96, 80, 64, 48
     .byte 32, 16, 1, 240, 224, 208, 192, 176, 160, 144, 128, 96, 80, 64, 48, 32
     .byte 16, 1, 240, 224, 208, 192, 176, 160, 144, 128, 96, 80, 64, 48, 32, 16
     .byte 1, 240, 224, 208, 192, 176, 160, 144, 128, 96, 80, 64, 48, 32, 16, 1
     .byte 240, 224, 208, 192, 176, 160, 144, 128, 96, 80, 64, 48, 32, 16, 1, 240
     .byte 224, 208, 192, 176, 160, 144, 128, 96, 80, 64, 48, 32, 16, 1, 240, 224, 208, 192
     .byte 176,160,144,128,16,1,240,224
     

kernel_setup
     ;--position P0, top P1, M0, M1, BL
     ldx #0 ; first sprite displayed
     lda SpriteGfxIndex,x
     tax
     lda player1x,x
     cmp #160
     bcc nostorep1
     cmp #208
     bcs ksadjustdown
     ; 160-208: minus 160
     ;add 160 is like minus 96
     ; so minus 64
     sbc #63 ;cc
ksadjustdown
     ; 209-255: add 160 
     adc #159 ; cs
     sta player1x,x
nostorep1
     sta WSYNC
     ldx #4
     sta topP1x ; cache top p1
HorPosLoop
     lda player0x,X
     sec
DivideLoop
     sbc #15
     bcs DivideLoop
     sleep 4
     sta RESP0,X
     sta WSYNC
     dex ;2
     bpl HorPosLoop ;4/5

     ldy player0x ; 7
     lda Hmval,y ; 11
     sta HMP0 ; 14

     ldy player0x+1 
     lda Hmval,y
     sta HMP0+1 ; 24

     ldy player0x+2 
     lda Hmval,y
     sta HMP0+2 ; 34

     ldy player0x+3
     lda Hmval,y
     sta HMP0+3 ; 44

     ldy player0x+4 
     lda Hmval,y
     sta HMP0+4 ; 54

     sta WSYNC
     sta HMOVE

myrts
     rts


pfsetup     
     
     sty temp1 
     sta temp2
     stx temp3
     ldx #3
pfsetupp
     lda dffraclow,x
     sta DF0LOW,x
     lda dffrachi,x
     sta DF0HI,x 
     lda temp2
     sta PARAMETER
     lda temp3
     sta PARAMETER
     stx PARAMETER
     sty PARAMETER 
     LDA #1
     sta CALLFUNCTION
     clc
     lda temp2
     adc temp1
     sta temp2
     lda temp3
     adc #0
     sta temp3
     dex
     bpl pfsetupp
     RETURN


scorekernel
     ifconst minikernel
         ;; disable fast fetch, call the minikernel, and re-enable fast fetch
         lda #255
         sta FASTFETCH
         jsr minikernel
         lda #0
         sta.w FASTFETCH
     endif
     ldx scorecolor
     stx COLUP0
     stx COLUP1
     ldx #0
     STx PF1
     stx REFP0
     stx REFP1
     STx GRP0
     STx GRP1
     STx PF2
     stx HMCLR
     stx ENAM0
     stx ENAM1
     stx ENABL


     ifconst pfscore
         lda pfscorecolor
         sta COLUPF
     endif

     ifconst noscore
         ldx #10
noscoreloop
         sta WSYNC
         dex
         bpl noscoreloop
         rts
     else

     sta HMCLR
     ldx #$f0
     stx HMP0

     ; set up fetchers 0-5 to handle score digits
     ldx #<(scoredata)
     stx DF6LOW
     ldx #(>(scoredata)) & $0F
     stx DF6HI
     ldx #<(scoredata+8)
     stx DF0LOW
     ldx #(>(scoredata+8)) & $0F
     stx DF0HI
     ldx #<(scoredata+16)
     stx DF1LOW
     ; cycle 0??
     ldx #(>(scoredata+16)) & $0F
     stx DF1HI
     ldx #<(scoredata+24)
     stx DF2LOW
     ldx #(>(scoredata+24)) & $0F
     stx DF2HI

     sta WSYNC
     ldx #0
     STx GRP0
     STx GRP1 ; seems to be needed because of vdel

     ldx #<(scoredata+32)
     stx DF3LOW
     ldx #(>(scoredata+32)) & $0F
     stx DF3HI
     ldx #<(scoredata+40)
     stx DF4LOW
     ldx #(>(scoredata+40)) & $0F
     stx DF4HI

     LDY #7
     LDx #$03
     STY VDELP0
     STA RESP0
     STA RESP1
     sty temp1

     STx NUSIZ0
     STx NUSIZ1
     STx VDELP1
     ldx #<(scoredata+48)
     stx DF5LOW
     ldx #(>(scoredata+48)) & $0F
     stx DF5HI
     STA.w HMOVE ; cycle 73 ?
scoreloop
     lda #<DF6DATA ;59
     sta COLUP0 ;62
     sta COLUP1 ;65
     lda #<DF1DATA;75
     sta GRP0 ;2
     lda #<DF0DATA ;4
     sta GRP1 ;7
     lda #<DF3DATA ;9
     sta GRP0 ;12

     ; REVENG - rearranged to correct pf write timing and A register overwrite
     ifconst pfscore
         lda pfscore1
         sta PF1
     else
         sleep 6
     endif
     sleep 5 
     ldx DF2DATA;16
     ldy DF5DATA;20
     lda #<DF4DATA;22 

     stx GRP1;40
     sty GRP0;43
     sta GRP1;46
     sta GRP0;49
     ifconst pfscore
         lda pfscore2
         sta PF1
     else
         sleep 6
     endif
     ; sleep 2 ;57
     sleep 6
     dec temp1;70
     bpl scoreloop;72/73
     LDx #0 
     stx PF1
     STx GRP0
     STx GRP1
     STx VDELP0
     STx VDELP1;do we need these
     STx NUSIZ0
     STx NUSIZ1

     rts

     
     endif ; noscore
