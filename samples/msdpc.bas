 set kernel DPC+
; test comment
 ; another test
 set smartbranching on;test
 /* This is a test of multiline comments
 still commenting?
 garbage chars:@#|"'`~
 */
 dim rand1=$DA
 rem regular comment
 goto start bank2
 bank 2
start
 COLUBK=45 ; testtest
 playfield:
 X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ..X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 ...X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ....X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .....X.X.X.X.X.X.X.X.X.X.X.X.X.X
 X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ..X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 ...X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ....X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .....X.X.X.X.X.X.X.X.X.X.X.X.X.X
 X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ..X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 ...X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ....X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .....X.X.X.X.X.X.X.X.X.X.X.X.X.X
 X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ..X.X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 ...X.X.X.X.X.X.X.X.X.X.X.X.X.X.X
 ....X.X.X.X.X.X.X.X.X.X.X.X.X.X.
 .....X.X.X.X.X.X.X.X.X.X.X.X.X.X
end
 pfcolors:
 $0E
 $0C
 $0A
 $08
 $06
 $04
 $02
 $1E
 $1C
 $1A
 $18
 $16
 $14
 $12
 $2E
 $2C
 $2A
 $28
 $26
 $24
 $22
 $3E
 $3C
 $3A
 $38
 $36
 $34
 $32
 $4E
 $4C
 $4A
 $48
 $46
 $44
 $42
 $5E
 $5C
 $5A
 $58
 $56
 $54
 $52
end
 bkcolors:
 $f2
 $f4
 $f6
 $f8
 $fa
 $fc
 $fe
end
 player0color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player2color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player1color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player3color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player4color:
 4
 6
 8
 10
 12
 10
 8
 6
end
 player5color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player6color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player7color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player8color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player9color:
 0
 0
 0
 0
 0
 0
 0
 0
end
 player0:
        %00111100
        %01100110
        %01100110
        %01100110
        %01100110
        %01100110
        %01100110
        %00111100
end
 player0x=20
 player0y=71
 player1x=40
 player1y=85
 player2x=40
 player3x=40
 player4x=40
 player5x=40
 player6x=40
 player7x=40
 player8x=40
 player9x=40
 player2y=67
 player3y=48
 player4y=29
 player5y=10
 player6y=104
 player7y=123
 player8y=142
 player9y=161
 missile0x=44:missile0y=44
 missile1x=44:missile1y=44
 ballx=44:bally=44
 missile0height=6
 missile1height=9
 ballheight=12
loop
 scorecolors:
 $32
 $34
 $36
 b
 $38
 $3a
 $3c
 $3e
end
 score=score+1
 if joy0down then player1y[a]=player1y[a]+1
 if joy0up then player1y[a]=player1y[a]-1
 if joy0left then player1x[a]=player1x[a]-1
 if joy0right then player1x[a]=player1x[a]+1
 if v=1 then nojoy
 if joy0fire then a=a+1: v=1
 if a=9 then a=0
nojoy
 if !joy0fire then v=0
 if joy1up then b=b+1
 if joy1down then c=c+1
 if joy1left then d=d+1
 if joy1right then e=e+1
 if switchreset then f=f+1
 if switchselect then g=g+1
 if joy1fire && joy1up then b=b+1:c=b:d=b:e=b
 if joy1fire && joy1down then b=b-1:c=b:d=b:e=b
 DF0FRACINC=b
 DF1FRACINC=c
 DF2FRACINC=d
 DF3FRACINC=e
 DF4FRACINC=f
 DF6FRACINC=g
 player7:
        %01111110
        %00000110
        %00000110
        %00001100
        %00011000
        %00110000
        %01100000
        %01100000
end
 player9:
        %00111100
        %01100110
        %01100110
        %01100110
        %01111100
        %01100000
        %01100000
        %00111110
end
 player8:
        %00111100
        %01100110
        %01100110
        %00111100
        %01100110
        %01100110
        %01100110
        %00111100
end
 player6:
        %00111110
        %01100000
        %01100000
        %01111100
        %01100110
        %01100110
        %01100110
        %00111100
end
 player5:
        %01111110
        %01100000
        %01100000
        %00111100
        %00000110
        %00000110
        %01000110
        %00111100
end
 player4:
        %00001100
        %00011100
        %00101100
        %01001100
        %01001100
        %01111110
        %00001100
        %00001100
end
 player3:
        %00111100
        %01000110
        %00000110
        %00011100
        %00000110
        %00000110
        %01000110
        %00111100
end
 player2:
        %00111100
        %01000110
        %00000110
        %00000110
        %00111100
        %01100000
        %01100000
        %01111110
end
 player1:
        %00001000
        %00011000
        %00111000
      %00011000
      %00011000
        %00011000
        %00011000
        %01111110
end
 NUSIZ9=8 ; reflect

 drawscreen
 goto loop
