; Provided under the CC0 license. See the included LICENSE.txt for details.

; DPCplus.H - Display Processor Chip Plus Definitions
; Chris Walton, Fred Quimby, Darrell Spice 2010
; Version 0.00

; DPC Base Address
  IFNCONST DPC_BASE_ADDRESS
DPC_BASE_ADDRESS = $1000
  ENDIF

; DPC Read Base
  IFNCONST DPC_BASE_READ_ADDRESS
DPC_BASE_READ_ADDRESS = DPC_BASE_ADDRESS
  ENDIF

; DPC Write Base
  IFNCONST DPC_BASE_WRITE_ADDRESS
DPC_BASE_WRITE_ADDRESS = DPC_BASE_ADDRESS+$28
  ENDIF

  SEG.U DPC_REGISTERS_READ
  ORG DPC_BASE_READ_ADDRESS

;****************************************
; DPC+ Read Registers
;****************************************
;
;----------------------------------------
; Random Numbers
;----------------------------------------
; DPC+ provides a 32 bit LFSR (Linear feedback shift register)
; which is used as a random number generator.  Each individual byte of the
; random number will return values from 0-255.  The random numbers will follow
; an exact sequence, so it's best to clock them at least once per frame even if
; you don't need the value (this allows the amount of time it takes the user to
; start the game to select a random starting point in the sequence)
;----------------------------------------
RANDOM0NEXT   DS 1    ; $00 clock next 32 bit number and returns byte 0
RANDOM0PRIOR  DS 1    ; $01 clock prior 32 bit number and returns byte 0
RANDOM1       DS 1    ; $02 returns byte 1 of random number w/out clock
RANDOM2       DS 1    ; $03 returns byte 2 of random number w/out clock
RANDOM3       DS 1    ; $04 returns byte 3 of random number w/out clock

;----------------------------------------
; Music Fetcher
;----------------------------------------
; When generating music, this value must be read every single scanline and
; stored into AUDV0.
;----------------------------------------
AMPLITUDE     DS 1    ; $05

;----------------------------------------
; Reserved
;----------------------------------------
              DS 1    ; $06
              DS 1    ; $07

;----------------------------------------
; Data Fetcher
;----------------------------------------
; There are 8 Data Fetchers which are used to access data stored in the Display
; Data bank.  Before using, you must point the Data Fetcher at the data to read
; via DFxLOW and DFxHI.  After each read the Data Fetcher will update to point
; to the next byte of data to return.
;
; psuedo code* to point Data Fetcher 1 to the color data
;	lda #<(ColorDataPosition - HowFarDownScreen)
;	sta DF1LOW
;	lda #>(ColorDataPosition - HowFarDownScreen)
;	sta DF1HI
;	....
; then in the kernel read the Data Fetcher and update the color, takes 7 cycles
;	LDA DF1DATA
;	STA COLUP0
;
; * see DPCplus.asm for actual code
;----------------------------------------
DF0DATA       DS 1    ; $08
DF1DATA       DS 1    ; $09
DF2DATA       DS 1    ; $0A
DF3DATA       DS 1    ; $0B
DF4DATA       DS 1    ; $0C
DF5DATA       DS 1    ; $0D
DF6DATA       DS 1    ; $0E
DF7DATA       DS 1    ; $0F

;----------------------------------------
; Data Fetcher, Windowed
;----------------------------------------
; The 8 Data Fetchers can also be read in a "windowed" mode, which is most
; commonly used to update sprites.  To use windowed mode, point the Data
; Fetcher the same as above, but then also set the Top and Bottom of the
; Window using DFxTOP and DFxBOT.  When reading via the DFxDATAW registers, a 0
; value will be returned for anything that's outside of the window.
;
; psuedo code to point Data Fetcher0 to the sprite data
;	lda #<(SpriteDataPosition - HowFarDownScreen)
;	sta DF0LOW
;	lda #>(SpriteDataPosition - HowFarDownScreen)
;	sta DF0HI
;
; set the window for Data Fetcher 0
;	lda #<(SpriteDataPosition - 1)
;	sta DF0TOP
;	lda #<(SpriteDataPosition + ImageHeight)
;	sta DF0BOT
;	....
; then in the kernel read the Data Fetcher and update the sprite, takes 7 cycles
;	LDA DF0DATAW
;	STA GRP0
;----------------------------------------
DF0DATAW      DS 1    ; $10
DF1DATAW      DS 1    ; $11
DF2DATAW      DS 1    ; $12
DF3DATAW      DS 1    ; $13
DF4DATAW      DS 1    ; $14
DF5DATAW      DS 1    ; $15
DF6DATAW      DS 1    ; $16
DF7DATAW      DS 1    ; $17

;----------------------------------------
; Fractional Data Fetcher
;----------------------------------------
; Another 8 Data Fetchers exist which work differently than the first 8.
; These allow you to fractionally increment the Data Fetcher so a single
; value can be read a set number of times before advancing to the next value.
; This is commonly used to draw asymmetrical playfields without needing to
; use 1200 bytes of data (200 scanlines * 6 playfield updates).
; Before using, you must point the Fractional Data Fetcher at the data to read
; via DFxFRACLOW and DFxFRACHI.  You must also set the increment value via
; DFxFRACINC.
;
; Set pointer
;	LDA #<PlayfieldPF0l
;	STA DF0FRACLOW
;	... repeat for PF1l, PF2l, PF0r, PF1r and PF2r
;	lda #>PlayFieldPF0l
;	STA DF0FRACHI
;	... repeat for PF1l, PF2l, PF0r, PF1r and PF2r
; Set the increment to repeat the value for x reads
;	LDA #(256/x)
;	STA DF0FRACINC
;       STA DF1FRACINC
;	... repeat for 2-5
;
; Special Condition - IF you want to increment the pointer after every read
; (just like the normal Data Fetcher), then use the following to set the
; increment AND prime the Fractional Data Fetcher
;	LDA #255
;	STA DF0FRACINC
;       STA DF1FRACINC
;	... repeat for 2-5
;	LDA DF0FRACDATA - priming read (first value will be read twice)
;	LDA DF1FRACDATA - priming read (first value will be read twice)
;	... repeat for 2-5
;
; then in the kernel read the Fractional Data Fetchers and update the playfield
;	LDA DF0FRACDATA
;	STA PF0
;	LDA PF1FRACDATA
;	STA PF1
;	... repeat for Data Fetchers 2-5, putting them in PF2, PF0, PF1 and PF2
;----------------------------------------
DF0FRACDATA   DS 1    ; $18
DF1FRACDATA   DS 1    ; $19
DF2FRACDATA   DS 1    ; $1A
DF3FRACDATA   DS 1    ; $1B
DF4FRACDATA   DS 1    ; $1C
DF5FRACDATA   DS 1    ; $1D
DF6FRACDATA   DS 1    ; $1E
DF7FRACDATA   DS 1    ; $1F

;----------------------------------------
; Data Fetcher Window Flag
;----------------------------------------
; The Data Fetcher Window Flag allows you to dual-purpose the first four
; Data Fetchers.  The Window is not required when a Data Fetcher is used to
; update a sprite's color.  The Flag will return $FF if it's within the window,
; or 0 if it's not - this value can be used to control the display of the ball
; and missiles. The Data Fetcher will NOT increment when reading the flag.
;
; psuedo code to point Data Fetcher 1 to the color data
;	lda #<(ColorDataPosition - HowFarDownScreen)
;	sta DF1LOW
;	lda #>(ColorDataPosition - HowFarDownScreen)
;	sta DF1HI
;
; set the window based on the missile's Y position and height (number of
; scanlines to draw missile on)
;	lda #<(ColorDataPosition + MissileYposition - 1)
;	sta DF1TOP
;	lda #<(ColorDataPosition + MissileYposition + MissileHeight)
;	sta DF1BOT
;
; then in the kernel read the Data Fetcher and update the color, then read the
; flag and update the missile
;	LDA DF1DATA
;	STA COLUP0
;	LDA DF1FLAG
;	STA ENAM0
;----------------------------------------
DF0FLAG       DS 1    ; $20
DF1FLAG       DS 1    ; $21
DF2FLAG       DS 1    ; $22
DF3FLAG       DS 1    ; $23

;----------------------------------------
; Reserved
;----------------------------------------
              DS 1    ; $24
              DS 1    ; $25
              DS 1    ; $26
              DS 1    ; $27


  SEG.U DPC_REGISTERS_WRITE
  ORG DPC_BASE_WRITE_ADDRESS

;****************************************
; SECTION 2 - DPC+ Write Registers
;****************************************
;
;----------------------------------------
; Fractional Data Fetcher, Low Pointer
;----------------------------------------
; These are used in conjunction with DFxFRACHI to point a Fractional Data
; Fetcher to the data to read.  For usage, see "Fractional Data Fetcher"
; in SECTION 1.
;----------------------------------------
DF0FRACLOW    DS 1    ; $28
DF1FRACLOW    DS 1    ; $29
DF2FRACLOW    DS 1    ; $2A
DF3FRACLOW    DS 1    ; $2B
DF4FRACLOW    DS 1    ; $2C
DF5FRACLOW    DS 1    ; $2D
DF6FRACLOW    DS 1    ; $2E
DF7FRACLOW    DS 1    ; $2F

;----------------------------------------
; Fractional Data Fetcher, High Pointer
;----------------------------------------
; These are used in conjunction with DFxFRACLOW to point a Fractional Data
; Fetcher to the data to read.  For usage, see "Fractional Data Fetcher"
; in SECTION 1.
;
; NOTE: for only the lower 4 bits are used.
;----------------------------------------
DF0FRACHI     DS 1    ; $30
DF1FRACHI     DS 1    ; $31
DF2FRACHI     DS 1    ; $32
DF3FRACHI     DS 1    ; $33
DF4FRACHI     DS 1    ; $34
DF5FRACHI     DS 1    ; $35
DF6FRACHI     DS 1    ; $36
DF7FRACHI     DS 1    ; $37

;----------------------------------------
; Fractional Data Fetcher, Increment
;----------------------------------------
; These are used to set the increment amount for the Fractional Data Fetcher.
; To increment pointer after every Xth read use int(256/X)
; For usage, see "Fractional Data Fetcher" in SECTION 1.
;----------------------------------------
DF0FRACINC    DS 1    ; $38
DF1FRACINC    DS 1    ; $39
DF2FRACINC    DS 1    ; $3A
DF3FRACINC    DS 1    ; $3B
DF4FRACINC    DS 1    ; $3C
DF5FRACINC    DS 1    ; $3D
DF6FRACINC    DS 1    ; $3E
DF7FRACINC    DS 1    ; $3F

;----------------------------------------
; Data Fetcher, Window Top
;----------------------------------------
; These are used with DFxBOT to define the Data Fetcher Window
; For usage, see "Data Fetcher, Windowed" in SECTION 1.
;----------------------------------------
DF0TOP        DS 1    ; $40
DF1TOP        DS 1    ; $41
DF2TOP        DS 1    ; $42
DF3TOP        DS 1    ; $43
DF4TOP        DS 1    ; $44
DF5TOP        DS 1    ; $45
DF6TOP        DS 1    ; $46
DF7TOP        DS 1    ; $47

;----------------------------------------
; Data Fetcher, Window Bottom
;----------------------------------------
; These are used with DFxTOP to define the Data Fetcher Window
; For usage, see "Data Fetcher, Windowed" in SECTION 1.
;----------------------------------------
DF0BOT        DS 1    ; $48
DF1BOT        DS 1    ; $49
DF2BOT        DS 1    ; $4A
DF3BOT        DS 1    ; $4B
DF4BOT        DS 1    ; $4C
DF5BOT        DS 1    ; $4D
DF6BOT        DS 1    ; $4E
DF7BOT        DS 1    ; $4F

;----------------------------------------
; Data Fetcher, Low Pointer
;----------------------------------------
; These are used in conjunction with DFxHI to point a Data Fetcher to the data
; to read.  For usage, see "Data Fetcher" in SECTION 1.
;----------------------------------------
DF0LOW        DS 1    ; $50
DF1LOW        DS 1    ; $51
DF2LOW        DS 1    ; $52
DF3LOW        DS 1    ; $53
DF4LOW        DS 1    ; $54
DF5LOW        DS 1    ; $55
DF6LOW        DS 1    ; $56
DF7LOW        DS 1    ; $57

;----------------------------------------
; Fast Fetch Mode
;----------------------------------------
; Fast Fetch Mode enables the fastest way to read DPC+ registers.  Normal
; reads use LDA Absolute addressing (LDA DF0DATA) which takes 4 cycles to
; process.  Fast Fetch Mode intercepts LDA Immediate addressing (LDA #<DF0DATA)
; which takes only 2 cycles!  Only immediate values < $28 are intercepted
;
; set Fast Fetch Mode
;	LDA #0
;	STA FASTFETCH
;
; then use immediate mode to read the registers, takes just 5 cycles to update
; any TIA register
;
;	LDA #<DF0DATA
;	STA GRP0
;
; when done, turn off Fast Fetch Mode using any non-zero value
;	LDA #$FF
;	STA FASTFETCH
;
; NOTE: if you forget to turn off FASTFETCH mode, then code like this will not
;       work as you expect
;	LDA #0	; returns a RANDOM NUMBER, not 0.
;	STA COLUPF
;----------------------------------------
FASTFETCH     DS 1    ; $58

;----------------------------------------
; Function Support
;----------------------------------------
; Currently only Function 255 is defined, and it is used to call user
; written ARM routines (or C code compiled for the ARM processor.)
;
; PARAMETER is not used by function 255, it may be used by future functions.
;
; call custom ARM routine
;	LDA #$FF
;	STA CALLFUNCTION
;
; A custom ARM demo will be released in the near future
;----------------------------------------
PARAMETER     DS 1    ; $59
CALLFUNCTION  DS 1    ; $5A

;----------------------------------------
; Reserved
;----------------------------------------
              DS 1    ; $5B   ; reserved
              DS 1    ; $5C   ; reserved

;----------------------------------------
; Waveforms
;----------------------------------------
; Waveforms are 32 byte tables that define a waveform.  Waveforms must be 32
; byte aligned, and can only be stored in the 4K Display Data Bank. You MUST
; define an "OFF" waveform,  comprised of all zeros.  The sum of all waveforms
; being played should be <= 15, so typically you'll use a maximum of 5 for any
; given value.
;
; Valid values are 0-127 and point to the 4K Display Data bank.  The formula
; (* & $1fff)/32 as shown below will calculate the value for you
;
;
; example waveforms
;	align 32		; forces the waveform to a 32 byte boundary
;SOUND_OFF = (* & $1fff)/32	; calculates waveform pointer
;	.byte 0,0,0,0,0,0,0,0
;	.byte 0,0,0,0,0,0,0,0
;	.byte 0,0,0,0,0,0,0,0
;	.byte 0,0,0,0,0,0,0,0
;
;	align 32
;SINE_WAVE = (* & $1fff)/32
;	.byte 3,3,3,4,4,5,5,5
;	.byte 5,5,5,5,4,4,3,3
;	.byte 3,2,2,1,1,0,0,0
;	.byte 0,0,0,0,1,1,2,2
;
; usage, set voice 0 to Sine Wave, set voice 1 & 2 off
;	LDA #SINE_WAVE
;	STA WAVEFORM0
;	LDA #SOUND_OFF
;	STA WAVEFORM1
;	STA WAVEFORM2
;----------------------------------------
WAVEFORM0     DS 1    ; $5D
WAVEFORM1     DS 1    ; $5E
WAVEFORM2     DS 1    ; $5F

;----------------------------------------
; Data Fetcher Push (stack)
;----------------------------------------
; The Data Fetchers can also be used to update the contents of the 4K
; Display Data bank.  Point the Data Fetcher to the data to change,
; then Push to it.  The Data Fetcher's pointer will be decremented BEFORE
; the data is written.
;
; point Data Fetcher 1 to the sprite data
;	lda #<DisplayData
;	sta DF1LOW
;	lda #>DisplayData
;	sta DF1HI
;
; then update it
;	LDA #$FF
;	STA DF1PUSH ; changes data at DisplayData - 1
;	LDA #$81
;	STA DF1OUSH ; changes data at DisplayData - 2
;----------------------------------------
DF0PUSH       DS 1    ; $60
DF1PUSH       DS 1    ; $61
DF2PUSH       DS 1    ; $62
DF3PUSH       DS 1    ; $63
DF4PUSH       DS 1    ; $64
DF5PUSH       DS 1    ; $65
DF6PUSH       DS 1    ; $66
DF7PUSH       DS 1    ; $67

;----------------------------------------
; Data Fetcher, High Pointer
;----------------------------------------
; These are used in conjunction with DFxLOW to point a Data Fetcher to the data
; to read.  For usage, see "Data Fetcher" in SECTION 1.
;----------------------------------------
DF0HI         DS 1    ; $68
DF1HI         DS 1    ; $69
DF2HI         DS 1    ; $6A
DF3HI         DS 1    ; $6B
DF4HI         DS 1    ; $6C
DF5HI         DS 1    ; $6D
DF6HI         DS 1    ; $6E
DF7HI         DS 1    ; $6F

;----------------------------------------
; Random Number Initialization
;----------------------------------------
; The random number generate defaults to a value that spells out DPC+.
; Store any value to RRESET to set the random number back to DPC+, or you
; can use RWRITE0-3 to change the 32 bit value to anything you desire.
;
; reset random number
;	LDA #0
;	STA RRESET
;
; set a specific random number (spells out 2600)
;	LDA #$32
;	STA RWRITE0
;	LDA #$36
;	STA RWRITE1
;	LDA #$30
;	STA RWRITE2
;	STA RWRITE3
;
; NOTE: do not set all 4 bytes to 0, as that will disable the generator.
;----------------------------------------
RRESET        DS 1    ; $70
RWRITE0       DS 1    ; $71
RWRITE1       DS 1    ; $72
RWRITE2       DS 1    ; $73
RWRITE3       DS 1    ; $74

;----------------------------------------
; Notes
;----------------------------------------
; These are used to select a value from the frequency table to play.
; The default table, store in DPC_frequencies.h, only defines frequencies
; for 1-88, which cover the keys of a piano.  You are free to add additional
; frequencies from 88-255.  Piano keys are defined at the end of this file
;
; set voice 0 to middle C
;	LDA #C4
;	STA NOTE0
;
; Note: if you are using ARM USER CODE then you can only use notes to 128.
;----------------------------------------
NOTE0         DS 1    ; $75
NOTE1         DS 1    ; $76
NOTE2         DS 1    ; $77

;----------------------------------------
; Data Fetcher Write (queue)
;----------------------------------------
; The Data Fetchers can also be used to update the contents of the 4K
; Display Data bank.  Point the Data Fetcher to the data to change,
; then Write to it  The Data Fetcher's pointer will be incremented AFTER
; the data is written.
;
; point Data Fetcher 1 to the sprite data
;	lda #<SpriteData
;	sta DF1LOW
;	lda #>SpriteData
;	sta DF1HI
;
; then update it
;	LDA #$FF
;	STA DF1WRITE ; changes data at SpriteData
;	LDA #$81
;	STA DF1WRITE ; changes data at SpriteData + 1
;----------------------------------------
DF0WRITE      DS 1    ; $78
DF1WRITE      DS 1    ; $79
DF2WRITE      DS 1    ; $7A
DF3WRITE      DS 1    ; $7B
DF4WRITE      DS 1    ; $7C
DF5WRITE      DS 1    ; $7D
DF6WRITE      DS 1    ; $7E
DF7WRITE      DS 1    ; $7F

;-------------------------------------------------------------------------------
; The following required for back-compatibility with code which does not use
; segments.

            SEG
