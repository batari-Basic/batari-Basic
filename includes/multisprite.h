; Provided under the CC0 license. See the included LICENSE.txt for details.

missile0x = $80
missile1x = $81
ballx = $82

; multisprite stuff below - 5 bytes each starting with spritex

SpriteIndex = $83

player0x = $84
NewSpriteX = $85		;		X position
player1x = $85
player2x = $86
player3x = $87
player4x = $88
player5x = $89

objecty = $8A
missile0y = $8A
missile1y = $8B
bally = $8C

player0y = $8D
NewSpriteY = $8E			;		Y position
player1y = $8E
player2y = $8F
player3y = $90
player4y = $91
player5y = $92

NewNUSIZ = $93
_NUSIZ1 = $93
NUSIZ2 = $94
NUSIZ3 = $95
NUSIZ4 = $96
NUSIZ5 = $97

NewCOLUP1 = $98
_COLUP1 = $98
COLUP2 = $99
COLUP3 = $9A
COLUP4 = $9B
COLUP5 = $9C

SpriteGfxIndex = $9D

player0pointer = $A2
player0pointerlo = $A2
player0pointerhi = $A3

;P0Top = temp5
P0Top = $CF ; changed to hard value to avoid dasm issues
P0Bottom = $A4
P1Bottom = $A5

player1pointerlo = $A6
player2pointerlo = $A7
player3pointerlo = $A8
player4pointerlo = $A9
player5pointerlo = $AA

player1pointerhi = $AB
player2pointerhi = $AC
player3pointerhi = $AD
player4pointerhi = $AE
player5pointerhi = $AF

player0height = $B0
spriteheight = $B1 ; heights of multiplexed player sprite
player1height = $B1
player2height = $B2
player3height = $B3
player4height = $B4
player5height = $B5

PF1temp1 = $B6
PF1temp2 = $B7
PF2temp1 = $B8
PF2temp2 = $B9

pfpixelheight = $BA

; playfield is now a pointer to graphics
playfield = $BB
PF1pointer = $BB

PF2pointer = $BD

statusbarlength = $BF
aux3 = $BF

lifecolor = $C0
pfscorecolor = $C0
aux4 = $C0

;P1display = temp2 ; temp2 and temp3
P1display = $cc ; changed to hard value to avoid dasm issues
lifepointer = $c1
lives = $c2
pfscore1 = $c1
pfscore2 = $c2
aux5 = $c1
aux6 = $c2

playfieldpos = $C3

;RepoLine = temp4
RepoLine = $ce ; changed to hard value to avoid dasm issues

pfheight = $C4
scorepointers = $C5

temp1 = $CB ;used by kernel.  can be used in program too, but
temp2 = $CC ;are obliterated when drawscreen is called.
temp3 = $CD
temp4 = $CE
temp5 = $CF
temp6 = $D0
temp7 = $D1 ; This is used to aid in bankswitching

score = $D2
scorecolor = $D5 ;need to find other places for these, possibly...
rand = $D6



A = $d7
a = $d7
B = $d8
b = $d8
C = $d9
c = $d9
D = $da
d = $da
E = $db
e = $db
F = $dc
f = $dc
G = $dd
g = $dd
H = $de
h = $de
I = $df
i = $df
J = $e0
j = $e0
K = $e1
k = $e1
L = $e2
l = $e2
M = $e3
m = $e3
N = $e4
n = $e4
O = $e5
o = $e5
P = $e6
p = $e6
Q = $e7
q = $e7
R = $e8
r = $e8
S = $e9
s = $e9
T = $ea
t = $ea
U = $eb
u = $eb
V = $ec
v = $ec
W = $ed
w = $ed
X = $ee
x = $ee
Y = $ef
y = $ef
Z = $f0
z = $f0

spritesort = $f1 ; helps with flickersort
spritesort2 = $f2 ; helps with flickersort
spritesort3 = $f3
spritesort4 = $f4
spritesort5 = $f5

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
