 rem ** The 64k test program
 rem **
 rem ** This test runs through 64k bank changes. The score is adjusted to
 rem ** reflect that last successful bank # changed to. The background color 
 rem ** register changes according to the bank # that was tested, whether it
 rem ** was successful or not.
 rem **
 rem ** banks 2-14 test goto
 rem ** banks 15-16 test gosub+return otherbank

 set romsize 64k

  dim frame=a
  dim bchoice=b

  scorecolor=$0f
  score=1
  bchoice=0

main
  gosub testsub1 bank1
  frame=frame+1
  if frame>59 then frame=0:bchoice=bchoice+1:if bchoice>15 then bchoice=0:score=1
  if bchoice=0  then goto goback
  if bchoice=1  then goto bsub2 bank2
  if bchoice=2  then goto bsub3 bank3
  if bchoice=3  then goto bsub4 bank4
  if bchoice=4  then goto bsub5 bank5
  if bchoice=5  then goto bsub6 bank6
  if bchoice=6  then goto bsub7 bank7
  if bchoice=7  then goto bsub8 bank8
  if bchoice=8  then goto bsub9 bank9
  if bchoice=9  then goto bsub10 bank10
  if bchoice=10 then goto bsub11 bank11
  if bchoice=11 then goto bsub12 bank12
  if bchoice=12 then goto bsub13 bank13
  if bchoice=13 then goto bsub14 bank14
  if bchoice=14 then gosub bsub15 bank15
  if bchoice=15 then gosub bsub16 bank16

goback
  COLUBK=bchoice*4*4+2
  drawscreen
  goto main

testsub1
  return otherbank

 bank 2
bsub2
  score=2
  goto goback bank1

 bank 3
bsub3
  score=3
  goto goback bank1

 bank 4
bsub4
  score=4
  goto goback bank1

 bank 5
bsub5
  score=5
  goto goback bank1

 bank 6
bsub6
  score=6
  goto goback bank1

 bank 7
bsub7
  score=7
  goto goback bank1

 bank 8
bsub8
  score=8
  goto goback bank1

 bank 9
bsub9
  score=9
  goto goback bank1

 bank 10
bsub10
  score=10
  goto goback bank1

 bank 11
bsub11
  score=11
  goto goback bank1

 bank 12
bsub12
  score=12
  goto goback bank1

 bank 13
bsub13
  score=13
  goto goback bank1

 bank 14
bsub14
  score=14
  goto goback bank1

 bank 15
bsub15
  score=15
  return otherbank 

 bank 16
bsub16
  score=16
  return otherbank
