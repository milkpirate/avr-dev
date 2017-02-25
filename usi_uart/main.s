	.file	"main.c"
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
.L2:
	ldi r24,lo8(__c.1763)
	ldi r25,hi8(__c.1763)
	rcall usi_uart_tx_str_P
	ldi r18,lo8(552999)
	ldi r24,hi8(552999)
	ldi r25,hlo8(552999)
	1: subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	rjmp .L2
	.size	main, .-main
	.section	.progmem.data.__c.1763,"a",@progbits
	.type	__c.1763, @object
	.size	__c.1763, 19
__c.1763:
	.string	"\n\rHello you there!"
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
