
 rem ** Demo of the Cosmic Ark starfield direction in bB

 rem ** no_blank_lines takes away missile0, so we'll create our starfield
 rem ** using it.
 set kernel_options no_blank_lines

 scorecolor=$0f

 dim frame=a
 dim direction=b

   CTRLPF=5
   playfield:
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ......XXXXXXXXXXXXXXXXXXXX......
   ...XXXXXXXXXXXXXXXXXXXXXXXXXX...
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 player0:
 %10000001
 %11000011
 %11111111
 %01011010
 %00111100
end

 player1:
 %00111100
 %01011010
 %11111111
 %11000011
 %10000001
end


 rem ** position the other objects, to prove we still can
 player0x=50:player0y=40
 player1x=120:player1y=40
 ballx=70:bally=40:ballheight=6
 missile1x=100:missile1y=40:missile1height=6

 direction=2

mainloop
 COLUP0=$0A
 COLUP1=$44
 COLUBK=$80
 COLUPF=$B4

  frame=frame+1
  if frame=0 then direction=direction+1
  if direction>7 then direction=0

  ENAM0=2 : rem ** set ENAM0=0 when you want the stars to be gone

  temp2=frame&1
  rem ** Adjusting missile0x moves the stars
  if direction=0 then missile0x=missile0x+1:score=1
  if direction=1 then missile0x=missile0x+18:score=18
  if direction=2 && temp2=1 then missile0x=missile0x+18:score=18 
  if direction=2 && temp2=0 then missile0x=missile0x+16:score=16 
  if direction=3 then missile0x=missile0x+16:score=16
  if direction=4 then missile0x=missile0x-1:score=1
  if direction=5 then missile0x=missile0x-18:score=18
  if direction=6 && temp2=1 then missile0x=missile0x-18:score=18
  if direction=6 && temp2=0 then missile0x=missile0x-16:score=16
  if direction=7 then missile0x=missile0x-16:score=16

  rem ** You need to ensure the missile0x position ranges from 0-159. 
  rem ** If missile0x is 0 and decreases, then set it to 159. 
  rem ** If missile0x is 159 and increases, set it to 0.
  if missile0x>200 then missile0x=missile0x+160
  if missile0x>159 then missile0x=missile0x-160

  drawscreen
  goto mainloop
   
  vblank
  rem ** Enable the TIA bug that causes missile0 to be repeated
  asm
 lda #$ff
 sta HMM0
 lda #$c0
 sta WSYNC
 sta HMOVE
 sleep 5
 sta HMM0
end
  return
