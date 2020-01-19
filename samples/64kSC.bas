 rem ** The 64kSC test program
 rem **
 rem ** This runs through bank changes and does a memory test in each bank. 
 rem ** The score is adjusted to reflect the last successful bank # changed 
 rem ** to. The background color register changes according to the bank # 
 rem ** that was tested, whether it was successful or not.
 rem ** If the memory test fails from any bank, the score turns dark red and
 rem ** the first score digit turns to "99"

 set romsize 64kSC

  dim frame=a
  dim bchoice=b
  dim memloc=c

  dim sc0=score

  for memloc=0 to 127
    w000[memloc]=$aa
  next

  score=1
  bchoice=0

main
  scorecolor=$0f
  COLUBK=bchoice*4*4+2

  if bchoice=0  then score=1
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
  if bchoice=14 then goto bsub15 bank15
  if bchoice=15 then goto bsub16 bank16


  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

goback

  bchoice=bchoice+1:if bchoice>15 then bchoice=0
  goto main

 bank 2
bsub2
  score=2
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 3
bsub3
  score=3
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 4
bsub4
  score=4
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 5
bsub5
  score=5
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 6
bsub6
  score=6
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 7
bsub7
  score=7
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 8
bsub8
  score=8
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 9
bsub9
  score=9
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 10
bsub10
  score=10
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 11
bsub11
  score=11
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 12
bsub12
  score=12
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 13
bsub13
  score=13
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 14
bsub14
  score=14
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next

  goto goback bank1

 bank 15
bsub15
  score=15
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next
  goto goback bank1

 bank 16
bsub16
  score=16
  for memloc=0 to 127
    temp1=r000[memloc]
    w000[memloc]=r000[memloc]^$ff
    temp1=temp1^$ff
    if r000[memloc]<>temp1 then sc0=$99:scorecolor=$42
    drawscreen
  next
  goto goback bank1

