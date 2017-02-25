	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.port_init,"ax",@progbits
.global	port_init
	.type	port_init, @function
port_init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x17,2
	sbi 0x18,2
	ret
	.size	port_init, .-port_init
	.section	.text.adc_init,"ax",@progbits
.global	adc_init
	.type	adc_init, @function
adc_init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbi 0x7,7
	in r24,0x6
	ori r24,lo8(-122)
	out 0x6,r24
	ldi r24,lo8(1999)
	ldi r25,hi8(1999)
	1: sbiw r24,1
	brne 1b
	rjmp .
	nop
	ret
	.size	adc_init, .-adc_init
	.section	.text.adc_read,"ax",@progbits
.global	adc_read
	.type	adc_read, @function
adc_read:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r25,0x7
	andi r25,lo8(-16)
	or r25,r24
	out 0x7,r25
	ldi r20,lo8(16)
	ldi r24,0
	ldi r25,0
.L7:
	sbi 0x7,6
.L5:
	sbic 0x7,0
	rjmp .L5
	in r18,0x4
	in r19,0x4+1
	add r24,r18
	adc r25,r19
	ldi r30,lo8(1999)
	ldi r31,hi8(1999)
	1: sbiw r30,1
	brne 1b
	rjmp .
	nop
	subi r20,lo8(-(-1))
	brne .L7
	ldi r18,4
	1:
	lsr r25
	ror r24
	dec r18
	brne 1b
	ret
	.size	adc_read, .-adc_read
	.section	.text.get_mA,"ax",@progbits
.global	get_mA
	.type	get_mA, @function
get_mA:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(6)
	rcall adc_read
	ldi r22,lo8(76)
	ldi r23,lo8(4)
	rcall __mulhi3
	ldi r22,0
	ldi r23,lo8(40)
	rcall __udivmodhi4
	movw r24,r22
	ret
	.size	get_mA, .-get_mA
	.section	.text.get_vf,"ax",@progbits
.global	get_vf
	.type	get_vf, @function
get_vf:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	ldi r24,lo8(7)
	rcall adc_read
	ldi r22,lo8(48)
	ldi r23,lo8(17)
	rcall __mulhi3
	mov r28,r25
	ldi r24,lo8(6)
	rcall adc_read
	ldi r22,lo8(76)
	ldi r23,lo8(4)
	rcall __mulhi3
	mov r20,r28
	lsr r20
	lsr r20
	ldi r21,0
	mov r18,r25
	lsr r18
	lsr r18
	ldi r19,0
	movw r24,r20
	sub r24,r18
	sbc r25,r19
/* epilogue start */
	pop r28
	ret
	.size	get_vf, .-get_vf
	.section	.text.get_vt,"ax",@progbits
.global	get_vt
	.type	get_vt, @function
get_vt:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(1)
	rcall adc_read
	ldi r22,lo8(-106)
	ldi r23,0
	rcall __mulhi3
	mov r24,r25
	lsr r24
	lsr r24
	ldi r25,0
	ret
	.size	get_vt, .-get_vt
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"   LED Tester   "
.LC1:
	.string	"(attache an LED)"
.LC2:
	.string	"%2d"
.LC3:
	.string	"mA V"
.LC4:
	.string	" R"
.LC5:
	.string	"%4d"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	rcall port_init
	rcall lcd_init
	rcall adc_init
	ldi r22,lo8(symbol_R)
	ldi r23,hi8(symbol_R)
	ldi r24,lo8(1)
	rcall lcd_generatechar_P
	ldi r22,lo8(symbol_KR)
	ldi r23,hi8(symbol_KR)
	ldi r24,lo8(2)
	rcall lcd_generatechar_P
	ldi r22,lo8(symbol__f)
	ldi r23,hi8(symbol__f)
	ldi r24,lo8(3)
	rcall lcd_generatechar_P
	ldi r22,lo8(symbol__t)
	ldi r23,hi8(symbol__t)
	ldi r24,lo8(4)
	rcall lcd_generatechar_P
	ldi r22,lo8(symbol__d)
	ldi r23,hi8(symbol__d)
	ldi r24,lo8(5)
	rcall lcd_generatechar_P
	mov r6,__zero_reg__
	mov r7,__zero_reg__
	mov r4,__zero_reg__
	mov r5,__zero_reg__
	mov r2,__zero_reg__
	mov r3,__zero_reg__
	ldi r19,lo8(.LC2)
	mov r14,r19
	ldi r19,hi8(.LC2)
	mov r15,r19
	ldi r28,lo8(buffer)
	ldi r29,hi8(buffer)
	ldi r20,lo8(10)
	mov r8,r20
	mov r9,__zero_reg__
.L20:
	rcall get_mA
	movw r16,r24
	rcall get_vf
	movw r12,r24
	rcall get_vt
	movw r10,r24
	cp r16,__zero_reg__
	cpc r17,__zero_reg__
	brne .L13
	lds r24,flags
	sbrs r24,1
	rjmp .L14
	andi r24,lo8(-7)
	sts flags,r24
	ldi r22,0
	ldi r24,0
	rcall lcd_setcursor
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	rcall lcd_string
	ldi r22,lo8(1)
	ldi r24,0
	rcall lcd_setcursor
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	rcall lcd_string
	rjmp .L14
.L13:
	cp r16,r2
	cpc r17,r3
	brne .L15
	cp r12,r4
	cpc r13,r5
	brne .L15
	cp r24,r6
	cpc r25,r7
	brne .+2
	rjmp .L14
.L15:
	movw r24,r10
	sub r24,r12
	sbc r25,r13
	movw r22,r16
	rcall __udivmodhi4
	movw r6,r22
	lds r18,flags
	cpi r22,16
	ldi r19,39
	cpc r23,r19
	brlo .L16
	movw r24,r22
	ldi r22,lo8(-24)
	ldi r23,lo8(3)
	rcall __udivmodhi4
	movw r6,r22
	ori r18,lo8(1)
	rjmp .L25
.L16:
	andi r18,lo8(-2)
.L25:
	sts flags,r18
	rcall lcd_clear
	ldi r24,lo8(73)
	rcall lcd_data
	ldi r24,lo8(5)
	rcall lcd_data
	push r17
	push r16
	push r15
	push r14
	push r29
	push r28
	rcall sprintf
	ldi r24,lo8(buffer)
	ldi r25,hi8(buffer)
	rcall lcd_string
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	rcall lcd_string
	ldi r24,lo8(3)
	rcall lcd_data
	movw r24,r12
	ldi r22,lo8(100)
	ldi r23,0
	rcall __udivmodhi4
	movw r24,r22
	movw r22,r8
	rcall __udivmodhi4
	mov r5,r24
	ldi r24,lo8(48)
	add r24,r22
	rcall lcd_data
	ldi r24,lo8(46)
	rcall lcd_data
	ldi r24,lo8(48)
	add r24,r5
	rcall lcd_data
	ldi r22,lo8(1)
	ldi r24,0
	rcall lcd_setcursor
	ldi r24,lo8(86)
	rcall lcd_data
	ldi r24,lo8(4)
	rcall lcd_data
	movw r24,r10
	movw r22,r8
	rcall __udivmodhi4
	mov r5,r24
	push r23
	push r22
	push r15
	push r14
	push r29
	push r28
	rcall sprintf
	ldi r24,lo8(buffer)
	ldi r25,hi8(buffer)
	rcall lcd_string
	ldi r24,lo8(46)
	rcall lcd_data
	ldi r24,lo8(48)
	add r24,r5
	rcall lcd_data
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	rcall lcd_string
	ldi r24,lo8(4)
	rcall lcd_data
	push r7
	push r6
	ldi r26,lo8(.LC5)
	ldi r27,hi8(.LC5)
	push r27
	push r26
	push r29
	push r28
	rcall sprintf
	ldi r24,lo8(buffer)
	ldi r25,hi8(buffer)
	rcall lcd_string
	lds r24,flags
	in r26,__SP_L__
	in r27,__SP_H__
	adiw r26,18
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r27
	out __SREG__,__tmp_reg__
	out __SP_L__,r26
	sbrs r24,0
	rjmp .L18
	ldi r24,lo8(2)
	rjmp .L26
.L18:
	ldi r24,lo8(1)
.L26:
	rcall lcd_data
	lds r24,flags
	ori r24,lo8(6)
	sts flags,r24
	movw r6,r10
	movw r4,r12
	movw r2,r16
.L14:
	ldi r27,lo8(79999)
	ldi r18,hi8(79999)
	ldi r19,hlo8(79999)
	1: subi r27,1
	sbci r18,0
	sbci r19,0
	brne 1b
	rjmp .
	nop
	rjmp .L20
	.size	main, .-main
.global	flags
	.section	.data.flags,"aw",@progbits
	.type	flags, @object
	.size	flags, 1
flags:
	.byte	2
.global	symbol__d
	.section	.progmem.data.symbol__d,"a",@progbits
	.type	symbol__d, @object
	.size	symbol__d, 8
symbol__d:
	.byte	0
	.byte	0
	.byte	2
	.byte	2
	.byte	14
	.byte	18
	.byte	18
	.byte	13
.global	symbol__t
	.section	.progmem.data.symbol__t,"a",@progbits
	.type	symbol__t, @object
	.size	symbol__t, 8
symbol__t:
	.byte	0
	.byte	0
	.byte	8
	.byte	8
	.byte	28
	.byte	8
	.byte	8
	.byte	6
.global	symbol__f
	.section	.progmem.data.symbol__f,"a",@progbits
	.type	symbol__f, @object
	.size	symbol__f, 8
symbol__f:
	.byte	0
	.byte	0
	.byte	4
	.byte	10
	.byte	8
	.byte	8
	.byte	30
	.byte	8
.global	symbol_KR
	.section	.progmem.data.symbol_KR,"a",@progbits
	.type	symbol_KR, @object
	.size	symbol_KR, 8
symbol_KR:
	.byte	20
	.byte	24
	.byte	20
	.byte	6
	.byte	9
	.byte	9
	.byte	6
	.byte	15
.global	symbol_R
	.section	.progmem.data.symbol_R,"a",@progbits
	.type	symbol_R, @object
	.size	symbol_R, 8
symbol_R:
	.byte	0
	.byte	14
	.byte	17
	.byte	17
	.byte	17
	.byte	10
	.byte	27
	.byte	0
	.comm	buffer,6,1
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
.global __do_copy_data
.global __do_clear_bss
