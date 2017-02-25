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
	sbi 0x11,4
	sbi 0x11,3
	sbi 0x11,5
	ldi r24,lo8(5)
	out 0x12,r24
	sbi 0x12,5
	sbi 0x11,4
.L2:
	in r24,0x11
	com r24
	out 0x11,r24
	in r24,0x11
	out 0x18,r24
	rjmp .L2
	.size	main, .-main
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
