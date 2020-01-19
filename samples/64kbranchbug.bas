 rem ** The 64k branching bug trigger
 rem **
 rem ** compiling this program should warn about a reverse branch that will
 rem ** accidentally trigger a bankswitch.
 rem ** 
 rem ** this program will "crash" if run.

 set romsize 64k

  dim sc0=score


  goto main

  rem ** waste some space, because the bug is triggered by a reverse branch
  rem ** from the last page of rom to certain bytes in the second last page 
  rem ** of ROM
  asm
  ;REPEAT 3797 ; first hotspot 
  REPEAT 3798 ; second hotspot
  ;REPEAT 3812 ; last hotspot
  nop
  REPEND
end

main
  scorecolor=$0f
  for q = 0 to 9 
    asm
    REPEAT 32 ; waste more space, so the loop end is in the last page
    nop
    REPEND
end
   next
   drawscreen
   goto main

