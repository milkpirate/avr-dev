	.file	"main.c"
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.uart_tx_str,"ax",@progbits
.global	uart_tx_str
	.type	uart_tx_str, @function
uart_tx_str:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(16)
.L2:
	movw r30,r24
	ld r18,Z+
	movw r24,r30
	tst r18
	breq .L7
.L4:
/* #APP */
 ;  79 "main.c" 1
	sei
 ;  0 "" 2
 ;  80 "main.c" 1
	nop
 ;  0 "" 2
 ;  81 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	in r20,0x12
	in r21,0x12+1
	or r20,r21
	brne .L4
	lsl r18
	sbc r19,r19
	ori r19,6
	out 0x12+1,r19
	out 0x12,r18
	in r18,0x39
	ori r18,lo8(16)
	out 0x39,r18
	out 0x38,r22
/* #APP */
 ;  91 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	rjmp .L2
.L7:
/* epilogue start */
	ret
	.size	uart_tx_str, .-uart_tx_str
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"hello hello"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(-67)
	out 0x31,r24
	in r25,__SREG__
/* #APP */
 ;  60 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(100)
	out 0x29,r24
	ldi r24,lo8(1)
	out 0x33,r24
	in r24,0x39
	andi r24,lo8(-17)
	out 0x39,r24
	ldi r24,lo8(16)
	out 0x38,r24
	sbi 0x18,3
	sbi 0x17,3
	out 0x12+1,__zero_reg__
	out 0x12,__zero_reg__
	out __SREG__,r25
.L9:
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	rcall uart_tx_str
	ldi r18,lo8(575999)
	ldi r24,hi8(575999)
	ldi r25,hlo8(575999)
	1: subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	rjmp .L9
	.size	main, .-main
	.section	.text.__vector_10,"ax",@progbits
.global	__vector_10
	.type	__vector_10, @function
__vector_10:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r24
	push r25
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 7 */
.L__stack_usage = 7
	in r19,__SREG__
	in r24,0x12
	in r25,0x12+1
	in r18,0x29
	subi r18,lo8(-(100))
	out 0x29,r18
	sbrs r24,0
	rjmp .L11
	sbi 0x18,3
	rjmp .L12
.L11:
	cbi 0x18,3
.L12:
	cpi r24,1
	cpc r25,__zero_reg__
	brne .L13
	in r18,0x39
	andi r18,lo8(-17)
	out 0x39,r18
.L13:
	lsr r25
	ror r24
	out 0x12+1,r25
	out 0x12,r24
	out __SREG__,r19
/* epilogue start */
	pop r25
	pop r24
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_10, .-__vector_10
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
.global __do_copy_data
