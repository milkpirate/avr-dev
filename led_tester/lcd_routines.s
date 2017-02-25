	.file	"lcd_routines.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.lcd_enable,"ax",@progbits
	.type	lcd_enable, @function
lcd_enable:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x18,1
	ldi r24,lo8(24)
	1: dec r24
	brne 1b
	rjmp .
	cbi 0x18,1
	ret
	.size	lcd_enable, .-lcd_enable
	.section	.text.lcd_out,"ax",@progbits
	.type	lcd_out, @function
lcd_out:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r25,0x1b
	andi r25,lo8(-61)
	out 0x1b,r25
	in r25,0x1b
	andi r24,lo8(-16)
	lsr r24
	lsr r24
	or r24,r25
	out 0x1b,r24
	rjmp lcd_enable
	.size	lcd_out, .-lcd_out
	.section	.text.lcd_data,"ax",@progbits
.global	lcd_data
	.type	lcd_data, @function
lcd_data:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	sbi 0x18,0
	rcall lcd_out
	mov r24,r28
	swap r24
	andi r24,lo8(-16)
	rcall lcd_out
	ldi r24,lo8(56)
	1: dec r24
	brne 1b
	rjmp .
/* epilogue start */
	pop r28
	ret
	.size	lcd_data, .-lcd_data
	.section	.text.lcd_command,"ax",@progbits
.global	lcd_command
	.type	lcd_command, @function
lcd_command:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	cbi 0x18,0
	rcall lcd_out
	mov r24,r28
	swap r24
	andi r24,lo8(-16)
	rcall lcd_out
	ldi r24,lo8(51)
	1: dec r24
	brne 1b
	rjmp .
/* epilogue start */
	pop r28
	ret
	.size	lcd_command, .-lcd_command
	.section	.text.lcd_clear,"ax",@progbits
.global	lcd_clear
	.type	lcd_clear, @function
lcd_clear:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(1)
	rcall lcd_command
	ldi r24,lo8(1843)
	ldi r25,hi8(1843)
	1: sbiw r24,1
	brne 1b
	ret
	.size	lcd_clear, .-lcd_clear
	.section	.text.lcd_init,"ax",@progbits
.global	lcd_init
	.type	lcd_init, @function
lcd_init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x1a
	ori r24,lo8(60)
	out 0x1a,r24
	in r24,0x1b
	andi r24,lo8(-61)
	out 0x1b,r24
	in r24,0x17
	ori r24,lo8(3)
	out 0x17,r24
	in r24,0x18
	andi r24,lo8(-4)
	out 0x18,r24
	ldi r24,lo8(13823)
	ldi r25,hi8(13823)
	1: sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(48)
	rcall lcd_out
	ldi r24,lo8(4607)
	ldi r25,hi8(4607)
	1: sbiw r24,1
	brne 1b
	rjmp .
	nop
	rcall lcd_enable
	ldi r24,lo8(921)
	ldi r25,hi8(921)
	1: sbiw r24,1
	brne 1b
	rjmp .
	rcall lcd_enable
	ldi r24,lo8(921)
	ldi r25,hi8(921)
	1: sbiw r24,1
	brne 1b
	rjmp .
	ldi r24,lo8(32)
	rcall lcd_out
	ldi r24,lo8(4607)
	ldi r25,hi8(4607)
	1: sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(40)
	rcall lcd_command
	ldi r24,lo8(12)
	rcall lcd_command
	ldi r24,lo8(6)
	rcall lcd_command
	rjmp lcd_clear
	.size	lcd_init, .-lcd_init
	.section	.text.lcd_home,"ax",@progbits
.global	lcd_home
	.type	lcd_home, @function
lcd_home:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(2)
	rcall lcd_command
	ldi r24,lo8(1843)
	ldi r25,hi8(1843)
	1: sbiw r24,1
	brne 1b
	ret
	.size	lcd_home, .-lcd_home
	.section	.text.lcd_setcursor,"ax",@progbits
.global	lcd_setcursor
	.type	lcd_setcursor, @function
lcd_setcursor:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	swap r22
	lsl r22
	lsl r22
	andi r22,lo8(-64)
	subi r22,lo8(-(-128))
	add r24,r22
	rjmp lcd_command
	.size	lcd_setcursor, .-lcd_setcursor
	.section	.text.lcd_string,"ax",@progbits
.global	lcd_string
	.type	lcd_string, @function
lcd_string:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
.L10:
	ld r24,Y+
	tst r24
	breq .L13
	rcall lcd_data
	rjmp .L10
.L13:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	lcd_string, .-lcd_string
	.section	.text.lcd_string_P,"ax",@progbits
.global	lcd_string_P
	.type	lcd_string_P, @function
lcd_string_P:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
.L15:
	movw r24,r28
	movw r30,r28
/* #APP */
 ;  148 "lcd\lcd_routines.c" 1
	lpm r18, Z
	
 ;  0 "" 2
/* #NOAPP */
	tst r18
	breq .L17
	adiw r28,1
	movw r30,r24
/* #APP */
 ;  148 "lcd\lcd_routines.c" 1
	lpm r24, Z
	
 ;  0 "" 2
/* #NOAPP */
	rcall lcd_data
	rjmp .L15
.L17:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	lcd_string_P, .-lcd_string_P
	.section	.text.lcd_generatechar,"ax",@progbits
.global	lcd_generatechar
	.type	lcd_generatechar, @function
lcd_generatechar:
	push r14
	push r15
	push r17
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 7 */
.L__stack_usage = 7
	lsl r24
	lsl r24
	lsl r24
	ori r24,lo8(64)
	std Y+1,r22
	std Y+2,r23
	rcall lcd_command
	ldd r22,Y+1
	mov r14,r22
	ldd r23,Y+2
	mov r15,r23
	ldi r17,lo8(8)
.L20:
	movw r30,r14
	ld r24,Z+
	movw r14,r30
	rcall lcd_data
	subi r17,lo8(-(-1))
	brne .L20
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r15
	pop r14
	ret
	.size	lcd_generatechar, .-lcd_generatechar
	.section	.text.lcd_generatechar_P,"ax",@progbits
.global	lcd_generatechar_P
	.type	lcd_generatechar_P, @function
lcd_generatechar_P:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	movw r28,r22
	lsl r24
	lsl r24
	lsl r24
	ori r24,lo8(64)
	rcall lcd_command
	movw r16,r28
	subi r16,-8
	sbci r17,-1
.L23:
	movw r30,r28
/* #APP */
 ;  170 "lcd\lcd_routines.c" 1
	lpm r24, Z
	
 ;  0 "" 2
/* #NOAPP */
	rcall lcd_data
	adiw r28,1
	cp r28,r16
	cpc r29,r17
	brne .L23
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	lcd_generatechar_P, .-lcd_generatechar_P
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
