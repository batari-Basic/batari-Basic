; Provided under the CC0 license. See the included LICENSE.txt for details.

 processor 6502
 include "vcs.h"
 include "macro.h"
 include "DPCplus.h"
 include "DPCplusbB.h"
 include "2600basic_variable_redefs.h"
 ORG $400
 RORG $0
 incbin "DPCplus.arm"
     ORG $1000
     RORG $1000
 incbin "custom/bin/custom2.bin"
; assume custom2.bin > 128 bytes
; repeat $80
; .byte 0
; repend
