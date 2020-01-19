@ Provided under the GPL v2 license. See the included LICENSE.txt for details.

	.cpu arm7tdmi
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 4
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.code	16
	.file	"main.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.text.my_memcpy,"ax",%progbits
	.align	1
	.global	my_memcpy
	.code	16
	.thumb_func
	.type	my_memcpy, %function
my_memcpy:
.LFB0:
	.file 1 "main.c"
	.loc 1 175 0
	.cfi_startproc
.LVL0:
	push	{r4, r5, r6, r7, lr}
.LCFI0:
	.cfi_def_cfa_offset 20
	.cfi_offset 4, -20
	.cfi_offset 5, -16
	.cfi_offset 6, -12
	.cfi_offset 7, -8
	.cfi_offset 14, -4
	.loc 1 177 0
	mov	r4, r2
.LVL1:
.L2:
	.loc 1 174 0 discriminator 1
	sub	r5, r4, r2
	.loc 1 177 0 discriminator 1
	cmp	r5, r3
	bge	.L5
.L3:
	.loc 1 178 0 discriminator 2
	ldr	r7, .L6
	.loc 1 174 0 discriminator 2
	sub	r6, r1, r2
	.loc 1 178 0 discriminator 2
	ldrb	r6, [r6, r4]
	ldr	r7, [r7]
	lsl	r5, r4, #24
	lsr	r5, r5, #24
	and	r6, r7
	strb	r6, [r0, r5]
	add	r4, r4, #1
	b	.L2
.L5:
	.loc 1 179 0
	@ sp needed for prologue
	pop	{r4, r5, r6, r7}
	pop	{r0}
	bx	r0
.L7:
	.align	2
.L6:
	.word	mask
	.cfi_endproc
.LFE0:
	.size	my_memcpy, .-my_memcpy
	.section	.text.my_memset,"ax",%progbits
	.align	1
	.global	my_memset
	.code	16
	.thumb_func
	.type	my_memset, %function
my_memset:
.LFB1:
	.loc 1 182 0
	.cfi_startproc
.LVL2:
	push	{r4, lr}
.LCFI1:
	.cfi_def_cfa_offset 8
	.cfi_offset 4, -8
	.cfi_offset 14, -4
	.loc 1 184 0
	mov	r3, r0
.LVL3:
.L9:
	.loc 1 181 0 discriminator 1
	sub	r4, r3, r0
	.loc 1 184 0 discriminator 1
	cmp	r4, r2
	bge	.L11
.L10:
	.loc 1 185 0 discriminator 2
	strb	r1, [r3]
	add	r3, r3, #1
	b	.L9
.L11:
	.loc 1 186 0
	@ sp needed for prologue
	pop	{r4}
	pop	{r0}
	bx	r0
	.cfi_endproc
.LFE1:
	.size	my_memset, .-my_memset
	.section	.text.reverse,"ax",%progbits
	.align	1
	.global	reverse
	.code	16
	.thumb_func
	.type	reverse, %function
reverse:
.LFB2:
	.loc 1 189 0
	.cfi_startproc
.LVL4:
	push	{r4, lr}
.LCFI2:
	.cfi_def_cfa_offset 8
	.cfi_offset 4, -8
	.cfi_offset 14, -4
.L13:
	.loc 1 191 0 discriminator 1
	cmp	r0, r1
	bge	.L15
.L14:
	.loc 1 193 0
	ldrb	r3, [r2, r0]
.LVL5:
	ldrb	r4, [r2, r1]
	strb	r4, [r2, r0]
	strb	r3, [r2, r1]
	.loc 1 194 0
	add	r0, r0, #1
.LVL6:
	.loc 1 195 0
	sub	r1, r1, #1
.LVL7:
	b	.L13
.LVL8:
.L15:
	.loc 1 197 0
	@ sp needed for prologue
	pop	{r4}
	pop	{r0}
	bx	r0
	.cfi_endproc
.LFE2:
	.size	reverse, .-reverse
	.section	.text.memscroll,"ax",%progbits
	.align	1
	.global	memscroll
	.code	16
	.thumb_func
	.type	memscroll, %function
memscroll:
.LFB3:
	.loc 1 200 0
	.cfi_startproc
.LVL9:
	push	{r3, r4, r5, lr}
.LCFI3:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	.cfi_offset 4, -12
	.cfi_offset 5, -8
	.cfi_offset 14, -4
	.loc 1 200 0
	mov	r4, r0
	mov	r5, r1
	.loc 1 202 0
	mov	r2, r4
	sub	r1, r1, #1
.LVL10:
	mov	r0, #0
.LVL11:
	bl	reverse
.LVL12:
	.loc 1 203 0
	mov	r0, r5
	mov	r2, r4
	mov	r1, #255
	bl	reverse
.LVL13:
	.loc 1 204 0
	mov	r0, #0
	mov	r1, #255
	mov	r2, r4
	bl	reverse
.LVL14:
	.loc 1 205 0
	@ sp needed for prologue
.LVL15:
	pop	{r3, r4, r5}
	pop	{r0}
	bx	r0
	.cfi_endproc
.LFE3:
	.size	memscroll, .-memscroll
	.section	.text.get32bitdff,"ax",%progbits
	.align	1
	.global	get32bitdff
	.code	16
	.thumb_func
	.type	get32bitdff, %function
get32bitdff:
.LFB4:
	.loc 1 208 0
	.cfi_startproc
.LVL16:
	.loc 1 209 0
	ldr	r3, .L18
	ldr	r3, [r3]
	add	r3, r3, r0
	mov	r2, r3
	add	r2, r2, #46
	ldrb	r0, [r2]
.LVL17:
	add	r3, r3, #38
	ldrb	r3, [r3]
	lsl	r0, r0, #8
	add	r0, r0, r3
	.loc 1 210 0
	@ sp needed for prologue
	bx	lr
.L19:
	.align	2
.L18:
	.word	fetcheraddr
	.cfi_endproc
.LFE4:
	.size	get32bitdff, .-get32bitdff
	.section	.text.get32bitdf,"ax",%progbits
	.align	1
	.global	get32bitdf
	.code	16
	.thumb_func
	.type	get32bitdf, %function
get32bitdf:
.LFB5:
	.loc 1 213 0
	.cfi_startproc
.LVL18:
	.loc 1 214 0
	ldr	r3, .L21
	ldr	r3, [r3]
	add	r3, r3, r0
	ldrb	r0, [r3, #30]
.LVL19:
	ldrb	r3, [r3, #22]
	lsl	r0, r0, #8
	add	r0, r0, r3
	.loc 1 215 0
	@ sp needed for prologue
	bx	lr
.L22:
	.align	2
.L21:
	.word	fetcheraddr
	.cfi_endproc
.LFE5:
	.size	get32bitdf, .-get32bitdf
	.section	.text.shiftnumbers,"ax",%progbits
	.align	1
	.global	shiftnumbers
	.code	16
	.thumb_func
	.type	shiftnumbers, %function
shiftnumbers:
.LFB6:
	.loc 1 218 0
	.cfi_startproc
.LVL20:
	.loc 1 219 0
	ldr	r3, .L27
	ldrb	r2, [r3]
	sub	r2, r2, #1
.L24:
	.loc 1 219 0 is_stmt 0 discriminator 1
	cmp	r0, r2
	beq	.L26
.L25:
	.loc 1 221 0 is_stmt 1
	ldr	r3, .L27+4
	add	r0, r0, #1
.LVL21:
	ldrb	r1, [r0, r3]
	.loc 1 217 0
	add	r3, r3, r0
	sub	r3, r3, #1
	.loc 1 221 0
	strb	r1, [r3]
.LVL22:
	b	.L24
.L26:
	.loc 1 225 0
	@ sp needed for prologue
	bx	lr
.L28:
	.align	2
.L27:
	.word	maxsprites
	.word	.LANCHOR0
	.cfi_endproc
.LFE6:
	.size	shiftnumbers, .-shiftnumbers
	.section	.text.checkwrap,"ax",%progbits
	.align	1
	.global	checkwrap
	.code	16
	.thumb_func
	.type	checkwrap, %function
checkwrap:
.LFB7:
	.loc 1 228 0
	.cfi_startproc
.LVL23:
	.loc 1 229 0
	add	r3, r0, r1
	.loc 1 228 0
	push	{r4, lr}
.LCFI4:
	.cfi_def_cfa_offset 8
	.cfi_offset 4, -8
	.cfi_offset 14, -4
	.loc 1 229 0
	lsl	r3, r3, #24
	lsr	r3, r3, #24
	asr	r4, r3, #31
	lsr	r2, r1, #31
	cmp	r3, r1
	adc	r4, r4, r2
	neg	r3, r4
	and	r0, r3
.LVL24:
	.loc 1 231 0
	@ sp needed for prologue
	pop	{r4}
	pop	{r1}
	bx	r1
	.cfi_endproc
.LFE7:
	.size	checkwrap, .-checkwrap
	.section	.text.checkswap,"ax",%progbits
	.align	1
	.global	checkswap
	.code	16
	.thumb_func
	.type	checkswap, %function
checkswap:
.LFB8:
	.loc 1 234 0
	.cfi_startproc
.LVL25:
	push	{r4, r5, r6, r7, lr}
.LCFI5:
	.cfi_def_cfa_offset 20
	.cfi_offset 4, -20
	.cfi_offset 5, -16
	.cfi_offset 6, -12
	.cfi_offset 7, -8
	.cfi_offset 14, -4
	.loc 1 237 0
	ldr	r3, .L37
	ldr	r2, [r3, #12]
	add	r0, r2, r0
.LVL26:
	ldrb	r4, [r0, #21]
.LVL27:
	add	r0, r0, #33
.LVL28:
.LBB6:
.LBB7:
	.loc 1 229 0
	ldrb	r3, [r0]
	mov	r0, #255
.LVL29:
	add	r5, r4, r3
	and	r5, r0
	asr	r7, r5, #31
	lsr	r6, r3, #31
	cmp	r5, r3
	adc	r7, r7, r6
.LBE7:
.LBE6:
	.loc 1 238 0
	add	r1, r2, r1
.LVL30:
	ldrb	r2, [r1, #21]
.LVL31:
.LBB10:
.LBB8:
	.loc 1 229 0
	neg	r3, r7
.LBE8:
.LBE10:
	.loc 1 238 0
	add	r1, r1, #33
.LBB11:
.LBB9:
	.loc 1 229 0
	and	r4, r3
.LVL32:
.LBE9:
.LBE11:
.LBB12:
.LBB13:
	ldrb	r3, [r1]
	add	r1, r2, r3
.LVL33:
	and	r1, r0
	asr	r5, r1, #31
	lsr	r0, r3, #31
	cmp	r1, r3
	adc	r5, r5, r0
	neg	r1, r5
	and	r2, r1
.LBE13:
.LBE12:
	.loc 1 239 0
	sub	r2, r4, r2
.LVL34:
	.loc 1 240 0
	cmp	r2, #0
	ble	.L36
	.loc 1 242 0
	sub	r2, r2, #5
.LVL35:
	cmp	r2, #0
	ble	.L36
	.loc 1 244 0
	lsr	r0, r2, #31
	asr	r1, r3, #31
	cmp	r3, r2
	adc	r0, r0, r1
	b	.L34
.L36:
	.loc 1 254 0
	mov	r0, #1
.L34:
	.loc 1 262 0
	@ sp needed for prologue
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L38:
	.align	2
.L37:
	.word	.LANCHOR0
	.cfi_endproc
.LFE8:
	.size	checkswap, .-checkswap
	.section	.text.copynybble,"ax",%progbits
	.align	1
	.global	copynybble
	.code	16
	.thumb_func
	.type	copynybble, %function
copynybble:
.LFB9:
	.loc 1 265 0
	.cfi_startproc
.LVL36:
	.loc 1 269 0
	ldr	r3, .L41
	.loc 1 265 0
	push	{r4, r5, r6, lr}
.LCFI6:
	.cfi_def_cfa_offset 16
	.cfi_offset 4, -16
	.cfi_offset 5, -12
	.cfi_offset 6, -8
	.cfi_offset 14, -4
	.loc 1 269 0
	ldr	r4, .L41+4
	ldr	r3, [r3]
	ldr	r2, [r4]
	mov	r5, r3
	lsl	r6, r2, #3
	add	r5, r5, #56
	add	r2, r2, #1
	str	r2, [r4]
	ldrb	r5, [r5]
	.loc 1 270 0
	mov	r2, r3
	add	r2, r2, #55
	.loc 1 269 0
	add	r5, r6, r5
	.loc 1 270 0
	ldrb	r4, [r2]
	.loc 1 269 0
	mov	r6, r3
	.loc 1 270 0
	add	r3, r3, #54
	ldrb	r2, [r3]
	.loc 1 269 0
	add	r6, r6, #57
	.loc 1 270 0
	lsl	r4, r4, #8
	add	r3, r4, r2
	.loc 1 269 0
	ldrb	r6, [r6]
	.loc 1 270 0
	mov	r2, #15
	.loc 1 269 0
	ldr	r1, .L41+8
	.loc 1 270 0
	and	r0, r2
.LVL37:
	.loc 1 269 0
	lsl	r6, r6, #8
	.loc 1 270 0
	lsl	r0, r0, #3
	.loc 1 269 0
	add	r5, r5, r6
	.loc 1 270 0
	add	r0, r3, r0
	.loc 1 269 0
	ldr	r6, [r1, #16]
	.loc 1 270 0
	ldr	r3, [r1, #20]
	.loc 1 269 0
	add	r5, r6, r5
.LVL38:
	.loc 1 270 0
	add	r0, r3, r0
.LVL39:
	.loc 1 271 0
	mov	r3, #0
.LVL40:
.L40:
	.loc 1 264 0 discriminator 2
	sub	r2, r0, r3
	.loc 1 272 0 discriminator 2
	ldrb	r2, [r2, #7]
	strb	r2, [r5, r3]
	.loc 1 271 0 discriminator 2
	add	r3, r3, #1
.LVL41:
	cmp	r3, #8
	bne	.L40
	.loc 1 274 0
	@ sp needed for prologue
.LVL42:
.LVL43:
	pop	{r4, r5, r6}
	pop	{r0}
	bx	r0
.L42:
	.align	2
.L41:
	.word	fetcheraddr
	.word	temp5
	.word	.LANCHOR0
	.cfi_endproc
.LFE9:
	.size	copynybble, .-copynybble
	.section	.text.on_off_flip,"ax",%progbits
	.align	1
	.global	on_off_flip
	.code	16
	.thumb_func
	.type	on_off_flip, %function
on_off_flip:
.LFB10:
	.loc 1 277 0
	.cfi_startproc
.LVL44:
	.loc 1 278 0
	ldr	r3, .L49
	ldr	r3, [r3, #24]
	ldrb	r2, [r3]
	mov	r3, #3
	and	r3, r2
	cmp	r3, #1
	beq	.L46
	cmp	r3, #0
	beq	.L45
	cmp	r3, #2
	bne	.L43
	.loc 1 287 0
	ldr	r3, .L49+4
	ldr	r3, [r3]
	add	r0, r3, r0
.LVL45:
	ldrb	r3, [r0]
	eor	r1, r3
.LVL46:
	b	.L48
.LVL47:
.L45:
	.loc 1 281 0
	ldr	r3, .L49+4
	ldr	r3, [r3]
	add	r0, r3, r0
.LVL48:
	ldrb	r3, [r0]
	orr	r1, r3
.LVL49:
	b	.L48
.LVL50:
.L46:
.LBB16:
.LBB17:
	.loc 1 284 0
	ldr	r3, .L49+4
	ldr	r3, [r3]
	add	r0, r3, r0
.LVL51:
	ldrb	r3, [r0]
	bic	r3, r1
	strb	r3, [r0]
	b	.L43
.LVL52:
.L48:
.LBE17:
.LBE16:
	.loc 1 287 0
	strb	r1, [r0]
.L43:
	.loc 1 292 0
	@ sp needed for prologue
	bx	lr
.L50:
	.align	2
.L49:
	.word	.LANCHOR0
	.word	pfpixel
	.cfi_endproc
.LFE10:
	.size	on_off_flip, .-on_off_flip
	.section	.text.startup.main,"ax",%progbits
	.align	1
	.global	main
	.code	16
	.thumb_func
	.type	main, %function
main:
.LFB11:
	.loc 1 296 0
	.cfi_startproc
.LVL53:
	push	{r4, r5, r6, r7, lr}
.LCFI7:
	.cfi_def_cfa_offset 20
	.cfi_offset 4, -20
	.cfi_offset 5, -16
	.cfi_offset 6, -12
	.cfi_offset 7, -8
	.cfi_offset 14, -4
	sub	sp, sp, #68
.LCFI8:
	.cfi_def_cfa_offset 88
	.loc 1 305 0
	ldr	r1, .L107
	mov	r2, #32
	add	r0, sp, #32
	bl	memcpy
.LVL54:
	.loc 1 311 0
	ldr	r3, .L107+4
	ldr	r0, [r3, #28]
	ldr	r2, [r3, #20]
	ldrh	r1, [r0]
	add	r1, r2, r1
	ldr	r2, .L107+8
	.loc 1 314 0
	ldr	r6, [r3, #24]
	.loc 1 311 0
	str	r1, [r2]
	.loc 1 314 0
	ldrb	r4, [r6, #1]
	.loc 1 318 0
	ldrb	r2, [r6]
	mov	r1, #3
	.loc 1 314 0
	str	r4, [sp, #4]
.LVL55:
	.loc 1 315 0
	ldrb	r7, [r6, #2]
.LVL56:
	.loc 1 316 0
	ldrb	r5, [r6, #3]
.LVL57:
	.loc 1 318 0
	bic	r2, r1
	mov	r4, r3
	cmp	r2, #16
	beq	.L56
	bhi	.L61
	cmp	r2, #8
	beq	.L66
	cmp	r2, #12
	beq	.L55
	cmp	r2, #4
	beq	.LCB629
	b	.L52	@long jump
.LCB629:
	.loc 1 322 0
	lsr	r0, r5, #3
	ldr	r4, [r3, #16]
	bl	get32bitdff
.LVL58:
	ldr	r3, .L107+12
	add	r4, r4, r0
	str	r4, [r3]
.LVL59:
	.loc 1 323 0
	b	.L63
.LVL60:
.L61:
	.loc 1 318 0
	cmp	r2, #24
	bne	.LCB649
	b	.L58	@long jump
.LCB649:
	bhi	.L62
	cmp	r2, #20
	beq	.LCB653
	b	.L52	@long jump
.LCB653:
	.loc 1 354 0
	mov	r2, #0
	strb	r2, [r6, #3]
.LVL61:
	.loc 1 356 0
	ldr	r2, [r3, #12]
	.loc 1 364 0
	ldr	r3, [r3, #20]
	str	r3, [sp, #16]
	lsl	r3, r7, #1
	add	r3, r3, #57
	add	r3, r2, r3
	str	r3, [sp, #12]
	mov	r3, r7
	add	r3, r3, #28
	.loc 1 365 0
	ldr	r6, [sp, #4]
.LVL62:
	.loc 1 364 0
	lsl	r3, r3, #1
	add	r3, r2, r3
	str	r3, [sp, #20]
	.loc 1 365 0
	lsl	r3, r6, #1
	add	r3, r3, #57
	.loc 1 356 0
	add	r1, r2, r7
	.loc 1 365 0
	add	r3, r2, r3
	.loc 1 356 0
	ldrb	r4, [r1, #20]
	.loc 1 365 0
	str	r3, [sp, #24]
	.loc 1 356 0
	add	r1, r1, #1
	.loc 1 365 0
	mov	r3, r6
	.loc 1 356 0
	ldrb	r1, [r1, #31]
	.loc 1 365 0
	add	r3, r3, #28
	.loc 1 356 0
	mov	ip, r4
.LVL63:
	.loc 1 365 0
	lsl	r3, r3, #1
	add	r3, r2, r3
	.loc 1 356 0
	add	r1, r1, ip
	.loc 1 365 0
	str	r3, [sp, #28]
	.loc 1 356 0
	str	r1, [sp, #8]
	mov	r3, r4
	b	.L69
.LVL64:
.L62:
	.loc 1 318 0
	cmp	r2, #28
	beq	.L59
	cmp	r2, #32
	beq	.LCB701
	b	.L52	@long jump
.LCB701:
	.loc 1 389 0
	mov	r6, r7
.LVL65:
	b	.L72
.LVL66:
.L63:
	.loc 1 323 0 discriminator 1
	ldr	r4, [sp, #4]
	cmp	r7, r4
	ble	.LCB717
	b	.L101	@long jump
.LCB717:
.L64:
	.loc 1 325 0 discriminator 2
	add	r6, sp, #32
	mov	r0, r7
	ldrb	r1, [r6, r5]
	bl	on_off_flip
.LVL67:
	.loc 1 323 0 discriminator 2
	add	r7, r7, #1
.LVL68:
	b	.L63
.LVL69:
.L66:
	.loc 1 331 0 discriminator 1
	ldr	r6, [sp, #4]
	cmp	r5, r6
	ble	.LCB738
	b	.L101	@long jump
.LCB738:
.L67:
	.loc 1 333 0 discriminator 2
	asr	r0, r5, #3
	bl	get32bitdff
.LVL70:
	ldr	r6, [r4, #16]
	ldr	r3, .L107+12
	add	r6, r6, r0
	str	r6, [r3]
	.loc 1 334 0 discriminator 2
	add	r6, sp, #32
	ldrb	r1, [r6, r5]
	mov	r0, r7
	bl	on_off_flip
.LVL71:
	.loc 1 331 0 discriminator 2
	add	r5, r5, #1
.LVL72:
	b	.L66
.LVL73:
.L55:
	.loc 1 340 0
	lsr	r0, r5, #3
	ldr	r4, [r3, #16]
	bl	get32bitdff
.LVL74:
	ldr	r3, .L107+12
	add	r4, r4, r0
	str	r4, [r3]
	.loc 1 341 0
	add	r0, sp, #32
	ldrb	r1, [r0, r5]
	mov	r0, r7
	bl	on_off_flip
.LVL75:
	b	.L101
.LVL76:
.L56:
	.loc 1 346 0
	ldr	r0, [r3, #12]
	mov	r1, #0
	add	r0, r0, #58
	ldr	r2, .L107+16
	b	.L102
.LVL77:
.L71:
	.loc 1 358 0
	ldr	r5, [sp, #4]
	add	r4, r2, r5
	ldrb	r1, [r4, #20]
	cmp	r3, r1
	bge	.L103
.LVL78:
.L70:
	.loc 1 356 0
	add	r3, r3, #1
.LVL79:
.L69:
	.loc 1 356 0 is_stmt 0 discriminator 1
	ldr	r4, [sp, #8]
	cmp	r3, r4
	blt	.L71
	b	.L101
.L103:
	.loc 1 358 0 is_stmt 1 discriminator 1
	add	r0, r4, #1
	ldrb	r0, [r0, #31]
	add	r0, r1, r0
	cmp	r3, r0
	bge	.L70
	.loc 1 361 0
	add	r0, r2, r7
	ldrb	r0, [r0, #10]
	ldrb	r4, [r4, #10]
	sub	r0, r0, r4
	add	r0, r0, #7
.LVL80:
	.loc 1 362 0
	cmp	r0, #14
	bgt	.L70
	.loc 1 364 0
	ldr	r6, [sp, #12]
	ldrb	r5, [r6]
	ldr	r6, [sp, #20]
	ldrb	r4, [r6]
	lsl	r5, r5, #8
	add	r4, r5, r4
	ldr	r6, [sp, #16]
	mov	r5, ip
	add	r4, r4, r3
	sub	r4, r4, r5
	add	r4, r6, r4
	ldrb	r4, [r4]
	str	r4, [sp]
	.loc 1 365 0
	ldr	r4, [sp, #24]
	ldrb	r6, [r4]
	ldr	r4, [sp, #28]
	ldrb	r5, [r4]
	lsl	r6, r6, #8
	add	r5, r6, r5
	add	r5, r5, r3
	ldr	r6, [sp, #16]
	sub	r5, r5, r1
	add	r5, r6, r5
	ldrb	r1, [r5]
.LVL81:
	lsl	r1, r1, r0
.LVL82:
	mov	r0, r1
.LVL83:
	.loc 1 364 0
	ldr	r1, [sp]
	lsl	r4, r1, #7
	.loc 1 367 0
	tst	r4, r0
	beq	.L70
	.loc 1 369 0
	ldr	r3, .L107+4
.LVL84:
	ldr	r3, [r3, #24]
	mov	r2, #255
.LVL85:
	strb	r2, [r3, #3]
	b	.L101
.LVL86:
.L58:
	.loc 1 378 0
	ldr	r5, [sp, #4]
	lsr	r0, r5, #3
	ldr	r4, [r3, #16]
	bl	get32bitdff
.LVL87:
	ldr	r3, .L107+12
	add	r0, r4, r0
	str	r0, [r3]
	.loc 1 379 0
	ldrb	r3, [r0, r7]
	add	r0, sp, #32
	ldrb	r2, [r0, r5]
	and	r3, r2
	neg	r2, r3
	adc	r3, r3, r2
	strb	r3, [r6, #3]
	b	.L101
.LVL88:
.L59:
	.loc 1 384 0
	mov	r0, #0
	ldr	r4, [r3, #16]
	bl	get32bitdff
.LVL89:
	mov	r2, #128
	ldr	r1, [sp, #4]
	add	r0, r4, r0
	lsl	r2, r2, #3
.L102:
	bl	my_memset
.LVL90:
	b	.L101
.LVL91:
.L72:
	.loc 1 389 0 discriminator 1
	cmp	r6, r5
	blt	.LCB931
	b	.L101	@long jump
.LCB931:
.L73:
	.loc 1 390 0 discriminator 2
	mov	r0, r6
	bl	get32bitdff
.LVL92:
	ldr	r7, [r4, #16]
	ldr	r1, [sp, #4]
	add	r0, r7, r0
	bl	memscroll
.LVL93:
	.loc 1 389 0 discriminator 2
	add	r6, r6, #1
.LVL94:
	b	.L72
.LVL95:
.L52:
	.loc 1 399 0
	mov	r1, sp
	ldr	r2, .L107+20
	ldrb	r1, [r1, #4]
	strb	r1, [r2]
.LVL96:
	.loc 1 401 0
	mov	r3, #0
.LVL97:
.L74:
	.loc 1 401 0 is_stmt 0 discriminator 1
	ldr	r5, [sp, #4]
	cmp	r3, r5
	bge	.L104
.L75:
	.loc 1 403 0 is_stmt 1 discriminator 2
	mov	r2, r4
	add	r2, r2, #32
	ldrb	r2, [r3, r2]
	strb	r2, [r4, r3]
	.loc 1 401 0 discriminator 2
	add	r3, r3, #1
.LVL98:
	b	.L74
.L104:
	.loc 1 406 0
	sub	r5, r5, #1
	.loc 1 295 0
	ldr	r6, [sp, #4]
.LVL99:
	.loc 1 406 0
	str	r5, [sp, #16]
.LVL100:
	.loc 1 295 0
	mov	r5, r4
.LVL101:
	sub	r6, r6, #2
.LVL102:
	add	r5, r5, #32
	add	r5, r5, r6
.LVL103:
.L76:
	.loc 1 408 0 discriminator 1
	cmp	r6, #0
	blt	.L81
	.loc 1 410 0
	ldrb	r0, [r5, #1]
	ldrb	r1, [r5]
	.loc 1 295 0
	add	r7, r6, #1
	.loc 1 410 0
	bl	checkswap
.LVL104:
.L77:
	cmp	r0, #1
	beq	.L79
	cmp	r0, #2
	beq	.L80
	cmp	r0, #0
	beq	.L78
	b	.L77
.L79:
	.loc 1 413 0
	ldr	r0, [sp, #16]
	sub	r0, r0, #1
	str	r0, [sp, #16]
.LVL105:
	.loc 1 414 0
	mov	r0, r6
.LVL106:
	bl	shiftnumbers
.LVL107:
.L80:
	.loc 1 424 0
	add	r3, r4, #1
	add	r7, r3, r7
	ldrb	r3, [r7, #31]
.LVL108:
	.loc 1 425 0
	ldrb	r2, [r5]
	strb	r2, [r7, #31]
	.loc 1 426 0
	strb	r3, [r5]
.LVL109:
.L78:
	sub	r6, r6, #1
	sub	r5, r5, #1
	b	.L76
.LVL110:
.L81:
	.loc 1 408 0 discriminator 1
	mov	r3, #0
.L82:
.LVL111:
	.loc 1 429 0 discriminator 1
	ldr	r5, .L107+20
	ldrb	r2, [r5]
	cmp	r3, r2
	bge	.L105
.L83:
	.loc 1 430 0 discriminator 2
	ldrb	r2, [r4, r3]
	ldr	r1, [r4, #12]
	strb	r2, [r1, r3]
	.loc 1 429 0 discriminator 2
	add	r3, r3, #1
.LVL112:
	b	.L82
.L108:
	.align	2
.L107:
	.word	.LANCHOR1
	.word	.LANCHOR0
	.word	fetcheraddr
	.word	pfpixel
	.word	3614
	.word	maxsprites
.L105:
	.loc 1 431 0
	mov	r6, sp
.LVL113:
	mov	r0, #16
	ldrb	r0, [r0, r6]
	ldr	r6, [r4, #12]
	strb	r0, [r6, #9]
	.loc 1 434 0
	mov	r0, #3
	bl	get32bitdf
.LVL114:
	ldr	r5, [r4, #16]
	mov	r1, #0
	add	r0, r5, r0
	mov	r2, #192
	bl	my_memset
.LVL115:
	.loc 1 437 0
	mov	r0, #1
	bl	get32bitdf
.LVL116:
	ldr	r3, [r4, #12]
	ldr	r5, [r4, #16]
	add	r3, r3, #55
	ldrb	r1, [r3]
	add	r0, r5, r0
	mov	r2, #192
	bl	my_memset
.LVL117:
	.loc 1 439 0
	mov	r0, #0
	bl	get32bitdf
.LVL118:
	ldr	r3, [r4, #12]
	ldr	r5, [r4, #16]
	add	r3, r3, #54
	sub	r0, r0, #1
	ldrb	r1, [r3]
	add	r0, r5, r0
	mov	r2, #193
	bl	my_memset
.LVL119:
	.loc 1 443 0
	mov	r0, #0
	bl	get32bitdf
.LVL120:
	.loc 1 444 0
	ldr	r3, [r4, #12]
	ldrb	r1, [r3, #31]
	ldrb	r2, [r3, #30]
	lsl	r1, r1, #8
	add	r1, r1, r2
	ldr	r2, [r4, #20]
	.loc 1 443 0
	ldr	r5, [r4, #16]
	.loc 1 444 0
	add	r1, r2, r1
	.loc 1 443 0
	ldrb	r2, [r3, #20]
	.loc 1 445 0
	add	r3, r3, #1
	.loc 1 443 0
	add	r0, r5, r0
	ldrb	r3, [r3, #31]
	bl	my_memcpy
.LVL121:
	.loc 1 448 0
	mov	r0, #2
	bl	get32bitdf
.LVL122:
	.loc 1 449 0
	ldr	r3, [r4, #12]
	mov	r2, r3
	add	r2, r2, #57
	ldrb	r1, [r2]
	sub	r2, r2, #1
	ldrb	r2, [r2]
	lsl	r1, r1, #8
	.loc 1 448 0
	ldr	r5, [r4, #16]
	.loc 1 449 0
	add	r1, r1, r2
	ldr	r2, [r4, #20]
	.loc 1 450 0
	add	r3, r3, #1
	.loc 1 449 0
	add	r1, r2, r1
	.loc 1 448 0
	ldrb	r3, [r3, #31]
	mov	r2, #0
	add	r0, r5, r0
	bl	my_memcpy
.LVL123:
	.loc 1 452 0
	ldr	r2, .L109
	mov	r3, #0
	str	r3, [r2]
	.loc 1 453 0
	ldr	r2, .L109+4
	str	r3, [r2]
.L84:
	.loc 1 454 0 discriminator 1
	ldr	r3, .L109+4
	ldr	r6, .L109+8
	ldr	r3, [r3]
	ldr	r4, .L109+12
	cmp	r3, r6
	bne	.LCB1179
	b	.L106	@long jump
.LCB1179:
.L90:
	.loc 1 456 0
	ldr	r3, .L109
	ldr	r3, [r3]
	ldrb	r5, [r4, r3]
.LVL124:
	.loc 1 464 0
	ldr	r4, [r4, #12]
	.loc 1 463 0
	ldr	r2, .L109+16
	mov	r3, #255
	.loc 1 464 0
	add	r1, r4, r5
	.loc 1 463 0
	str	r3, [r2]
	.loc 1 464 0
	mov	r3, r1
	add	r3, r3, #42
	ldrb	r3, [r3]
	lsl	r0, r3, #24
	bpl	.L85
	.loc 1 466 0
	ldrb	r1, [r1, #11]
	cmp	r1, #152
	bls	.L85
	.loc 1 469 0
	mov	r0, #8
	mov	r6, #64
	and	r0, r3
	and	r3, r6
	lsl	r0, r0, #1
	asr	r3, r3, #3
	eor	r3, r0
	mov	r0, r1
	mov	r1, r3
	ldr	r3, .L109+20
	sub	r0, r0, #153
	add	r3, r3, #1
	orr	r1, r0
	add	r1, r3, r1
	ldrb	r3, [r1, #31]
	str	r3, [r2]
.L85:
	.loc 1 473 0
	mov	r0, #3
	bl	get32bitdf
.LVL125:
	.loc 1 474 0
	lsl	r3, r5, #1
	str	r3, [sp, #12]
	.loc 1 475 0
	mov	r1, r5
	.loc 1 474 0
	add	r3, r4, r3
	.loc 1 473 0
	ldr	r7, .L109+12
	.loc 1 475 0
	add	r1, r1, #21
	.loc 1 474 0
	add	r3, r3, #59
	.loc 1 475 0
	str	r1, [sp, #4]
	.loc 1 474 0
	ldrb	r1, [r3]
	mov	r3, r5
	.loc 1 473 0
	ldr	r6, [r7, #16]
	.loc 1 474 0
	add	r3, r3, #29
	.loc 1 476 0
	mov	r2, r5
	.loc 1 474 0
	lsl	r3, r3, #1
	ldrb	r3, [r3, r4]
	.loc 1 473 0
	add	r0, r6, r0
	.loc 1 476 0
	add	r2, r2, #33
	.loc 1 473 0
	ldr	r6, [sp, #4]
	.loc 1 476 0
	str	r2, [sp, #8]
	.loc 1 474 0
	lsl	r1, r1, #8
	.loc 1 473 0
	ldrb	r2, [r4, r6]
	.loc 1 474 0
	add	r1, r1, r3
	.loc 1 473 0
	ldr	r6, [sp, #8]
	.loc 1 474 0
	ldr	r3, [r7, #20]
	add	r1, r3, r1
	.loc 1 473 0
	ldrb	r3, [r4, r6]
	bl	my_memcpy
.LVL126:
	.loc 1 477 0
	ldr	r3, .L109+16
	mov	r4, #255
	.loc 1 479 0
	mov	r0, #1
	.loc 1 477 0
	str	r4, [r3]
	.loc 1 479 0
	bl	get32bitdf
.LVL127:
	ldr	r6, [r7, #16]
	.loc 1 480 0
	ldr	r3, [r7, #12]
	.loc 1 479 0
	add	r0, r6, r0
	.loc 1 480 0
	ldr	r6, [sp, #12]
	add	r2, r3, r6
	add	r2, r2, #77
	add	r5, r5, #38
.LVL128:
	ldrb	r1, [r2]
	lsl	r5, r5, #1
.LVL129:
	ldrb	r2, [r5, r3]
	lsl	r1, r1, #8
	.loc 1 479 0
	ldr	r5, [sp, #4]
	ldr	r6, [sp, #8]
	.loc 1 480 0
	add	r1, r1, r2
	ldr	r2, [r7, #20]
	add	r1, r2, r1
	.loc 1 479 0
	ldrb	r2, [r3, r5]
	ldrb	r3, [r3, r6]
	bl	my_memcpy
.LVL130:
	.loc 1 484 0
	ldr	r6, .L109+4
	ldr	r5, .L109+24
	ldr	r0, [r6]
	.loc 1 485 0
	ldr	r2, [sp, #4]
	.loc 1 484 0
	str	r0, [r5]
	.loc 1 485 0
	ldr	r3, [r7, #12]
	ldr	r0, [sp, #8]
	ldrb	r1, [r3, r2]
	ldrb	r2, [r3, r0]
	add	r2, r1, r2
	and	r4, r2
	str	r4, [r6]
	.loc 1 486 0
	ldr	r4, .L109
	ldr	r1, [r4]
	str	r1, [sp, #4]
	add	r2, r7, r1
	ldrb	r2, [r2, #1]
	str	r2, [sp, #8]
.LVL131:
	.loc 1 487 0
	ldr	r2, [sp, #16]
.LVL132:
	cmp	r1, r2
	beq	.L86
	.loc 1 487 0 is_stmt 0 discriminator 1
	ldr	r0, [sp, #8]
	add	r3, r3, r0
	ldrb	r3, [r3, #21]
	cmp	r3, #175
	bls	.L87
.L86:
	.loc 1 489 0 is_stmt 1
	ldr	r1, .L109+8
	.loc 1 490 0
	mov	r3, #0
	.loc 1 489 0
	str	r1, [r6]
	.loc 1 490 0
	str	r3, [r5]
.L87:
	.loc 1 496 0
	ldr	r2, [r7, #16]
	mov	r0, #4
	str	r2, [sp, #12]
	bl	get32bitdf
.LVL133:
	ldr	r3, [sp, #4]
	ldr	r2, [r6]
	add	r0, r0, r3
	ldr	r6, [sp, #4]
	ldr	r3, [r5]
	asr	r5, r6, #1
	sub	r3, r2, r3
	sub	r5, r3, r5
	ldr	r1, [sp, #12]
	asr	r5, r5, #1
	lsl	r5, r5, #24
	add	r0, r1, r0
	lsr	r5, r5, #24
	strb	r5, [r0]
	.loc 1 498 0
	ldr	r5, [sp, #8]
	ldr	r0, [r7, #12]
	add	r5, r5, #11
	add	r2, r0, r5
	ldrb	r3, [r2]
	cmp	r3, #159
	bls	.L88
	.loc 1 499 0
	mov	r1, #160
	cmp	r3, #208
	bls	.L89
	mov	r1, #96
.L89:
	.loc 1 499 0 is_stmt 0 discriminator 3
	sub	r3, r3, r1
	strb	r3, [r2]
.L88:
	.loc 1 500 0 is_stmt 1
	mov	r0, #5
	bl	get32bitdff
.LVL134:
	ldr	r1, [r4]
	ldr	r6, [r7, #16]
	add	r0, r0, r1
	ldr	r2, [r7, #12]
	add	r6, r6, r0
	ldr	r0, [sp, #8]
	add	r3, r2, r0
	add	r3, r3, #42
	ldrb	r3, [r3]
	.loc 1 501 0
	mov	r0, #7
	.loc 1 500 0
	strb	r3, [r6]
	.loc 1 501 0
	bl	get32bitdff
.LVL135:
	ldr	r1, [r4]
	ldr	r6, [r7, #16]
	add	r0, r0, r1
	ldr	r2, [r7, #12]
	add	r0, r6, r0
	ldr	r6, .L109+28
	ldrb	r3, [r2, r5]
	ldr	r1, [r6]
	add	r3, r1, r3
	add	r3, r3, #66
	ldrb	r3, [r3]
	strb	r3, [r0]
	.loc 1 503 0
	ldr	r2, [r7, #16]
	mov	r0, #5
	str	r2, [sp, #4]
	bl	get32bitdf
.LVL136:
	ldr	r3, [r4]
	ldr	r2, [r7, #12]
	ldr	r1, [sp, #4]
	add	r0, r0, r3
	add	r0, r1, r0
	ldrb	r3, [r2, r5]
	mov	r1, #224
	lsl	r1, r1, #5
	ldrb	r3, [r3, r1]
	ldr	r2, [r6]
	ldrb	r3, [r2, r3]
	strb	r3, [r0]
	.loc 1 505 0
	ldr	r3, [r7, #16]
	mov	r0, #6
	str	r3, [sp, #4]
	bl	get32bitdf
.LVL137:
	ldr	r3, [r7, #12]
	ldr	r1, [r4]
	ldrb	r3, [r3, r5]
	ldr	r2, [sp, #4]
	mov	r5, #224
	add	r0, r0, r1
	lsl	r5, r5, #5
	ldrb	r3, [r3, r5]
	add	r0, r2, r0
	ldr	r2, [r6]
	add	r3, r2, r3
	ldrb	r3, [r3, #11]
	strb	r3, [r0]
	.loc 1 506 0
	ldr	r3, [r4]
	add	r3, r3, #1
	str	r3, [r4]
	b	.L84
.LVL138:
.L106:
	.loc 1 508 0
	ldr	r3, .L109+24
	mov	r2, #1
	str	r2, [r3]
	.loc 1 509 0
	ldr	r3, [r4, #12]
	add	r3, r3, #51
	ldrb	r0, [r3]
	bl	copynybble
.LVL139:
	.loc 1 510 0
	ldr	r3, [r4, #12]
	add	r3, r3, #51
	ldrb	r0, [r3]
	lsr	r0, r0, #4
	bl	copynybble
.LVL140:
	.loc 1 511 0
	ldr	r3, [r4, #12]
	add	r3, r3, #52
	ldrb	r0, [r3]
	bl	copynybble
.LVL141:
	.loc 1 512 0
	ldr	r3, [r4, #12]
	add	r3, r3, #52
	ldrb	r0, [r3]
	lsr	r0, r0, #4
	bl	copynybble
.LVL142:
	.loc 1 513 0
	ldr	r3, [r4, #12]
	add	r3, r3, #53
	ldrb	r0, [r3]
	bl	copynybble
.LVL143:
	.loc 1 514 0
	ldr	r3, [r4, #12]
	add	r3, r3, #53
	ldrb	r0, [r3]
	lsr	r0, r0, #4
	bl	copynybble
.LVL144:
	.loc 1 516 0
	mov	r0, #0
	b	.L51
.LVL145:
.L101:
.L51:
	.loc 1 517 0
	add	sp, sp, #68
	@ sp needed for prologue
	pop	{r4, r5, r6, r7}
	pop	{r1}
	bx	r1
.L110:
	.align	2
.L109:
	.word	count
	.word	temp4
	.word	511
	.word	.LANCHOR0
	.word	mask
	.word	.LANCHOR1
	.word	temp5
	.word	fetcheraddr
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.comm	maxsprites,1,1
	.global	myGfxIndex
	.global	spritesort
	.global	maskdata
	.comm	mask,4,4
	.comm	temp5,4,4
	.comm	temp4,4,4
	.comm	count,4,4
	.comm	pfpixel,4,4
	.comm	fetcheraddr,4,4
	.global	RIOT
	.global	fetcher_address_table
	.global	C_function
	.global	queue_int
	.global	flashdata
	.global	queue
	.section	.rodata
	.set	.LANCHOR1,. + 0
.LC0:
	.byte	-128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.byte	1
	.byte	2
	.byte	4
	.byte	8
	.byte	16
	.byte	32
	.byte	64
	.byte	-128
	.byte	-128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.byte	1
	.byte	2
	.byte	4
	.byte	8
	.byte	16
	.byte	32
	.byte	64
	.byte	-128
	.type	maskdata, %object
	.size	maskdata, 32
maskdata:
	.byte	0
	.byte	1
	.byte	3
	.byte	7
	.byte	15
	.byte	31
	.byte	63
	.byte	127
	.byte	-2
	.byte	-4
	.byte	-8
	.byte	-16
	.byte	-32
	.byte	-64
	.byte	-128
	.byte	0
	.byte	0
	.byte	-128
	.byte	-64
	.byte	-32
	.byte	-16
	.byte	-8
	.byte	-4
	.byte	-2
	.byte	127
	.byte	63
	.byte	31
	.byte	15
	.byte	7
	.byte	3
	.byte	1
	.byte	0
	.data
	.align	2
	.set	.LANCHOR0,. + 0
	.type	myGfxIndex, %object
	.size	myGfxIndex, 10
myGfxIndex:
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	8
	.byte	0
	.space	2
	.type	RIOT, %object
	.size	RIOT, 4
RIOT:
	.word	1073745320
	.type	queue, %object
	.size	queue, 4
queue:
	.word	1073744896
	.type	flashdata, %object
	.size	flashdata, 4
flashdata:
	.word	3072
	.type	C_function, %object
	.size	C_function, 4
C_function:
	.word	1073745316
	.type	fetcher_address_table, %object
	.size	fetcher_address_table, 4
fetcher_address_table:
	.word	28064
	.type	spritesort, %object
	.size	spritesort, 10
spritesort:
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	8
	.byte	0
	.space	2
	.type	queue_int, %object
	.size	queue_int, 4
queue_int:
	.word	1073744896
	.text
.Letext0:
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0xb71
	.2byte	0x2
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF146
	.byte	0x1
	.4byte	.LASF147
	.4byte	.LASF148
	.4byte	.Ldebug_ranges0+0x20
	.4byte	0
	.4byte	0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x1
	.byte	0x28
	.4byte	0x284
	.uleb128 0x3
	.4byte	.LASF0
	.sleb128 0
	.uleb128 0x3
	.4byte	.LASF1
	.sleb128 1
	.uleb128 0x3
	.4byte	.LASF2
	.sleb128 2
	.uleb128 0x3
	.4byte	.LASF3
	.sleb128 3
	.uleb128 0x3
	.4byte	.LASF4
	.sleb128 4
	.uleb128 0x3
	.4byte	.LASF5
	.sleb128 5
	.uleb128 0x3
	.4byte	.LASF6
	.sleb128 6
	.uleb128 0x3
	.4byte	.LASF7
	.sleb128 7
	.uleb128 0x3
	.4byte	.LASF8
	.sleb128 8
	.uleb128 0x3
	.4byte	.LASF9
	.sleb128 9
	.uleb128 0x3
	.4byte	.LASF10
	.sleb128 10
	.uleb128 0x3
	.4byte	.LASF11
	.sleb128 11
	.uleb128 0x3
	.4byte	.LASF12
	.sleb128 12
	.uleb128 0x3
	.4byte	.LASF13
	.sleb128 13
	.uleb128 0x3
	.4byte	.LASF14
	.sleb128 14
	.uleb128 0x3
	.4byte	.LASF15
	.sleb128 15
	.uleb128 0x3
	.4byte	.LASF16
	.sleb128 16
	.uleb128 0x3
	.4byte	.LASF17
	.sleb128 17
	.uleb128 0x3
	.4byte	.LASF18
	.sleb128 18
	.uleb128 0x3
	.4byte	.LASF19
	.sleb128 19
	.uleb128 0x3
	.4byte	.LASF20
	.sleb128 20
	.uleb128 0x3
	.4byte	.LASF21
	.sleb128 21
	.uleb128 0x3
	.4byte	.LASF22
	.sleb128 22
	.uleb128 0x3
	.4byte	.LASF23
	.sleb128 23
	.uleb128 0x3
	.4byte	.LASF24
	.sleb128 24
	.uleb128 0x3
	.4byte	.LASF25
	.sleb128 25
	.uleb128 0x3
	.4byte	.LASF26
	.sleb128 26
	.uleb128 0x3
	.4byte	.LASF27
	.sleb128 27
	.uleb128 0x3
	.4byte	.LASF28
	.sleb128 28
	.uleb128 0x3
	.4byte	.LASF29
	.sleb128 29
	.uleb128 0x3
	.4byte	.LASF30
	.sleb128 30
	.uleb128 0x3
	.4byte	.LASF31
	.sleb128 31
	.uleb128 0x3
	.4byte	.LASF32
	.sleb128 32
	.uleb128 0x3
	.4byte	.LASF33
	.sleb128 33
	.uleb128 0x3
	.4byte	.LASF34
	.sleb128 34
	.uleb128 0x3
	.4byte	.LASF35
	.sleb128 35
	.uleb128 0x3
	.4byte	.LASF36
	.sleb128 36
	.uleb128 0x3
	.4byte	.LASF37
	.sleb128 37
	.uleb128 0x3
	.4byte	.LASF38
	.sleb128 38
	.uleb128 0x3
	.4byte	.LASF39
	.sleb128 39
	.uleb128 0x3
	.4byte	.LASF40
	.sleb128 40
	.uleb128 0x3
	.4byte	.LASF41
	.sleb128 41
	.uleb128 0x3
	.4byte	.LASF42
	.sleb128 42
	.uleb128 0x3
	.4byte	.LASF43
	.sleb128 43
	.uleb128 0x3
	.4byte	.LASF44
	.sleb128 44
	.uleb128 0x3
	.4byte	.LASF45
	.sleb128 45
	.uleb128 0x3
	.4byte	.LASF46
	.sleb128 46
	.uleb128 0x3
	.4byte	.LASF47
	.sleb128 47
	.uleb128 0x3
	.4byte	.LASF48
	.sleb128 48
	.uleb128 0x3
	.4byte	.LASF49
	.sleb128 49
	.uleb128 0x3
	.4byte	.LASF50
	.sleb128 50
	.uleb128 0x3
	.4byte	.LASF51
	.sleb128 51
	.uleb128 0x3
	.4byte	.LASF52
	.sleb128 52
	.uleb128 0x3
	.4byte	.LASF53
	.sleb128 53
	.uleb128 0x3
	.4byte	.LASF54
	.sleb128 54
	.uleb128 0x3
	.4byte	.LASF55
	.sleb128 55
	.uleb128 0x3
	.4byte	.LASF56
	.sleb128 56
	.uleb128 0x3
	.4byte	.LASF57
	.sleb128 57
	.uleb128 0x3
	.4byte	.LASF58
	.sleb128 58
	.uleb128 0x3
	.4byte	.LASF59
	.sleb128 59
	.uleb128 0x3
	.4byte	.LASF60
	.sleb128 60
	.uleb128 0x3
	.4byte	.LASF61
	.sleb128 61
	.uleb128 0x3
	.4byte	.LASF62
	.sleb128 62
	.uleb128 0x3
	.4byte	.LASF63
	.sleb128 63
	.uleb128 0x3
	.4byte	.LASF64
	.sleb128 64
	.uleb128 0x3
	.4byte	.LASF65
	.sleb128 65
	.uleb128 0x3
	.4byte	.LASF66
	.sleb128 66
	.uleb128 0x3
	.4byte	.LASF67
	.sleb128 67
	.uleb128 0x3
	.4byte	.LASF68
	.sleb128 68
	.uleb128 0x3
	.4byte	.LASF69
	.sleb128 69
	.uleb128 0x3
	.4byte	.LASF70
	.sleb128 70
	.uleb128 0x3
	.4byte	.LASF71
	.sleb128 71
	.uleb128 0x3
	.4byte	.LASF72
	.sleb128 72
	.uleb128 0x3
	.4byte	.LASF73
	.sleb128 73
	.uleb128 0x3
	.4byte	.LASF74
	.sleb128 74
	.uleb128 0x3
	.4byte	.LASF75
	.sleb128 75
	.uleb128 0x3
	.4byte	.LASF76
	.sleb128 76
	.uleb128 0x3
	.4byte	.LASF77
	.sleb128 77
	.uleb128 0x3
	.4byte	.LASF78
	.sleb128 78
	.uleb128 0x3
	.4byte	.LASF79
	.sleb128 79
	.uleb128 0x3
	.4byte	.LASF80
	.sleb128 80
	.uleb128 0x3
	.4byte	.LASF81
	.sleb128 81
	.uleb128 0x3
	.4byte	.LASF82
	.sleb128 82
	.uleb128 0x3
	.4byte	.LASF83
	.sleb128 83
	.uleb128 0x3
	.4byte	.LASF84
	.sleb128 84
	.uleb128 0x3
	.4byte	.LASF85
	.sleb128 85
	.uleb128 0x3
	.4byte	.LASF86
	.sleb128 86
	.uleb128 0x3
	.4byte	.LASF87
	.sleb128 87
	.uleb128 0x3
	.4byte	.LASF88
	.sleb128 88
	.uleb128 0x3
	.4byte	.LASF89
	.sleb128 89
	.uleb128 0x3
	.4byte	.LASF90
	.sleb128 90
	.uleb128 0x3
	.4byte	.LASF91
	.sleb128 91
	.uleb128 0x3
	.4byte	.LASF92
	.sleb128 92
	.uleb128 0x3
	.4byte	.LASF93
	.sleb128 93
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x1
	.byte	0x7e
	.4byte	0x29f
	.uleb128 0x3
	.4byte	.LASF94
	.sleb128 0
	.uleb128 0x3
	.4byte	.LASF95
	.sleb128 1
	.uleb128 0x3
	.4byte	.LASF96
	.sleb128 2
	.byte	0
	.uleb128 0x4
	.byte	0x1
	.4byte	.LASF149
	.byte	0x1
	.byte	0xe3
	.byte	0x1
	.4byte	0x2c4
	.byte	0x1
	.4byte	0x2c4
	.uleb128 0x5
	.ascii	"a\000"
	.byte	0x1
	.byte	0xe3
	.4byte	0x2c4
	.uleb128 0x5
	.ascii	"b\000"
	.byte	0x1
	.byte	0xe3
	.4byte	0x2c4
	.byte	0
	.uleb128 0x6
	.byte	0x1
	.byte	0x8
	.4byte	.LASF98
	.uleb128 0x7
	.byte	0x1
	.4byte	.LASF144
	.byte	0x1
	.2byte	0x114
	.byte	0x1
	.byte	0x1
	.4byte	0x2f3
	.uleb128 0x8
	.ascii	"loc\000"
	.byte	0x1
	.2byte	0x114
	.4byte	0x2f3
	.uleb128 0x9
	.4byte	.LASF97
	.byte	0x1
	.2byte	0x114
	.4byte	0x2f3
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.4byte	.LASF99
	.uleb128 0xa
	.byte	0x1
	.4byte	.LASF105
	.byte	0x1
	.byte	0xae
	.byte	0x1
	.4byte	.LFB0
	.4byte	.LFE0
	.4byte	.LLST0
	.byte	0x1
	.4byte	0x356
	.uleb128 0xb
	.4byte	.LASF100
	.byte	0x1
	.byte	0xae
	.4byte	0x356
	.byte	0x1
	.byte	0x50
	.uleb128 0xb
	.4byte	.LASF101
	.byte	0x1
	.byte	0xae
	.4byte	0x356
	.byte	0x1
	.byte	0x51
	.uleb128 0xb
	.4byte	.LASF102
	.byte	0x1
	.byte	0xae
	.4byte	0x363
	.byte	0x1
	.byte	0x52
	.uleb128 0xb
	.4byte	.LASF103
	.byte	0x1
	.byte	0xae
	.4byte	0x363
	.byte	0x1
	.byte	0x53
	.uleb128 0xc
	.ascii	"i\000"
	.byte	0x1
	.byte	0xb0
	.4byte	0x363
	.4byte	.LLST1
	.byte	0
	.uleb128 0xd
	.byte	0x4
	.4byte	0x35c
	.uleb128 0x6
	.byte	0x1
	.byte	0x8
	.4byte	.LASF104
	.uleb128 0xe
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0xa
	.byte	0x1
	.4byte	.LASF106
	.byte	0x1
	.byte	0xb5
	.byte	0x1
	.4byte	.LFB1
	.4byte	.LFE1
	.4byte	.LLST2
	.byte	0x1
	.4byte	0x3b9
	.uleb128 0xb
	.4byte	.LASF100
	.byte	0x1
	.byte	0xb5
	.4byte	0x356
	.byte	0x1
	.byte	0x50
	.uleb128 0xb
	.4byte	.LASF107
	.byte	0x1
	.byte	0xb5
	.4byte	0x363
	.byte	0x1
	.byte	0x51
	.uleb128 0xb
	.4byte	.LASF103
	.byte	0x1
	.byte	0xb5
	.4byte	0x363
	.byte	0x1
	.byte	0x52
	.uleb128 0xc
	.ascii	"i\000"
	.byte	0x1
	.byte	0xb7
	.4byte	0x363
	.4byte	.LLST3
	.byte	0
	.uleb128 0xa
	.byte	0x1
	.4byte	.LASF108
	.byte	0x1
	.byte	0xbc
	.byte	0x1
	.4byte	.LFB2
	.4byte	.LFE2
	.4byte	.LLST4
	.byte	0x1
	.4byte	0x406
	.uleb128 0xf
	.ascii	"i\000"
	.byte	0x1
	.byte	0xbc
	.4byte	0x363
	.4byte	.LLST5
	.uleb128 0xf
	.ascii	"j\000"
	.byte	0x1
	.byte	0xbc
	.4byte	0x363
	.4byte	.LLST6
	.uleb128 0x10
	.ascii	"x\000"
	.byte	0x1
	.byte	0xbc
	.4byte	0x356
	.byte	0x1
	.byte	0x52
	.uleb128 0xc
	.ascii	"t\000"
	.byte	0x1
	.byte	0xbe
	.4byte	0x363
	.4byte	.LLST7
	.byte	0
	.uleb128 0xa
	.byte	0x1
	.4byte	.LASF109
	.byte	0x1
	.byte	0xc7
	.byte	0x1
	.4byte	.LFB3
	.4byte	.LFE3
	.4byte	.LLST8
	.byte	0x1
	.4byte	0x499
	.uleb128 0x11
	.4byte	.LASF110
	.byte	0x1
	.byte	0xc7
	.4byte	0x356
	.4byte	.LLST9
	.uleb128 0x11
	.4byte	.LASF102
	.byte	0x1
	.byte	0xc7
	.4byte	0x35c
	.4byte	.LLST10
	.uleb128 0x12
	.4byte	.LVL12
	.4byte	0x3b9
	.4byte	0x45d
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x2
	.byte	0x74
	.sleb128 0
	.uleb128 0x13
	.byte	0x1
	.byte	0x51
	.byte	0x2
	.byte	0x75
	.sleb128 -1
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x30
	.byte	0
	.uleb128 0x12
	.4byte	.LVL13
	.4byte	0x3b9
	.4byte	0x47d
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x2
	.byte	0x74
	.sleb128 0
	.uleb128 0x13
	.byte	0x1
	.byte	0x51
	.byte	0x2
	.byte	0x8
	.byte	0xff
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.uleb128 0x14
	.4byte	.LVL14
	.4byte	0x3b9
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x2
	.byte	0x74
	.sleb128 0
	.uleb128 0x13
	.byte	0x1
	.byte	0x51
	.byte	0x2
	.byte	0x8
	.byte	0xff
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0x15
	.byte	0x1
	.4byte	.LASF111
	.byte	0x1
	.byte	0xcf
	.byte	0x1
	.4byte	0x2f3
	.4byte	.LFB4
	.4byte	.LFE4
	.byte	0x2
	.byte	0x7d
	.sleb128 0
	.byte	0x1
	.4byte	0x4c6
	.uleb128 0x11
	.4byte	.LASF102
	.byte	0x1
	.byte	0xcf
	.4byte	0x363
	.4byte	.LLST11
	.byte	0
	.uleb128 0x15
	.byte	0x1
	.4byte	.LASF112
	.byte	0x1
	.byte	0xd4
	.byte	0x1
	.4byte	0x2f3
	.4byte	.LFB5
	.4byte	.LFE5
	.byte	0x2
	.byte	0x7d
	.sleb128 0
	.byte	0x1
	.4byte	0x4f3
	.uleb128 0x11
	.4byte	.LASF102
	.byte	0x1
	.byte	0xd4
	.4byte	0x363
	.4byte	.LLST12
	.byte	0
	.uleb128 0x16
	.byte	0x1
	.4byte	.LASF113
	.byte	0x1
	.byte	0xd9
	.byte	0x1
	.4byte	.LFB6
	.4byte	.LFE6
	.byte	0x2
	.byte	0x7d
	.sleb128 0
	.byte	0x1
	.4byte	0x51c
	.uleb128 0x11
	.4byte	.LASF114
	.byte	0x1
	.byte	0xd9
	.4byte	0x363
	.4byte	.LLST13
	.byte	0
	.uleb128 0x17
	.4byte	0x29f
	.4byte	.LFB7
	.4byte	.LFE7
	.4byte	.LLST14
	.byte	0x1
	.4byte	0x543
	.uleb128 0x18
	.4byte	0x2b1
	.4byte	.LLST15
	.uleb128 0x19
	.4byte	0x2ba
	.byte	0x1
	.byte	0x51
	.byte	0
	.uleb128 0x1a
	.byte	0x1
	.4byte	.LASF115
	.byte	0x1
	.byte	0xe9
	.byte	0x1
	.4byte	0x363
	.4byte	.LFB8
	.4byte	.LFE8
	.4byte	.LLST16
	.byte	0x1
	.4byte	0x5e5
	.uleb128 0xf
	.ascii	"a\000"
	.byte	0x1
	.byte	0xe9
	.4byte	0x363
	.4byte	.LLST17
	.uleb128 0xf
	.ascii	"b\000"
	.byte	0x1
	.byte	0xe9
	.4byte	0x363
	.4byte	.LLST18
	.uleb128 0x1b
	.4byte	.LASF116
	.byte	0x1
	.byte	0xeb
	.4byte	0x363
	.byte	0x1
	.byte	0x52
	.uleb128 0x1c
	.ascii	"s1\000"
	.byte	0x1
	.byte	0xec
	.4byte	0x2c4
	.byte	0x1
	.byte	0x54
	.uleb128 0x1c
	.ascii	"s2\000"
	.byte	0x1
	.byte	0xec
	.4byte	0x2c4
	.byte	0x1
	.byte	0x52
	.uleb128 0x1d
	.4byte	0x29f
	.4byte	.LBB6
	.4byte	.Ldebug_ranges0+0
	.byte	0x1
	.byte	0xed
	.4byte	0x5c6
	.uleb128 0x18
	.4byte	0x2ba
	.4byte	.LLST19
	.uleb128 0x18
	.4byte	0x2b1
	.4byte	.LLST20
	.byte	0
	.uleb128 0x1e
	.4byte	0x29f
	.4byte	.LBB12
	.4byte	.LBE12
	.byte	0x1
	.byte	0xee
	.uleb128 0x1f
	.4byte	0x2ba
	.uleb128 0x18
	.4byte	0x2b1
	.4byte	.LLST21
	.byte	0
	.byte	0
	.uleb128 0x20
	.byte	0x1
	.4byte	.LASF117
	.byte	0x1
	.2byte	0x108
	.byte	0x1
	.4byte	.LFB9
	.4byte	.LFE9
	.4byte	.LLST22
	.byte	0x1
	.4byte	0x63d
	.uleb128 0x21
	.ascii	"num\000"
	.byte	0x1
	.2byte	0x108
	.4byte	0x35c
	.4byte	.LLST23
	.uleb128 0x22
	.ascii	"i\000"
	.byte	0x1
	.2byte	0x10a
	.4byte	0x363
	.4byte	.LLST24
	.uleb128 0x23
	.4byte	.LASF100
	.byte	0x1
	.2byte	0x10b
	.4byte	0x356
	.4byte	.LLST25
	.uleb128 0x24
	.4byte	.LASF101
	.byte	0x1
	.2byte	0x10c
	.4byte	0x356
	.byte	0x1
	.byte	0x50
	.byte	0
	.uleb128 0x25
	.4byte	0x2cb
	.4byte	.LFB10
	.4byte	.LFE10
	.byte	0x2
	.byte	0x7d
	.sleb128 0
	.byte	0x1
	.4byte	0x688
	.uleb128 0x18
	.4byte	0x2da
	.4byte	.LLST26
	.uleb128 0x18
	.4byte	0x2e6
	.4byte	.LLST27
	.uleb128 0x26
	.4byte	0x2cb
	.4byte	.LBB16
	.4byte	.LBE16
	.byte	0x1
	.2byte	0x114
	.uleb128 0x18
	.4byte	0x2e6
	.4byte	.LLST28
	.uleb128 0x18
	.4byte	0x2da
	.4byte	.LLST29
	.byte	0
	.byte	0
	.uleb128 0x27
	.byte	0x1
	.4byte	.LASF118
	.byte	0x1
	.2byte	0x127
	.4byte	0x363
	.4byte	.LFB11
	.4byte	.LFE11
	.4byte	.LLST30
	.byte	0x1
	.4byte	0x9d6
	.uleb128 0x22
	.ascii	"i\000"
	.byte	0x1
	.2byte	0x12a
	.4byte	0x363
	.4byte	.LLST31
	.uleb128 0x23
	.4byte	.LASF119
	.byte	0x1
	.2byte	0x12d
	.4byte	0x363
	.4byte	.LLST32
	.uleb128 0x23
	.4byte	.LASF120
	.byte	0x1
	.2byte	0x12e
	.4byte	0x363
	.4byte	.LLST33
	.uleb128 0x23
	.4byte	.LASF121
	.byte	0x1
	.2byte	0x12f
	.4byte	0x363
	.4byte	.LLST34
	.uleb128 0x28
	.4byte	.LASF122
	.byte	0x1
	.2byte	0x130
	.4byte	0x356
	.2byte	0x1c00
	.uleb128 0x24
	.4byte	.LASF123
	.byte	0x1
	.2byte	0x131
	.4byte	0x9ed
	.byte	0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x24
	.4byte	.LASF124
	.byte	0x1
	.2byte	0x13a
	.4byte	0x35c
	.byte	0x3
	.byte	0x91
	.sleb128 -84
	.uleb128 0x23
	.4byte	.LASF125
	.byte	0x1
	.2byte	0x13b
	.4byte	0x35c
	.4byte	.LLST35
	.uleb128 0x23
	.4byte	.LASF126
	.byte	0x1
	.2byte	0x13c
	.4byte	0x35c
	.4byte	.LLST36
	.uleb128 0x12
	.4byte	.LVL54
	.4byte	0xb4a
	.4byte	0x754
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x2
	.byte	0x8
	.byte	0x20
	.uleb128 0x13
	.byte	0x1
	.byte	0x51
	.byte	0x5
	.byte	0x3
	.4byte	.LANCHOR1
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x2
	.byte	0x91
	.sleb128 -56
	.byte	0
	.uleb128 0x12
	.4byte	.LVL58
	.4byte	0x499
	.4byte	0x76a
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x4
	.byte	0x75
	.sleb128 0
	.byte	0x33
	.byte	0x25
	.byte	0
	.uleb128 0x12
	.4byte	.LVL67
	.4byte	0x2cb
	.4byte	0x77e
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x2
	.byte	0x77
	.sleb128 0
	.byte	0
	.uleb128 0x12
	.4byte	.LVL70
	.4byte	0x499
	.4byte	0x794
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x4
	.byte	0x75
	.sleb128 0
	.byte	0x33
	.byte	0x26
	.byte	0
	.uleb128 0x12
	.4byte	.LVL71
	.4byte	0x2cb
	.4byte	0x7a8
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x2
	.byte	0x77
	.sleb128 0
	.byte	0
	.uleb128 0x12
	.4byte	.LVL74
	.4byte	0x499
	.4byte	0x7be
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x4
	.byte	0x75
	.sleb128 0
	.byte	0x33
	.byte	0x25
	.byte	0
	.uleb128 0x12
	.4byte	.LVL75
	.4byte	0x2cb
	.4byte	0x7d2
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x2
	.byte	0x77
	.sleb128 0
	.byte	0
	.uleb128 0x12
	.4byte	.LVL87
	.4byte	0x499
	.4byte	0x7e8
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x4
	.byte	0x75
	.sleb128 0
	.byte	0x33
	.byte	0x25
	.byte	0
	.uleb128 0x12
	.4byte	.LVL89
	.4byte	0x499
	.4byte	0x7fb
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x30
	.byte	0
	.uleb128 0x29
	.4byte	.LVL90
	.4byte	0x36a
	.uleb128 0x12
	.4byte	.LVL92
	.4byte	0x499
	.4byte	0x818
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x12
	.4byte	.LVL93
	.4byte	0x406
	.4byte	0x82f
	.uleb128 0x13
	.byte	0x1
	.byte	0x51
	.byte	0x5
	.byte	0x91
	.sleb128 -84
	.byte	0x94
	.byte	0x1
	.byte	0
	.uleb128 0x29
	.4byte	.LVL104
	.4byte	0x543
	.uleb128 0x12
	.4byte	.LVL107
	.4byte	0x4f3
	.4byte	0x84c
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.byte	0
	.uleb128 0x12
	.4byte	.LVL114
	.4byte	0x4c6
	.4byte	0x85f
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x33
	.byte	0
	.uleb128 0x12
	.4byte	.LVL115
	.4byte	0x36a
	.4byte	0x878
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x2
	.byte	0x8
	.byte	0xc0
	.uleb128 0x13
	.byte	0x1
	.byte	0x51
	.byte	0x1
	.byte	0x30
	.byte	0
	.uleb128 0x12
	.4byte	.LVL116
	.4byte	0x4c6
	.4byte	0x88b
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x31
	.byte	0
	.uleb128 0x12
	.4byte	.LVL117
	.4byte	0x36a
	.4byte	0x89f
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x2
	.byte	0x8
	.byte	0xc0
	.byte	0
	.uleb128 0x12
	.4byte	.LVL118
	.4byte	0x4c6
	.4byte	0x8b2
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x30
	.byte	0
	.uleb128 0x12
	.4byte	.LVL119
	.4byte	0x36a
	.4byte	0x8c6
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x2
	.byte	0x8
	.byte	0xc1
	.byte	0
	.uleb128 0x12
	.4byte	.LVL120
	.4byte	0x4c6
	.4byte	0x8d9
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x30
	.byte	0
	.uleb128 0x29
	.4byte	.LVL121
	.4byte	0x2fa
	.uleb128 0x12
	.4byte	.LVL122
	.4byte	0x4c6
	.4byte	0x8f5
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x32
	.byte	0
	.uleb128 0x12
	.4byte	.LVL123
	.4byte	0x2fa
	.4byte	0x908
	.uleb128 0x13
	.byte	0x1
	.byte	0x52
	.byte	0x1
	.byte	0x30
	.byte	0
	.uleb128 0x12
	.4byte	.LVL125
	.4byte	0x4c6
	.4byte	0x91b
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x33
	.byte	0
	.uleb128 0x29
	.4byte	.LVL126
	.4byte	0x2fa
	.uleb128 0x12
	.4byte	.LVL127
	.4byte	0x4c6
	.4byte	0x937
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x31
	.byte	0
	.uleb128 0x29
	.4byte	.LVL130
	.4byte	0x2fa
	.uleb128 0x12
	.4byte	.LVL133
	.4byte	0x4c6
	.4byte	0x953
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x34
	.byte	0
	.uleb128 0x12
	.4byte	.LVL134
	.4byte	0x499
	.4byte	0x966
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x35
	.byte	0
	.uleb128 0x12
	.4byte	.LVL135
	.4byte	0x499
	.4byte	0x979
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x37
	.byte	0
	.uleb128 0x12
	.4byte	.LVL136
	.4byte	0x4c6
	.4byte	0x98c
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x35
	.byte	0
	.uleb128 0x12
	.4byte	.LVL137
	.4byte	0x4c6
	.4byte	0x99f
	.uleb128 0x13
	.byte	0x1
	.byte	0x50
	.byte	0x1
	.byte	0x36
	.byte	0
	.uleb128 0x29
	.4byte	.LVL139
	.4byte	0x5e5
	.uleb128 0x29
	.4byte	.LVL140
	.4byte	0x5e5
	.uleb128 0x29
	.4byte	.LVL141
	.4byte	0x5e5
	.uleb128 0x29
	.4byte	.LVL142
	.4byte	0x5e5
	.uleb128 0x29
	.4byte	.LVL143
	.4byte	0x5e5
	.uleb128 0x29
	.4byte	.LVL144
	.4byte	0x5e5
	.byte	0
	.uleb128 0x2a
	.4byte	0x35c
	.4byte	0x9e6
	.uleb128 0x2b
	.4byte	0x9e6
	.byte	0x1f
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.4byte	.LASF127
	.uleb128 0x2c
	.4byte	0x9d6
	.uleb128 0x2d
	.4byte	.LASF128
	.byte	0x1
	.byte	0x25
	.4byte	0xa04
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	queue
	.uleb128 0xd
	.byte	0x4
	.4byte	0xa0a
	.uleb128 0x2e
	.4byte	0x35c
	.uleb128 0x2d
	.4byte	.LASF129
	.byte	0x1
	.byte	0x26
	.4byte	0xa04
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	flashdata
	.uleb128 0x2d
	.4byte	.LASF130
	.byte	0x1
	.byte	0x27
	.4byte	0xa33
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	queue_int
	.uleb128 0xd
	.byte	0x4
	.4byte	0xa39
	.uleb128 0x2e
	.4byte	0x363
	.uleb128 0x2d
	.4byte	.LASF131
	.byte	0x1
	.byte	0x83
	.4byte	0x356
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	C_function
	.uleb128 0x2d
	.4byte	.LASF132
	.byte	0x1
	.byte	0x84
	.4byte	0xa62
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	fetcher_address_table
	.uleb128 0xd
	.byte	0x4
	.4byte	0xa68
	.uleb128 0x6
	.byte	0x2
	.byte	0x7
	.4byte	.LASF133
	.uleb128 0x2d
	.4byte	.LASF134
	.byte	0x1
	.byte	0x85
	.4byte	0x356
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	RIOT
	.uleb128 0x2d
	.4byte	.LASF135
	.byte	0x1
	.byte	0x87
	.4byte	0x356
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	fetcheraddr
	.uleb128 0x2d
	.4byte	.LASF136
	.byte	0x1
	.byte	0x88
	.4byte	0x356
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	pfpixel
	.uleb128 0x2d
	.4byte	.LASF103
	.byte	0x1
	.byte	0x89
	.4byte	0x363
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	count
	.uleb128 0x2d
	.4byte	.LASF137
	.byte	0x1
	.byte	0x8e
	.4byte	0x363
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	temp4
	.uleb128 0x2d
	.4byte	.LASF138
	.byte	0x1
	.byte	0x8f
	.4byte	0x363
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	temp5
	.uleb128 0x2d
	.4byte	.LASF139
	.byte	0x1
	.byte	0x90
	.4byte	0x2f3
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	mask
	.uleb128 0x2d
	.4byte	.LASF140
	.byte	0x1
	.byte	0x95
	.4byte	0xaff
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	maskdata
	.uleb128 0x2c
	.4byte	0x9d6
	.uleb128 0x2a
	.4byte	0x2c4
	.4byte	0xb14
	.uleb128 0x2b
	.4byte	0x9e6
	.byte	0x9
	.byte	0
	.uleb128 0x2d
	.4byte	.LASF141
	.byte	0x1
	.byte	0x9d
	.4byte	0xb04
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	spritesort
	.uleb128 0x2d
	.4byte	.LASF142
	.byte	0x1
	.byte	0x9e
	.4byte	0xb04
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	myGfxIndex
	.uleb128 0x2d
	.4byte	.LASF143
	.byte	0x1
	.byte	0xa1
	.4byte	0x2c4
	.byte	0x1
	.byte	0x5
	.byte	0x3
	.4byte	maxsprites
	.uleb128 0x2f
	.byte	0x1
	.4byte	.LASF145
	.byte	0x1
	.4byte	0xb6b
	.byte	0x1
	.byte	0x1
	.4byte	0xb6b
	.uleb128 0x30
	.4byte	0xb6b
	.uleb128 0x30
	.4byte	0xb6d
	.uleb128 0x30
	.4byte	0x9e6
	.byte	0
	.uleb128 0x31
	.byte	0x4
	.uleb128 0xd
	.byte	0x4
	.4byte	0xb73
	.uleb128 0x32
	.byte	0
	.section	.debug_abbrev,"",%progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x55
	.uleb128 0x6
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x4
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0xa
	.uleb128 0x2111
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0xa
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0xa
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x55
	.uleb128 0x6
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0xa
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x27
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x28
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1c
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x29
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2a
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2b
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x2c
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2d
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x2e
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x34
	.uleb128 0xc
	.uleb128 0x3c
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x30
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x31
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x32
	.uleb128 0x26
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",%progbits
.Ldebug_loc0:
.LLST0:
	.4byte	.LFB0
	.4byte	.LCFI0
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI0
	.4byte	.LFE0
	.2byte	0x2
	.byte	0x7d
	.sleb128 20
	.4byte	0
	.4byte	0
.LLST1:
	.4byte	.LVL0
	.4byte	.LVL1
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST2:
	.4byte	.LFB1
	.4byte	.LCFI1
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI1
	.4byte	.LFE1
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	0
	.4byte	0
.LLST3:
	.4byte	.LVL2
	.4byte	.LVL3
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST4:
	.4byte	.LFB2
	.4byte	.LCFI2
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI2
	.4byte	.LFE2
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	0
	.4byte	0
.LLST5:
	.4byte	.LVL4
	.4byte	.LVL6
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL6
	.4byte	.LFE2
	.2byte	0x1
	.byte	0x50
	.4byte	0
	.4byte	0
.LLST6:
	.4byte	.LVL4
	.4byte	.LVL7
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL7
	.4byte	.LFE2
	.2byte	0x1
	.byte	0x51
	.4byte	0
	.4byte	0
.LLST7:
	.4byte	.LVL5
	.4byte	.LVL8
	.2byte	0x6
	.byte	0x73
	.sleb128 0
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST8:
	.4byte	.LFB3
	.4byte	.LCFI3
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI3
	.4byte	.LFE3
	.2byte	0x2
	.byte	0x7d
	.sleb128 16
	.4byte	0
	.4byte	0
.LLST9:
	.4byte	.LVL9
	.4byte	.LVL11
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL11
	.4byte	.LVL12-1
	.2byte	0x1
	.byte	0x52
	.4byte	.LVL12-1
	.4byte	.LVL15
	.2byte	0x1
	.byte	0x54
	.4byte	.LVL15
	.4byte	.LFE3
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST10:
	.4byte	.LVL9
	.4byte	.LVL10
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL10
	.4byte	.LFE3
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST11:
	.4byte	.LVL16
	.4byte	.LVL17
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL17
	.4byte	.LFE4
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST12:
	.4byte	.LVL18
	.4byte	.LVL19
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL19
	.4byte	.LFE5
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST13:
	.4byte	.LVL20
	.4byte	.LVL21
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL21
	.4byte	.LVL22
	.2byte	0x3
	.byte	0x70
	.sleb128 -1
	.byte	0x9f
	.4byte	.LVL22
	.4byte	.LFE6
	.2byte	0x1
	.byte	0x50
	.4byte	0
	.4byte	0
.LLST14:
	.4byte	.LFB7
	.4byte	.LCFI4
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI4
	.4byte	.LFE7
	.2byte	0x2
	.byte	0x7d
	.sleb128 8
	.4byte	0
	.4byte	0
.LLST15:
	.4byte	.LVL23
	.4byte	.LVL24
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL24
	.4byte	.LFE7
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST16:
	.4byte	.LFB8
	.4byte	.LCFI5
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI5
	.4byte	.LFE8
	.2byte	0x2
	.byte	0x7d
	.sleb128 20
	.4byte	0
	.4byte	0
.LLST17:
	.4byte	.LVL25
	.4byte	.LVL26
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL26
	.4byte	.LFE8
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST18:
	.4byte	.LVL25
	.4byte	.LVL30
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL30
	.4byte	.LFE8
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST19:
	.4byte	.LVL27
	.4byte	.LVL31
	.2byte	0x8
	.byte	0x72
	.sleb128 0
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x22
	.byte	0x23
	.uleb128 0x21
	.4byte	.LVL31
	.4byte	.LFE8
	.2byte	0xc
	.byte	0x3
	.4byte	RIOT
	.byte	0x6
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x22
	.byte	0x23
	.uleb128 0x21
	.4byte	0
	.4byte	0
.LLST20:
	.4byte	.LVL27
	.4byte	.LVL28
	.2byte	0x2
	.byte	0x70
	.sleb128 21
	.4byte	.LVL28
	.4byte	.LVL29
	.2byte	0x2
	.byte	0x70
	.sleb128 -12
	.4byte	.LVL29
	.4byte	.LVL31
	.2byte	0x8
	.byte	0x72
	.sleb128 0
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x22
	.byte	0x23
	.uleb128 0x15
	.4byte	.LVL31
	.4byte	.LFE8
	.2byte	0xc
	.byte	0x3
	.4byte	RIOT
	.byte	0x6
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x22
	.byte	0x23
	.uleb128 0x15
	.4byte	0
	.4byte	0
.LLST21:
	.4byte	.LVL32
	.4byte	.LVL33
	.2byte	0x2
	.byte	0x71
	.sleb128 -12
	.4byte	.LVL33
	.4byte	.LFE8
	.2byte	0xc
	.byte	0x3
	.4byte	RIOT
	.byte	0x6
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x22
	.byte	0x23
	.uleb128 0x15
	.4byte	0
	.4byte	0
.LLST22:
	.4byte	.LFB9
	.4byte	.LCFI6
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI6
	.4byte	.LFE9
	.2byte	0x2
	.byte	0x7d
	.sleb128 16
	.4byte	0
	.4byte	0
.LLST23:
	.4byte	.LVL36
	.4byte	.LVL37
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL37
	.4byte	.LFE9
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST24:
	.4byte	.LVL39
	.4byte	.LVL40
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL41
	.4byte	.LFE9
	.2byte	0x1
	.byte	0x53
	.4byte	0
	.4byte	0
.LLST25:
	.4byte	.LVL38
	.4byte	.LVL42
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL42
	.4byte	.LVL43
	.2byte	0x2a
	.byte	0x3
	.4byte	temp5
	.byte	0x6
	.byte	0x33
	.byte	0x24
	.byte	0x3
	.4byte	fetcheraddr
	.byte	0x6
	.byte	0x23
	.uleb128 0x39
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x38
	.byte	0x24
	.byte	0x22
	.byte	0x3
	.4byte	fetcheraddr
	.byte	0x6
	.byte	0x23
	.uleb128 0x38
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x22
	.byte	0x76
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.4byte	.LVL43
	.4byte	.LFE9
	.2byte	0x2e
	.byte	0x3
	.4byte	temp5
	.byte	0x6
	.byte	0x33
	.byte	0x24
	.byte	0x3
	.4byte	fetcheraddr
	.byte	0x6
	.byte	0x23
	.uleb128 0x39
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x38
	.byte	0x24
	.byte	0x22
	.byte	0x3
	.4byte	fetcheraddr
	.byte	0x6
	.byte	0x23
	.uleb128 0x38
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x22
	.byte	0x3
	.4byte	queue
	.byte	0x6
	.byte	0x22
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST26:
	.4byte	.LVL44
	.4byte	.LVL45
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL45
	.4byte	.LVL47
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	.LVL47
	.4byte	.LVL48
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL48
	.4byte	.LVL50
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	.LVL50
	.4byte	.LVL51
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL51
	.4byte	.LFE10
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST27:
	.4byte	.LVL44
	.4byte	.LVL46
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL46
	.4byte	.LVL47
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	.LVL47
	.4byte	.LVL49
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL49
	.4byte	.LVL50
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	.LVL50
	.4byte	.LVL52
	.2byte	0x1
	.byte	0x51
	.4byte	.LVL52
	.4byte	.LFE10
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST28:
	.4byte	.LVL50
	.4byte	.LVL52
	.2byte	0x1
	.byte	0x51
	.4byte	0
	.4byte	0
.LLST29:
	.4byte	.LVL50
	.4byte	.LVL51
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL51
	.4byte	.LVL52
	.2byte	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x50
	.byte	0x9f
	.4byte	0
	.4byte	0
.LLST30:
	.4byte	.LFB11
	.4byte	.LCFI7
	.2byte	0x2
	.byte	0x7d
	.sleb128 0
	.4byte	.LCFI7
	.4byte	.LCFI8
	.2byte	0x2
	.byte	0x7d
	.sleb128 20
	.4byte	.LCFI8
	.4byte	.LFE11
	.2byte	0x3
	.byte	0x7d
	.sleb128 88
	.4byte	0
	.4byte	0
.LLST31:
	.4byte	.LVL59
	.4byte	.LVL60
	.2byte	0x1
	.byte	0x57
	.4byte	.LVL63
	.4byte	.LVL64
	.2byte	0x1
	.byte	0x54
	.4byte	.LVL66
	.4byte	.LVL69
	.2byte	0x1
	.byte	0x57
	.4byte	.LVL69
	.4byte	.LVL73
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL77
	.4byte	.LVL84
	.2byte	0x1
	.byte	0x53
	.4byte	.LVL96
	.4byte	.LVL97
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL97
	.4byte	.LVL103
	.2byte	0x1
	.byte	0x53
	.4byte	.LVL108
	.4byte	.LVL109
	.2byte	0x6
	.byte	0x73
	.sleb128 0
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.4byte	.LVL111
	.4byte	.LVL114-1
	.2byte	0x1
	.byte	0x53
	.4byte	0
	.4byte	0
.LLST32:
	.4byte	.LVL61
	.4byte	.LVL64
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL77
	.4byte	.LVL81
	.2byte	0x2
	.byte	0x30
	.byte	0x9f
	.4byte	.LVL81
	.4byte	.LVL82
	.2byte	0x13
	.byte	0x71
	.sleb128 0
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x70
	.sleb128 0
	.byte	0x24
	.byte	0x7d
	.sleb128 0
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x37
	.byte	0x24
	.byte	0x1a
	.byte	0x9f
	.4byte	.LVL100
	.4byte	.LVL102
	.2byte	0x3
	.byte	0x76
	.sleb128 -2
	.byte	0x9f
	.4byte	.LVL102
	.4byte	.LVL103
	.2byte	0x7
	.byte	0x91
	.sleb128 -84
	.byte	0x6
	.byte	0x32
	.byte	0x1c
	.byte	0x9f
	.4byte	.LVL103
	.4byte	.LVL109
	.2byte	0x1
	.byte	0x56
	.4byte	.LVL110
	.4byte	.LVL113
	.2byte	0x1
	.byte	0x56
	.4byte	0
	.4byte	0
.LLST33:
	.4byte	.LVL65
	.4byte	.LVL66
	.2byte	0x1
	.byte	0x56
	.4byte	.LVL80
	.4byte	.LVL83
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL83
	.4byte	.LVL85
	.2byte	0x1e
	.byte	0x72
	.sleb128 0
	.byte	0x77
	.sleb128 0
	.byte	0x22
	.byte	0x23
	.uleb128 0xa
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x72
	.sleb128 0
	.byte	0x91
	.sleb128 -84
	.byte	0x6
	.byte	0x22
	.byte	0x23
	.uleb128 0xa
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x1c
	.byte	0x23
	.uleb128 0x7
	.byte	0x9f
	.4byte	.LVL85
	.4byte	.LVL86
	.2byte	0x26
	.byte	0x3
	.4byte	RIOT
	.byte	0x6
	.byte	0x77
	.sleb128 0
	.byte	0x22
	.byte	0x23
	.uleb128 0xa
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x3
	.4byte	RIOT
	.byte	0x6
	.byte	0x91
	.sleb128 -84
	.byte	0x6
	.byte	0x22
	.byte	0x23
	.uleb128 0xa
	.byte	0x94
	.byte	0x1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x1c
	.byte	0x23
	.uleb128 0x7
	.byte	0x9f
	.4byte	.LVL91
	.4byte	.LVL95
	.2byte	0x1
	.byte	0x56
	.4byte	.LVL100
	.4byte	.LVL101
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL101
	.4byte	.LVL105
	.2byte	0x3
	.byte	0x91
	.sleb128 -72
	.4byte	.LVL105
	.4byte	.LVL106
	.2byte	0x1
	.byte	0x50
	.4byte	.LVL106
	.4byte	.LVL145
	.2byte	0x3
	.byte	0x91
	.sleb128 -72
	.4byte	0
	.4byte	0
.LLST34:
	.4byte	.LVL124
	.4byte	.LVL128
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL128
	.4byte	.LVL129
	.2byte	0x3
	.byte	0x75
	.sleb128 -38
	.byte	0x9f
	.4byte	.LVL129
	.4byte	.LVL131
	.2byte	0x8
	.byte	0x91
	.sleb128 -80
	.byte	0x6
	.byte	0x8
	.byte	0x21
	.byte	0x1c
	.byte	0x9f
	.4byte	.LVL131
	.4byte	.LVL132
	.2byte	0x1
	.byte	0x52
	.4byte	.LVL132
	.4byte	.LVL138
	.2byte	0x3
	.byte	0x91
	.sleb128 -80
	.4byte	0
	.4byte	0
.LLST35:
	.4byte	.LVL56
	.4byte	.LVL58-1
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL58-1
	.4byte	.LVL60
	.2byte	0x1
	.byte	0x57
	.4byte	.LVL60
	.4byte	.LVL62
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL62
	.4byte	.LVL64
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x2
	.4byte	.LVL64
	.4byte	.LVL65
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL65
	.4byte	.LVL66
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x2
	.4byte	.LVL69
	.4byte	.LVL73
	.2byte	0x1
	.byte	0x57
	.4byte	.LVL73
	.4byte	.LVL74-1
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL74-1
	.4byte	.LVL76
	.2byte	0x1
	.byte	0x57
	.4byte	.LVL76
	.4byte	.LVL77
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL77
	.4byte	.LVL86
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x2
	.4byte	.LVL86
	.4byte	.LVL87-1
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL87-1
	.4byte	.LVL88
	.2byte	0x1
	.byte	0x57
	.4byte	.LVL88
	.4byte	.LVL89-1
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL89-1
	.4byte	.LVL91
	.2byte	0x1
	.byte	0x57
	.4byte	.LVL95
	.4byte	.LVL99
	.2byte	0x2
	.byte	0x76
	.sleb128 2
	.4byte	.LVL99
	.4byte	.LVL103
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x2
	.4byte	0
	.4byte	0
.LLST36:
	.4byte	.LVL57
	.4byte	.LVL58-1
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL58-1
	.4byte	.LVL60
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL60
	.4byte	.LVL62
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL62
	.4byte	.LVL64
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x3
	.4byte	.LVL64
	.4byte	.LVL65
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL65
	.4byte	.LVL66
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x3
	.4byte	.LVL66
	.4byte	.LVL69
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL73
	.4byte	.LVL74-1
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL74-1
	.4byte	.LVL76
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL76
	.4byte	.LVL77
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL77
	.4byte	.LVL86
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x3
	.4byte	.LVL86
	.4byte	.LVL87-1
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL88
	.4byte	.LVL89-1
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL89-1
	.4byte	.LVL95
	.2byte	0x1
	.byte	0x55
	.4byte	.LVL95
	.4byte	.LVL99
	.2byte	0x2
	.byte	0x76
	.sleb128 3
	.4byte	.LVL99
	.4byte	.LVL103
	.2byte	0x8
	.byte	0x3
	.4byte	C_function
	.byte	0x6
	.byte	0x23
	.uleb128 0x3
	.4byte	0
	.4byte	0
	.section	.debug_aranges,"",%progbits
	.4byte	0x74
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.4byte	.LFB5
	.4byte	.LFE5-.LFB5
	.4byte	.LFB6
	.4byte	.LFE6-.LFB6
	.4byte	.LFB7
	.4byte	.LFE7-.LFB7
	.4byte	.LFB8
	.4byte	.LFE8-.LFB8
	.4byte	.LFB9
	.4byte	.LFE9-.LFB9
	.4byte	.LFB10
	.4byte	.LFE10-.LFB10
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.4byte	0
	.4byte	0
	.section	.debug_ranges,"",%progbits
.Ldebug_ranges0:
	.4byte	.LBB6
	.4byte	.LBE6
	.4byte	.LBB10
	.4byte	.LBE10
	.4byte	.LBB11
	.4byte	.LBE11
	.4byte	0
	.4byte	0
	.4byte	.LFB0
	.4byte	.LFE0
	.4byte	.LFB1
	.4byte	.LFE1
	.4byte	.LFB2
	.4byte	.LFE2
	.4byte	.LFB3
	.4byte	.LFE3
	.4byte	.LFB4
	.4byte	.LFE4
	.4byte	.LFB5
	.4byte	.LFE5
	.4byte	.LFB6
	.4byte	.LFE6
	.4byte	.LFB7
	.4byte	.LFE7
	.4byte	.LFB8
	.4byte	.LFE8
	.4byte	.LFB9
	.4byte	.LFE9
	.4byte	.LFB10
	.4byte	.LFE10
	.4byte	.LFB11
	.4byte	.LFE11
	.4byte	0
	.4byte	0
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF105:
	.ascii	"my_memcpy\000"
.LASF85:
	.ascii	"junk10\000"
.LASF32:
	.ascii	"player0height\000"
.LASF78:
	.ascii	"player2color\000"
.LASF91:
	.ascii	"junk13\000"
.LASF64:
	.ascii	"player4pointerlo\000"
.LASF43:
	.ascii	"NUSIZ2\000"
.LASF144:
	.ascii	"on_off_flip\000"
.LASF44:
	.ascii	"NUSIZ3\000"
.LASF148:
	.ascii	"/data/fun/Atari/bB.1.1d.reveng28/includes/custom\000"
.LASF141:
	.ascii	"spritesort\000"
.LASF74:
	.ascii	"player9pointerlo\000"
.LASF66:
	.ascii	"player5pointerlo\000"
.LASF8:
	.ascii	"junk8a\000"
.LASF117:
	.ascii	"copynybble\000"
.LASF110:
	.ascii	"qmemory\000"
.LASF130:
	.ascii	"queue_int\000"
.LASF34:
	.ascii	"player2height\000"
.LASF13:
	.ascii	"player3x\000"
.LASF23:
	.ascii	"player3y\000"
.LASF128:
	.ascii	"queue\000"
.LASF127:
	.ascii	"sizetype\000"
.LASF118:
	.ascii	"main\000"
.LASF71:
	.ascii	"player7pointerhi\000"
.LASF89:
	.ascii	"junk12\000"
.LASF113:
	.ascii	"shiftnumbers\000"
.LASF139:
	.ascii	"mask\000"
.LASF93:
	.ascii	"junk14\000"
.LASF17:
	.ascii	"player7x\000"
.LASF27:
	.ascii	"player7y\000"
.LASF145:
	.ascii	"memcpy\000"
.LASF36:
	.ascii	"player4height\000"
.LASF107:
	.ascii	"fill_value\000"
.LASF106:
	.ascii	"my_memset\000"
.LASF114:
	.ascii	"xreg\000"
.LASF143:
	.ascii	"maxsprites\000"
.LASF90:
	.ascii	"player8color\000"
.LASF11:
	.ascii	"player1x\000"
.LASF70:
	.ascii	"player7pointerlo\000"
.LASF59:
	.ascii	"player1pointerhi\000"
.LASF33:
	.ascii	"player1height\000"
.LASF69:
	.ascii	"player6pointerhi\000"
.LASF137:
	.ascii	"temp4\000"
.LASF136:
	.ascii	"pfpixel\000"
.LASF38:
	.ascii	"player6height\000"
.LASF87:
	.ascii	"junk11\000"
.LASF5:
	.ascii	"junk5a\000"
.LASF30:
	.ascii	"player0color\000"
.LASF94:
	.ascii	"SKIP\000"
.LASF10:
	.ascii	"player0x\000"
.LASF20:
	.ascii	"player0y\000"
.LASF112:
	.ascii	"get32bitdf\000"
.LASF97:
	.ascii	"fnmask\000"
.LASF126:
	.ascii	"C_function3\000"
.LASF58:
	.ascii	"player1pointerlo\000"
.LASF67:
	.ascii	"player5pointerhi\000"
.LASF129:
	.ascii	"flashdata\000"
.LASF111:
	.ascii	"get32bitdff\000"
.LASF40:
	.ascii	"player8height\000"
.LASF14:
	.ascii	"player4x\000"
.LASF24:
	.ascii	"player4y\000"
.LASF45:
	.ascii	"NUSIZ4\000"
.LASF46:
	.ascii	"NUSIZ5\000"
.LASF47:
	.ascii	"NUSIZ6\000"
.LASF48:
	.ascii	"NUSIZ7\000"
.LASF49:
	.ascii	"NUSIZ8\000"
.LASF50:
	.ascii	"NUSIZ9\000"
.LASF101:
	.ascii	"source\000"
.LASF31:
	.ascii	"junk5\000"
.LASF18:
	.ascii	"player8x\000"
.LASF28:
	.ascii	"player8y\000"
.LASF122:
	.ascii	"HMdiv\000"
.LASF9:
	.ascii	"spritedisplay\000"
.LASF86:
	.ascii	"player6color\000"
.LASF135:
	.ascii	"fetcheraddr\000"
.LASF35:
	.ascii	"player3height\000"
.LASF104:
	.ascii	"unsigned char\000"
.LASF132:
	.ascii	"fetcher_address_table\000"
.LASF0:
	.ascii	"SpriteGfxIndex\000"
.LASF42:
	.ascii	"_NUSIZ1\000"
.LASF140:
	.ascii	"maskdata\000"
.LASF51:
	.ascii	"score\000"
.LASF63:
	.ascii	"player3pointerhi\000"
.LASF149:
	.ascii	"checkwrap\000"
.LASF6:
	.ascii	"junk6a\000"
.LASF73:
	.ascii	"player8pointerhi\000"
.LASF131:
	.ascii	"C_function\000"
.LASF146:
	.ascii	"GNU C 4.7.4 20130913 (release) [ARM/embedded-4_7-br"
	.ascii	"anch revision 202601]\000"
.LASF1:
	.ascii	"junk1\000"
.LASF2:
	.ascii	"junk2\000"
.LASF3:
	.ascii	"junk3\000"
.LASF4:
	.ascii	"junk4\000"
.LASF21:
	.ascii	"player1y\000"
.LASF77:
	.ascii	"junk6\000"
.LASF79:
	.ascii	"junk7\000"
.LASF81:
	.ascii	"junk8\000"
.LASF83:
	.ascii	"junk9\000"
.LASF119:
	.ascii	"temp2\000"
.LASF123:
	.ascii	"setbyte\000"
.LASF133:
	.ascii	"short unsigned int\000"
.LASF95:
	.ascii	"OVERLAP\000"
.LASF62:
	.ascii	"player3pointerlo\000"
.LASF61:
	.ascii	"player2pointerhi\000"
.LASF15:
	.ascii	"player5x\000"
.LASF25:
	.ascii	"player5y\000"
.LASF7:
	.ascii	"junk78\000"
.LASF96:
	.ascii	"NOOVERLAP\000"
.LASF54:
	.ascii	"COLUM0\000"
.LASF55:
	.ascii	"COLUM1\000"
.LASF103:
	.ascii	"count\000"
.LASF19:
	.ascii	"player9x\000"
.LASF29:
	.ascii	"player9y\000"
.LASF92:
	.ascii	"player9color\000"
.LASF37:
	.ascii	"player5height\000"
.LASF72:
	.ascii	"player8pointerlo\000"
.LASF60:
	.ascii	"player2pointerlo\000"
.LASF88:
	.ascii	"player7color\000"
.LASF147:
	.ascii	"main.c\000"
.LASF134:
	.ascii	"RIOT\000"
.LASF100:
	.ascii	"destination\000"
.LASF82:
	.ascii	"player4color\000"
.LASF109:
	.ascii	"memscroll\000"
.LASF102:
	.ascii	"offset\000"
.LASF108:
	.ascii	"reverse\000"
.LASF76:
	.ascii	"player1color\000"
.LASF121:
	.ascii	"Gfxindex\000"
.LASF98:
	.ascii	"char\000"
.LASF142:
	.ascii	"myGfxIndex\000"
.LASF39:
	.ascii	"player7height\000"
.LASF68:
	.ascii	"player6pointerlo\000"
.LASF12:
	.ascii	"player2x\000"
.LASF22:
	.ascii	"player2y\000"
.LASF80:
	.ascii	"player3color\000"
.LASF116:
	.ascii	"temp1\000"
.LASF120:
	.ascii	"temp3\000"
.LASF41:
	.ascii	"player9height\000"
.LASF138:
	.ascii	"temp5\000"
.LASF57:
	.ascii	"player0pointerhi\000"
.LASF16:
	.ascii	"player6x\000"
.LASF26:
	.ascii	"player6y\000"
.LASF84:
	.ascii	"player5color\000"
.LASF115:
	.ascii	"checkswap\000"
.LASF56:
	.ascii	"player0pointerlo\000"
.LASF99:
	.ascii	"unsigned int\000"
.LASF65:
	.ascii	"player4pointerhi\000"
.LASF75:
	.ascii	"player9pointerhi\000"
.LASF124:
	.ascii	"C_function1\000"
.LASF125:
	.ascii	"C_function2\000"
.LASF52:
	.ascii	"score2\000"
.LASF53:
	.ascii	"score3\000"
	.ident	"GCC: (GNU Tools for ARM Embedded Processors) 4.7.4 20130913 (release) [ARM/embedded-4_7-branch revision 202601]"
