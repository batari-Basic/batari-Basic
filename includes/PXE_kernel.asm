drawscreen
     nop
end_drawscreen
     rts

fetcher_address_table
dflow     
     .byte <P0COLOR
     .byte <P1COLOR
     .byte <P0GFX
     .byte <P1GFX
     .byte <P1SKIP
     .byte <JUMPTABLELO
     .byte <JUMPTABLEHI
     .byte <USERSTACK
dfhigh
     .byte (>P0COLOR)
     .byte (>P1COLOR)
     .byte (>P0GFX)
     .byte (>P1GFX)
     .byte (>P1SKIP)
     .byte (>JUMPTABLELO)
     .byte (>JUMPTABLEHI)
     .byte (>USERSTACK)
dffraclow
     .byte <PF1L
     .byte <PF2L
     .byte <PF1R
     .byte <PF2R
     .byte <PFCOLS
     .byte <NUSIZREFP
     .byte <BKCOLS
     .byte <P1HMP
dffrachi
     .byte (>PF1L)
     .byte (>PF2L)
     .byte (>PF1R)
     .byte (>PF2R)
     .byte (>PFCOLS)
     .byte (>NUSIZREFP) 
     .byte (>BKCOLS)
     .byte (>P1HMP)
