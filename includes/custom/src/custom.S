/******************************************************************************
Harmony custom C Code booter - (C) Copyright 2010 - Fred Quimby
Based on code by Chris Walton
******************************************************************************/

/* Start in ARM mode */
.arm

/* Put code in boot section */
.section  .boot,"ax",%progbits

/* Entry Point (0xC00) */
.global  Custom
.func    Custom
Custom:
 add r0,pc,#1
 bx r0

.thumb
 ldr r0,=0x40000024
 ldr r2,[r0]
 cmp r2,#0
 bmi skipcopy
 add r2,#1
 str r2,[r0]
 cmp r2,#1
 bne skipcopy
 ldr r0,=_etext
 ldr r1,=_edata
 ldr r2,=_sdata ;@ data copy to ram
 sub r1,r1,r2   ;@ offset
copyloop:
 sub r1,#4
 bmi skipcopy
 ldr r3,[r0, +r1]
 str r3,[r2, +r1]
 bne copyloop
skipcopy:

 push {lr}
 ldr r0,=return_to_DPC+1
 mov lr,r0

  /* Boot to main in C code */
  ldr     r0, =main
  bx      r0

return_to_DPC:
 pop {r1}
 bx r1
