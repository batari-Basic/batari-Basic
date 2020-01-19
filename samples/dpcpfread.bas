 set kernel DPC+
 dim frame=a
 dim sc0=score
 dim sc1=score+1
 dim sc2=score+2
 goto start bank2
 bank 2
start
 scorecolors:
 $32
 $34
 $36
 $36
 $38
 $3a
 $3c
 $3e
end

 playfield:
..XXXX........XXXX........XXX...
.XX..XX....XXX....XXX......XXX..
.XX..XX....XXX....XXX.....XXX...
.XX..XX.......XXXX.........XXX..
.XX..XX....XXX....XXX.....XXX...
.XX..XX....XXX....XXX......XXX..
.XX..XX....XXX....XXX.....XXX...
..XXXX........XXXX.........XXX..
end

 pfcolors:
 $86
end

main
 DF0FRACINC=16
 DF1FRACINC=16
 DF2FRACINC=16
 DF3FRACINC=32
 frame=frame+1:if frame=10 then frame=0:x=x+1:score=score+10000
 if x>31 then y=y+1:x=0:sc0=0:score=score+100
 if y>8 then y=0:score=0
 if pfread(x,y) then sc2=$ff else sc2=0
 drawscreen
 pfpixel x y flip
 drawscreen
 pfpixel x y flip
 goto main

