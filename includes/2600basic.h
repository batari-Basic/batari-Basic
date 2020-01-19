; Provided under the CC0 license. See the included LICENSE.txt for details.

 processor 6502
 include "vcs.h"
 include "macro.h"
 include "2600basic_variable_redefs.h"

player0x = $80
player1x = $81
missile0x = $82
missile1x = $83
ballx = $84

objecty = $85
player0y = $85
player1y = $86
missile1height = $87
missile1y = $88
bally = $89

player1color = $87 ; replaces missile 1

player0pointer = $8A ;uses $8A-$8B
player0pointerlo = $8A
player0pointerhi = $8B
player1pointer = $8C ; $8C-$8D
player1pointerlo = $8C
player1pointerhi = $8D

player0height = $8E
player1height = $8F
missile0height = $90
missile0y = $91
ballheight = $92

currentpaddle = $90 ; replaces missile 0 (and can't be used with playercolor)
paddle = $91 ; replaces missile 0
player0colorstore = $82 ; replaces missile 0
player0color = $90 ; replaces missile 0

score = $93 ; $93-$95
scorepointers = $96 ; $96-$9B = 6 bytes
temp1 = $9C ;used by kernel.  can be used in program too, but
temp2 = $9D ;are obliterated when drawscreen is called.
temp3 = $9E
temp4 = $9F
temp5 = $A0
temp6 = $A1

rand = $A2
scorecolor = $A3

var0 = $A4
var1 = $A5
var2 = $A6
var3 = $A7
var4 = $A8
var5 = $A9
var6 = $AA
var7 = $AB
var8 = $AC
var9 = $AD
var10 = $AE
var11 = $AF
var12 = $B0
var13 = $B1
var14 = $B2
var15 = $B3
var16 = $B4
var17 = $B5
var18 = $B6
var19 = $B7
var20 = $B8
var21 = $B9
var22 = $BA
var23 = $BB
var24 = $BC
var25 = $BD
var26 = $BE
var27 = $BF
var28 = $C0
var29 = $C1
var30 = $C2
var31 = $C3
var32 = $C4
var33 = $C5
var34 = $C6
var35 = $C7
var36 = $C8
var37 = $C9
var38 = $CA
var39 = $CB
var40 = $CC
var41 = $CD
var42 = $CE
var43 = $CF
var44 = $D0
var45 = $D1
var46 = $D2
var47 = $D3

A = $d4
a = $d4
B = $d5
b = $d5
C = $d6
c = $d6
D = $d7
d = $d7
E = $d8
e = $d8
F = $d9
f = $d9
G = $da
g = $da
H = $db
h = $db
I = $dc
i = $dc
J = $dd
j = $dd
K = $de
k = $de
L = $df
l = $df
M = $e0
m = $e0
N = $e1
n = $e1
O = $e2
o = $e2
P = $e3
p = $e3
Q = $e4
q = $e4
R = $e5
r = $e5
S = $e6
s = $e6
T = $e7
t = $e7
U = $e8
u = $e8
V = $e9
v = $e9
W = $ea
w = $ea
X = $eb
x = $eb
Y = $ec
y = $ec
Z = $ed
z = $ed

temp7 = $ee ; This is used to aid in bankswitching
playfieldpos = $ef

; available for other uses, or if unused, provide more stack space

aux1 = $f0
aux2 = $f1
aux3 = $f2
aux4 = $f3
aux5 = $f4
aux6 = $f5

; playfield color/height pointers
pfcolortable = $f0 ; and $d5
pfheighttable = $f0 ; and $d5
; the above pointers are the same because if color and height are both used together,
; they must used absolute indexed and cannot use pointers

lifepointer = $f2 ; pointer to "lives" shape
; upper 3 bits of $f2 contain the number of lives
lifecolor = $f4
lives = $f3 ; # lives >> 5
statusbarlength = $f5 ; only uses upper 5 bits; other bits free

pfscore1 = $f2 ; optional playfield bytes in score
pfscore2 = $f3
pfscorecolor = $f4

stack1 = $f6
stack2 = $f7
stack3 = $f8
stack4 = $f9
; the stack bytes above may be used in the kernel
; stack = F6-F7, F8-F9, FA-FB, FC-FD, FE-FF

 MAC RETURN	; auto-return from either a regular or bankswitched module
   ifnconst bankswitch
     rts
   else
     jmp BS_return
   endif
 ENDM

 ifconst superchip
playfieldbase = $10D0
 include superchip.h
 else
playfieldbase = $A4
 endif

 ifnconst pfhalfwidth
pfwidth = 4
PF1L = PF1
PF2L = PF2
PF1R = PF1
PF2R = PF2
pfadjust = 0
 else
pfwidth = 2
   ifconst pfcenter
PF1L = $3F ; no effect
PF2L = PF2
PF1R = $3F
PF2R = PF2 ; no effect
pfadjust = 1
   else
PF1L = PF1
PF2L = PF2
PF1R = $3F ; no effect
PF2R = $3F ; no effect
pfadjust = 0
   endif
 endif

; define playfield start based on height
 ifnconst pfres
playfield = playfieldbase
 else
playfield = playfieldbase-(pfres-12*(4/pfwidth))*pfwidth
 endif
