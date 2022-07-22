; Provided under the CC0 license. See the included LICENSE.txt for details.

;----------------------------------------
; Display Data
;----------------------------------------
; The Display Data bank is copied into RAM when DPC+ initializes the cartridge.
; This allows us to manipulate the data during run-time, but have a known
; starting state when the Atari is first turned on.
;
; Unlike normal Atari VCS/2600 sprite definitions, the sprite data in the
; Display Data bank is stored right-side-up.
;
;----------------------------------------

Zeros32:
SOUND_OFF = (* & $1fff)/32
DisplayDataDigitBlank:
        .byte 0;--
        .byte 0;--
        .byte 0;--
        .byte 0;--
        .byte 0;--
        .byte 0;--
        .byte 0;--
        .byte 0;--

;	align 32
;Zeros32:
;SOUND_OFF = (* & $1fff)/32
;	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0

SINE_WAVE = (* & $1fff)/32
	.byte 3,3,3,4,4,5,5,5
	.byte 5,5,5,5,4,4,3,3
	.byte 3,2,2,1,1,0,0,0
	.byte 0,0,0,0,1,1,2,2

	align 32
TRIANGLE_WAVE = (* & $1fff)/32
	.byte 0,0,1,1,1,2,2,2
	.byte 3,3,3,4,4,4,5,5
	.byte 5,5,4,4,4,3,3,3
	.byte 2,2,2,1,1,1,0,0

 	align 32
SAWTOOTH_WAVE = (* & $1fff)/32
	.byte 0,0,0,0,1,1,1,1
	.byte 1,1,2,2,2,2,2,2
	.byte 3,3,3,3,3,3,4,4
	.byte 4,4,4,4,5,5,5,5

	align 32
SQUARE_WAVE_VOL5 = (* & $1fff)/32
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 5,5,5,5,5,5,5,5
	.byte 5,5,5,5,5,5,5,5

	align 32
SQUARE_WAVE_VOL4 = (* & $1fff)/32
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 4,4,4,4,4,4,4,4
	.byte 4,4,4,4,4,4,4,4

	align 32
SQUARE_WAVE_VOL3 = (* & $1fff)/32
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3

	align 32
NOISE_WAVE = (* & $1fff)/32
	.byte  7, 1, 9,10, 2, 8, 8,14
	.byte  3,13, 8, 5,12, 2, 3, 7
	.byte  7, 1, 8, 4,15, 1,13, 5
	.byte  8, 5,11, 6, 8, 7, 9, 2

; low and high byte of address table (for ROMdata array in C)
        .byte <fetcher_address_table
        .byte ((>fetcher_address_table) & $0f) | (((>fetcher_address_table) / 2) & $70)
 .byte 0
 .byte 0
FETCHER_BEGIN
 .byte 16
 .byte 16
 .byte 16
 .byte 16 ; to zero-fill on boot
