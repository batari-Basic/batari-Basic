; Provided under the CC0 license. See the included LICENSE.txt for details.

 processor 6502

 include "vcs.h"
 include "macro.h"
 include "DPCplus.h"
 include "PXEbB.h"
 include "2600basic_variable_redefs.h"

     ORG $0000
 incbin "PXE-pre.arm"

ROM_START = .

     ORG $0000 + ROM_START
     RORG $0000
     dc "PXE-ROM"

     ORG $0100 + ROM_START
     RORG $0100


    ; Store the addresses as uint16[] for the PXE kernel to use
    .byte <drawscreen
    .byte >drawscreen
    .byte <end_drawscreen
    .byte >end_drawscreen
    .byte <BKCOLS
    .byte >BKCOLS
    .byte <PFCOLS
    .byte >PFCOLS
    .byte <C_function
    .byte >C_function
    .byte <player0x
    .byte >player0x
    .byte <player0y
    .byte >player0y
    .byte <player0color
    .byte >player0color
    .byte <player0height
    .byte >player0height
    .byte <player0pointerhi
    .byte >player0pointerhi
    .byte <player0pointerlo
    .byte >player0pointerlo
    .byte <playerpointers
    .byte >playerpointers
    .byte <player1x
    .byte >player1x
    .byte <player1y
    .byte >player1y
    .byte <player1height
    .byte >player1height
    .byte <_NUSIZ1
    .byte >_NUSIZ1
    .byte <COLUM0
    .byte >COLUM0
    .byte <missile0x
    .byte >missile0x
    .byte <missile0y
    .byte >missile0y
    .byte <missile0height
    .byte >missile0height
    .byte <COLUM1
    .byte >COLUM1
    .byte <missile1x
    .byte >missile1x
    .byte <missile1y
    .byte >missile1y
    .byte <missile1height
    .byte >missile1height
    .byte <COLUBL
    .byte >COLUBL
    .byte <ballx
    .byte >ballx
    .byte <bally
    .byte >bally
    .byte <ballheight
    .byte >ballheight
    .byte <pfscorecolor
    .byte >pfscorecolor
    .byte <scoredata
    .byte >scoredata
    .byte <scoretable
    .byte >scoretable
    .byte <score
    .byte >score
    .byte <pfscore1
    .byte >pfscore1
    .byte <pfscore2
    .byte >pfscore2
    .byte <PF1L
    .byte >PF1L
    .byte <simple48
    .byte >simple48
    .byte <PaddleRange0
    .byte >PaddleRange0
    .byte <miniKernel0type
    .byte >miniKernel0type
    .byte <miniKernelCount
    .byte >miniKernelCount

    ; Initial NTSC Palette
     ORG $0600 + ROM_START
     RORG $0600
     HEX 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
     HEX 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f
     HEX 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
     HEX 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f
     HEX 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
     HEX 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
     HEX 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
     HEX 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f
     HEX 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
     HEX 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f
     HEX a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af
     HEX b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf
     HEX c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf
     HEX d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df
     HEX e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef
     HEX f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff

    ; Initial PAL Palette
     ORG $0700 + ROM_START
     RORG $0700
PALETTE ; the Initial NTSC or PAL palette is copied to this RAM location at boot time. It can be changed dynamically
     HEX 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
     HEX 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
     HEX 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
     HEX 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
     HEX 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
     HEX 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
     HEX c0 c1 c2 c3 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd
     HEX d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df
     HEX b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf
     HEX 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f
     HEX 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f
     HEX 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f
     HEX 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f
     HEX 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f
     HEX 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
     HEX 41 42 43 44 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f

     ORG $0800 + ROM_START
     RORG $0800

    ; c: Playfield Colors Control
    ;   0: Playfield Colors has its own PF_FRAC_INC, PF_WRITE_OFFSET, and PF_VER_SCROLL
    ;   1: fov settings are applied to playfield colors
    ;
    ; b: Background Colors Control
    ;   0: Background Colors has its own PF_FRAC_INC, PF_WRITE_OFFSET, and PF_VER_SCROLL
    ;   1: fov settings are applied to background colors
    ;
    ; f: Fractional Increment Control
    ;   0: Each playfield column has its own PF_FRAC_INC
    ;   1: PF_FRAC_INC_0 is applied to all columns
    ;
    ; o: Write Offset Control
    ;   0: Each playfield column has its own PF_WRITE_OFFSET
    ;   1: PF_WRITE_OFFSET_0 is applied to all columns
    ;
    ; v: Vertical Scroll Control
    ;   0: Each playfield column has its own PF_VER_SCROLL
    ;   1: PF_VER_SCROLL_0 is applied to all columns
    ;
    ; p: PFSCROLL mode
    ;   0: Scroll resolution matches FRACINC registers and pfscroll changes write offsets,
    ;   1-Fine grain. -128 to +127 scanlines
    ;
    ; ww: PF width. How many PF columns wide to scroll through horizontally. Each PF column is 8 PF pixels wide (32 pixels)
    ;   0: 4 columns with sides set to PF0. No horizontal scrolling. Primarily for backwards compatability with DPC+ kernel.
    ;   1: 5 columns. 160 (40 PF) Pixels wide. 
    ;   2: 10 columns. 320 (80 PF) Pixels wide.
    ;   3: 15 columns. 480 (120 PF) Pixels wide.
PF_MODE ; cbfo vpww
    .byte $00

    ; 0-14 Which playfield column write operations will start with 
    ; when writing multiple columns the operation will wrap back to column 0 after column 14
PF_WRITE_INDEX 
    .byte $00

    ; Horizontal scroll position in pixels. I.E. 16 would move Playfield 4 PF pixels left.
PF_HOR_SCROLL_LO
    .byte $00
PF_HOR_SCROLL_HI
    .byte $00

PF_FRAC_INC
PF_FRAC_INC_0
    .byte 00
PF_WRITE_OFFSET ; 0-255 where to start writing in each 256 byte column buffer. Writing past the end will wrap back to 0 automatically
PF_WRITE_OFFSET_0
    .byte $00
PF_VER_SCROLL_LO
PF_VER_SCROLL_LO_0
    .byte $00
PF_VER_SCROLL_HI
PF_VER_SCROLL_HI_0
    .byte $00

PF_FRAC_INC_1
    .byte 00
PF_WRITE_OFFSET_1
    .byte $00
PF_VER_SCROLL_LO_1
    .byte $00
PF_VER_SCROLL_HI_1
    .byte $00

PF_FRAC_INC_2
    .byte 00
PF_WRITE_OFFSET_2
    .byte $00
PF_VER_SCROLL_LO_2
    .byte $00
PF_VER_SCROLL_HI_2
    .byte $00

PF_FRAC_INC_3
    .byte 00
PF_WRITE_OFFSET_3
    .byte $00
PF_VER_SCROLL_LO_3
    .byte $00
PF_VER_SCROLL_HI_3
    .byte $00

PF_FRAC_INC_4
    .byte 00
PF_WRITE_OFFSET_4
    .byte $00
PF_VER_SCROLL_LO_4
    .byte $00
PF_VER_SCROLL_HI_4
    .byte $00

PF_FRAC_INC_5
    .byte 00
PF_WRITE_OFFSET_5
    .byte $00
PF_VER_SCROLL_LO_5
    .byte $00
PF_VER_SCROLL_HI_5
    .byte $00

PF_FRAC_INC_6
    .byte 00
PF_WRITE_OFFSET_6
    .byte $00
PF_VER_SCROLL_LO_6
    .byte $00
PF_VER_SCROLL_HI_6
    .byte $00

PF_FRAC_INC_7
    .byte 00
PF_WRITE_OFFSET_7
    .byte $00
PF_VER_SCROLL_LO_7
    .byte $00
PF_VER_SCROLL_HI_7
    .byte $00

PF_FRAC_INC_8
    .byte 00
PF_WRITE_OFFSET_8
    .byte $00
PF_VER_SCROLL_LO_8
    .byte $00
PF_VER_SCROLL_HI_8
    .byte $00

PF_FRAC_INC_9
    .byte 00
PF_WRITE_OFFSET_9
    .byte $00
PF_VER_SCROLL_LO_9
    .byte $00
PF_VER_SCROLL_HI_9
    .byte $00

PF_FRAC_INC_10
    .byte 00
PF_WRITE_OFFSET_10
    .byte $00
PF_VER_SCROLL_LO_10
    .byte $00
PF_VER_SCROLL_HI_10
    .byte $00

PF_FRAC_INC_11
    .byte 00
PF_WRITE_OFFSET_11
    .byte $00
PF_VER_SCROLL_LO_11
    .byte $00
PF_VER_SCROLL_HI_11
    .byte $00

PF_FRAC_INC_12
    .byte 00
PF_WRITE_OFFSET_12
    .byte $00
PF_VER_SCROLL_LO_12
    .byte $00
PF_VER_SCROLL_HI_12
    .byte $00

PF_FRAC_INC_13
    .byte 00
PF_WRITE_OFFSET_13
    .byte $00
PF_VER_SCROLL_LO_13
    .byte $00
PF_VER_SCROLL_HI_13
    .byte $00

PF_FRAC_INC_14
    .byte 00
PF_WRITE_OFFSET_14
    .byte $00
PF_VER_SCROLL_LO_14
    .byte $00
PF_VER_SCROLL_HI_14
    .byte $00

PF_FRAC_INC_PFCOL
    .byte 00
PF_WRITE_OFFSET_PFCOL
    .byte $00
PF_VER_SCROLL_LO_PFCOL
    .byte $00
PF_VER_SCROLL_HI_PFCOL
    .byte $00

PF_FRAC_INC_BKCOL
    .byte 00
PF_WRITE_OFFSET_BKCOL
    .byte $00
PF_VER_SCROLL_LO_BKCOL
    .byte $00
PF_VER_SCROLL_HI_BKCOL
    .byte $00

; Simple 48 Pixel Mode
simple48 .byte 0 ; 0-Normal Multisprite kernel lines 0-179, 1-48 Pixel Sprite using backgroundcolor, playfieldcolor, and playfield data

; PaddleRange set to 0 to disable, paddle value will be converted into a number between 0 and range inclusive.
; Only 0 and 1 currently supported
PaddleRange0:
    .byte 00
PaddleRange1:
    .byte 00
PaddleRange2:
    .byte 00
PaddleRange3:
    .byte 00

; MiniKernels

miniKernelCount .byte 0

; Types
mkMultiSprite = 0   ; player0Height graphicLo graphicHi colorLo colorHi nusiz0 player0x player0y
mkScore = 1 ; paddingTop barLeft barRight digitsLeft digitsMiddle digitsRight colubk colupf   
mk48Pixel = 2 ; paddingTop graphicLo graphicHi colorLo colorHi index graphicHeight
     
miniKernelId SET 0
 REPEAT 24
miniKernel,miniKernelId,"type" .byte 0
miniKernel,miniKernelId,"height"   .byte 0
  ; arg 0
miniKernel,miniKernelId,"paddingTop"
miniKernel,miniKernelId,"player0Height" .byte 0
  ; arg 1
miniKernel,miniKernelId,"graphicLo"
miniKernel,miniKernelId,"barLeft" .byte 0
  ; arg 2
miniKernel,miniKernelId,"graphicHi"
miniKernel,miniKernelId,"barRight" .byte 0
  ; arg3
miniKernel,miniKernelId,"colorLo"
miniKernel,miniKernelId,"digitsLeft" .byte 0
  ; arg 4
miniKernel,miniKernelId,"colorHi"
miniKernel,miniKernelId,"digitsMiddle" .byte 0
  ; arg 5
miniKernel,miniKernelId,"nusiz0"
miniKernel,miniKernelId,"index"
miniKernel,miniKernelId,"digitsRight" .byte 0
  ; arg 6
miniKernel,miniKernelId,"player0x"
miniKernel,miniKernelId,"graphicHeight"
miniKernel,miniKernelId,"colubk" .byte 0
  ; arg 7
miniKernel,miniKernelId,"player0y"
miniKernel,miniKernelId,"colupf" .byte 0

miniKernelId SET miniKernelId+1
 REPEND     


     ORG $1080 + ROM_START
     RORG $1080
