; Provided under the CC0 license. See the included LICENSE.txt for details.

 org $fffc + ROM_START
 rorg $fffc
end_of_address_space 
 .word (start & $ffff)
 .word (start & $ffff)

 incbin "PXE-post.arm"

    SEG.U
    rorg $000a
Paddle0 ds 1
Paddle1 ds 1

    rorg $002d
Score_Background_Color ds 1

    ; ARM Functions called via JSR
    SEG.U
    rorg $0000
pfsetup1 ds 1
pfsetup2 ds 1
pfsetup3 ds 1
pfsetup4 ds 1
pfsetup5 ds 1
pfsetup6 ds 1
pfsetup7 ds 1
pfsetup8 ds 1
pfsetup9 ds 1
pfsetup10 ds 1
pfsetup11 ds 1
pfsetup12 ds 1
pfsetup13 ds 1
pfsetup14 ds 1
pfsetup15 ds 1

    rorg $000f
pfscroll_right ds 1
pfscroll_left ds 1
pfscroll_down ds 1
pfscroll_up ds 1