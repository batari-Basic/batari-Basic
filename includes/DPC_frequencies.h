; Provided under the CC0 license. See the included LICENSE.txt for details.

; 1K Frequency Table.
; Fred Quimby, Darrell Spice Jr, Chris Walton 2010
;
; The 1K Frequency Table can contain up to 256 frequency values
;
; Table entries are defined as 2^32*freq/20000
;
; If User ARM code is being used, then the last 512 bytes of the frequency
; table will no longer be available, reducing the number of frequencies you can
; use to 128.

; piano key frequencies (s = sharp)

.freq_table_start

			DC.L 0
A0  = (* & $3ff)/4
			DC.L 5905580

A0s = (* & $3ff)/4
			DC.L 6256744

B0  = (* & $3ff)/4
			DC.L 6628789

C1  = (* & $3ff)/4
			DC.L 7022958

C1s = (* & $3ff)/4
			DC.L 7440565

D1  = (* & $3ff)/4
			DC.L 7883004

D1s = (* & $3ff)/4
			DC.L 8351751

E1  = (* & $3ff)/4
			DC.L 8848372

F1  = (* & $3ff)/4
			DC.L 9374524

F1s = (* & $3ff)/4
			DC.L 9931962

G1  = (* & $3ff)/4
			DC.L 10522547

G1s = (* & $3ff)/4
			DC.L 11148251

A1  = (* & $3ff)/4
			DC.L 11811160

A1s = (* & $3ff)/4
			DC.L 12513488

B1  = (* & $3ff)/4
			DC.L 13257579

C2  = (* & $3ff)/4
			DC.L 14045916

C2s = (* & $3ff)/4
			DC.L 14881129

D2  = (* & $3ff)/4
			DC.L 15766007

D2s = (* & $3ff)/4
			DC.L 16703503

E2  = (* & $3ff)/4
			DC.L 17696745

F2  = (* & $3ff)/4
			DC.L 18749048

F2s = (* & $3ff)/4
			DC.L 19863924

G2  = (* & $3ff)/4
			DC.L 21045095

G2s = (* & $3ff)/4
			DC.L 22296501

A2  = (* & $3ff)/4
			DC.L 23622320

A2s = (* & $3ff)/4
			DC.L 25026976

B2  = (* & $3ff)/4
			DC.L 26515158

C3  = (* & $3ff)/4
			DC.L 28091831

C3s = (* & $3ff)/4
			DC.L 29762258

D3  = (* & $3ff)/4
			DC.L 31532014

D3s = (* & $3ff)/4
			DC.L 33407005

E3  = (* & $3ff)/4
			DC.L 35393489

F3  = (* & $3ff)/4
			DC.L 37498096

F3s = (* & $3ff)/4
			DC.L 39727849

G3  = (* & $3ff)/4
			DC.L 42090189

G3s = (* & $3ff)/4
			DC.L 44593002

A3  = (* & $3ff)/4
			DC.L 47244640

A3s = (* & $3ff)/4
			DC.L 50053953

B3  = (* & $3ff)/4
			DC.L 53030316

C4  = (* & $3ff)/4
			DC.L 56183662

C4s = (* & $3ff)/4
			DC.L 59524517

D4  = (* & $3ff)/4
			DC.L 63064029

D4s = (* & $3ff)/4
			DC.L 66814011

E4  = (* & $3ff)/4
			DC.L 70786979

F4  = (* & $3ff)/4
			DC.L 74996192

F4s = (* & $3ff)/4
			DC.L 79455697

G4  = (* & $3ff)/4
			DC.L 84180379

G4s = (* & $3ff)/4
			DC.L 89186005

A4  = (* & $3ff)/4
			DC.L 94489281

A4s = (* & $3ff)/4
			DC.L 100107906

B4  = (* & $3ff)/4
			DC.L 106060631

C5  = (* & $3ff)/4
			DC.L 112367325

C5s = (* & $3ff)/4
			DC.L 119049034

D5  = (* & $3ff)/4
			DC.L 126128057

D5s = (* & $3ff)/4
			DC.L 133628022

E5  = (* & $3ff)/4
			DC.L 141573958

F5  = (* & $3ff)/4
			DC.L 149992383

F5s = (* & $3ff)/4
			DC.L 158911395

G5  = (* & $3ff)/4
			DC.L 168360758

G5s = (* & $3ff)/4
			DC.L 178372009

A5  = (* & $3ff)/4
			DC.L 188978561

A5s = (* & $3ff)/4
			DC.L 200215811

B5  = (* & $3ff)/4
			DC.L 212121263

C6  = (* & $3ff)/4
			DC.L 224734649

C6s = (* & $3ff)/4
			DC.L 238098067

D6  = (* & $3ff)/4
			DC.L 252256115

D6s = (* & $3ff)/4
			DC.L 267256044

E6  = (* & $3ff)/4
			DC.L 283147915

F6  = (* & $3ff)/4
			DC.L 299984767

F6s = (* & $3ff)/4
			DC.L 317822789

G6  = (* & $3ff)/4
			DC.L 336721516

G6s = (* & $3ff)/4
			DC.L 356744019

A6  = (* & $3ff)/4
			DC.L 377957122

A6s = (* & $3ff)/4
			DC.L 400431622

B6  = (* & $3ff)/4
			DC.L 424242525

C7  = (* & $3ff)/4
			DC.L 449469299

C7s = (* & $3ff)/4
			DC.L 476196134

D7  = (* & $3ff)/4
			DC.L 504512230

D7s = (* & $3ff)/4
			DC.L 534512088

E7  = (* & $3ff)/4
			DC.L 566295831

F7  = (* & $3ff)/4
			DC.L 599969533

F7s = (* & $3ff)/4
			DC.L 635645578

G7  = (* & $3ff)/4
			DC.L 673443031

G7s = (* & $3ff)/4
			DC.L 713488038

A7  = (* & $3ff)/4
			DC.L 755914244

A7s = (* & $3ff)/4
			DC.L 800863244

B7  = (* & $3ff)/4
			DC.L 848485051

C8  = (* & $3ff)/4
			DC.L 898938597

;values for 89-255 may go here

	if (* <= $1400)
	  ds ($1400-*) ; pad out remaining space in frequency table
	else
	  echo "FATAL ERROR - Frequency table exceeds 1K"
	  err
	endif
