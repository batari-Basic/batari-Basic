; Provided under the CC0 license. See the included LICENSE.txt for details.

 SEG.U vars
 org $30
player0x ds 1
topP1x ds 1
missile0x ds 1
missile1x ds 1
ballx ds 1

SpriteGfxIndex ds 9

spritedisplay ds 1

player0xcoll ds 1; to detect p0x colls
NewSpriteX ds 1	;		X position
player1x = NewSpriteX
player2x ds 1
player3x ds 1
player4x ds 1
player5x ds 1
player6x ds 1
player7x ds 1
player8x ds 1
player9x ds 1
player10x ds 1
player11x ds 1
player12x ds 1
player13x ds 1
player14x ds 1
player15x ds 1
player16x ds 1

player0y ds 1
NewSpriteY ds 1			;		Y position
player1y = NewSpriteY
player2y ds 1
player3y ds 1
player4y ds 1
player5y ds 1
player6y ds 1
player7y ds 1
player8y ds 1
player9y ds 1
player10y ds 1
player11y ds 1
player12y ds 1
player13y ds 1
player14y ds 1
player15y ds 1
player16y ds 1

player0color
player0colorlo ds 1
player0colorhi ds 1

player0height ds 1
player1height ds 1
player2height ds 1
player3height ds 1
player4height ds 1
player5height ds 1
player6height ds 1
player7height ds 1
player8height ds 1
player9height ds 1
player10height ds 1
player11height ds 1
player12height ds 1
player13height ds 1
player14height ds 1
player15height ds 1
player16height ds 1

_NUSIZ1 ds 1
NUSIZ2 ds 1
NUSIZ3 ds 1
NUSIZ4 ds 1
NUSIZ5 ds 1
NUSIZ6 ds 1
NUSIZ7 ds 1
NUSIZ8 ds 1
NUSIZ9 ds 1
NUSIZ10 ds 1
NUSIZ11 ds 1
NUSIZ12 ds 1
NUSIZ13 ds 1
NUSIZ14 ds 1
NUSIZ15 ds 1
NUSIZ16 ds 1

score ds 3
COLUM0 ds 1
COLUM1 ds 1
COLUBL ds 1
player0pointerlo ds 1
player0pointerhi ds 1

RAMcopybegin = SpriteGfxIndex
RAMcopylength = *-RAMcopybegin

missile0y ds 1
missile1y ds 1
bally ds 1

missile0height ds 1
missile1height ds 1
ballheight ds 1

statusbarlength ds 1 ; needed?
aux3 = statusbarlength

lifecolor ds 1
pfscorecolor = lifecolor
aux4 ds 1

lifepointer ds 1
lives ds 1
pfscore1 = lifepointer
pfscore2 = lives
aux5 = pfscore1
aux6 = pfscore2

playfieldpos ds 1

temp1 ds 1 ; used in sprite flickering
temp2 ds 1 ;are obliterated when drawscreen is called.
temp3 ds 1
temp4 ds 1
temp5 ds 1
temp6 ds 1
temp7 = topP1x ; This is used to aid in bankswitching

A ds 1
a = A
B ds 1
b = B
C ds 1
c = C
D ds 1
d = D
E ds 1
e = E
F ds 1
f = F
G ds 1
g = G
H ds 1
h = H
I ds 1
i = I
J ds 1
j = J
K ds 1
k = K
L ds 1
l = L
M ds 1
m = M
N ds 1
n = N
O ds 1
o = O
P ds 1
p = P
Q ds 1
q = Q
R ds 1
r = R
S ds 1
s = S
T ds 1
t = T
U ds 1
u = U
V ds 1
v = V
W ds 1
w = W
X ds 1
x = X
Y ds 1
y = Y
Z ds 1
z = Z
scorecolor ds 1

var0 ds 1
var1 ds 1
var2 ds 1
var3 ds 1
var4 ds 1
var5 ds 1
var6 ds 1
var7 ds 1
var8 ds 1
var9 ds 1
var10 ds 1
var11 ds 1
var12 ds 1
var13 ds 1
var14 ds 1
var15 ds 1
var16 ds 1
var17 ds 1
var18 ds 1
var19 ds 1
var20 ds 1
var21 ds 1
var22 ds 1
var23 ds 1
var24 ds 1
var25 ds 1
var26 ds 1
var27 ds 1
var28 ds 1
var29 ds 1
var30 ds 1
var31 ds 1
var32 ds 1
var33 ds 1
var34 ds 1
var35 ds 1
var36 ds 1
var37 ds 1
var38 ds 1
var39 ds 1
var40 ds 1
var41 ds 1
var42 ds 1
var43 ds 1
var44 ds 1
var45 ds 1
var46 ds 1
var47 ds 1
var48 ds 1
var49 ds 1
var50 ds 1
var51 ds 1
var52 ds 1
var53 ds 1
var54 ds 1
var55 ds 1
var56 ds 1
var57 ds 1
var58 ds 1
var59 ds 1
var60 ds 1

stack_reserved ds 10
; echo "free ZP ram:",($100-*)d
 
 SEG.U vars
 org $0300
 
 ; allocate additional vars here as needed
 
 echo "free extended ram:",($700-*)d


stack1 = $f6
stack2 = $f7
stack3 = $f8
stack4 = $f9
; the stack bytes above may be used in the kernel
; stack = F6-F7, F8-F9, FA-FB, FC-FD, FE-FF

 MAC RETURN	; no bank switching needed
     rts
 ENDM
 seg
rand = RANDOM0NEXT
KERNEL_LINES = 178*76/64 ; warning: not all values will work
OVERSCAN_LINES = 128+33*76/64 ; again, not all values work
C_function = 0
CcodeData = C_function + 4
playerpointers = CcodeData + RAMcopylength
P1GFX = playerpointers + 64
P1COLOR = P1GFX + 256
P0GFX = P1COLOR + 256
P0COLOR = P0GFX + 256
PF1L = P0COLOR + 256
PF2L = PF1L + 256
PF1R = PF2L + 256
PF2R = PF1R + 512 ; Avoid Palette collision
PFCOLS = PF2R + 0
JUMPTABLELO = PFCOLS + 256
JUMPTABLEHI = JUMPTABLELO + 12
P1HMP = JUMPTABLEHI + 12
P1SKIP = P1HMP + 13
NUSIZREFP = P1SKIP + 12
scoredata = NUSIZREFP + 12
BKCOLS = scoredata + 96
STACKbegin = BKCOLS + 256
USERSTACK = STACKbegin + 256 ; stack starts here and goes down!!!!
