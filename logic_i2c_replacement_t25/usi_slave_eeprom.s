	.file	"usi_slave_eeprom.c"
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.usi_twi_slave_init,"ax",@progbits
.global	usi_twi_slave_init
	.type	usi_twi_slave_init, @function
usi_twi_slave_init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* #APP */
 ;  95 "usi_slave_eeprom.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	in r24,0x17
	ori r24,lo8(5)
	out 0x17,r24
	in r24,0x18
	ori r24,lo8(5)
	out 0x18,r24
	cbi 0x17,0
	ldi r24,lo8(-88)
	out 0xd,r24
	ldi r24,lo8(-16)
	out 0xe,r24
/* #APP */
 ;  109 "usi_slave_eeprom.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ret
	.size	usi_twi_slave_init, .-usi_twi_slave_init
	.section	.text.__vector_13,"ax",@progbits
.global	__vector_13
	.type	__vector_13, @function
__vector_13:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r24
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	sts overflowState+1,__zero_reg__
	sts overflowState,__zero_reg__
	cbi 0x17,0
.L4:
	sbis 0x16,2
	rjmp .L3
	sbis 0x16,0
	rjmp .L4
.L3:
	sbic 0x16,0
	rjmp .L5
	ldi r24,lo8(-8)
	rjmp .L10
.L5:
	ldi r24,lo8(-88)
.L10:
	out 0xd,r24
	ldi r24,lo8(-16)
	out 0xe,r24
/* epilogue start */
	pop r24
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_13, .-__vector_13
	.section	.text.__vector_14,"ax",@progbits
.global	__vector_14
	.type	__vector_14, @function
__vector_14:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	lds r24,overflowState
	lds r25,overflowState+1
	cpi r24,2
	cpc r25,__zero_reg__
	brne .+2
	rjmp .L14
	brsh .L15
	sbiw r24,0
	breq .L16
	sbiw r24,1
	breq .L17
	rjmp .L12
.L15:
	cpi r24,4
	cpc r25,__zero_reg__
	brne .+2
	rjmp .L18
	brlo .L19
	sbiw r24,5
	brne .+2
	rjmp .L20
	rjmp .L12
.L16:
	in r24,0xf
	tst r24
	breq .L21
	in r24,0xf
	andi r24,lo8(-2)
	cpi r24,lo8(-96)
	brne .L42
.L21:
	sbis 0xf,0
	rjmp .L23
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L40
.L23:
	ldi r24,lo8(4)
	ldi r25,0
	sts overflowState+1,r25
	sts overflowState,r24
	ldi r24,lo8(-1)
	ldi r25,lo8(-1)
	sts buffer_adr+1,r25
	sts buffer_adr,r24
	rjmp .L39
.L19:
	in r24,0xf
	tst r24
	breq .L17
.L42:
	ldi r24,lo8(-88)
	out 0xd,r24
	rjmp .L41
.L17:
	lds r24,buffer_adr
	lds r25,buffer_adr+1
	adiw r24,1
	brne .L25
	sts buffer_adr+1,__zero_reg__
	sts buffer_adr,__zero_reg__
.L25:
	lds r24,buffer_adr
	lds r25,buffer_adr+1
	movw r18,r24
	subi r18,-1
	sbci r19,-1
	sts buffer_adr+1,r19
	sts buffer_adr,r18
	rcall get_rom_data
	out 0xf,r24
	ldi r24,lo8(2)
	ldi r25,0
	sts overflowState+1,r25
	sts overflowState,r24
	sbi 0x17,0
	rjmp .L41
.L14:
	ldi r24,lo8(3)
	ldi r25,0
	sts overflowState+1,r25
	sts overflowState,r24
	out 0xf,__zero_reg__
	cbi 0x17,0
	rjmp .L37
.L18:
	ldi r24,lo8(5)
	ldi r25,0
	sts overflowState+1,r25
	sts overflowState,r24
	cbi 0x17,0
.L41:
	ldi r24,lo8(112)
	rjmp .L38
.L20:
	lds r24,buffer_adr
	lds r25,buffer_adr+1
	adiw r24,1
	brne .L26
	in r24,0xf
	ldi r25,0
	sts buffer_adr+1,r25
	sts buffer_adr,r24
	rjmp .L27
.L26:
	lds r24,buffer_adr
	lds r25,buffer_adr+1
	movw r18,r24
	subi r18,-1
	sbci r19,-1
	sts buffer_adr+1,r19
	sts buffer_adr,r18
	in r18,0xf
	movw r30,r24
	subi r30,lo8(-(rxbuffer))
	sbci r31,hi8(-(rxbuffer))
	st Z,r18
.L27:
	ldi r24,lo8(4)
	ldi r25,0
.L40:
	sts overflowState+1,r25
	sts overflowState,r24
.L39:
	out 0xf,__zero_reg__
	sbi 0x17,0
.L37:
	ldi r24,lo8(126)
.L38:
	out 0xe,r24
.L12:
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_14, .-__vector_14
	.comm	overflowState,2,1
	.comm	buffer_adr,2,1
	.comm	rxbuffer,4,1
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
.global __do_clear_bss
