	.file	"USI_UART.c"
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.reverse_byte,"ax",@progbits
.global	reverse_byte
	.type	reverse_byte, @function
reverse_byte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* #APP */
 ;  96 "USI_UART.c" 1
	ldi r18, 0x80
	reverse_byte_loop_6:
	rol r25
	ror r18
	brcc reverse_byte_loop_6
	
 ;  0 "" 2
/* #NOAPP */
	mov r24,r18
	ret
	.size	reverse_byte, .-reverse_byte
	.section	.text.usi_uart_init_tx,"ax",@progbits
.global	usi_uart_init_tx
	.type	usi_uart_init_tx, @function
usi_uart_init_tx:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* #APP */
 ;  111 "USI_UART.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	out 0x32,__zero_reg__
	in r24,0x2c
	ori r24,lo8(1)
	out 0x2c,r24
	ldi r24,lo8(1)
	out 0x33,r24
	ldi r24,lo8(2)
	out 0x38,r24
	in r24,0x39
	ori r24,lo8(2)
	out 0x39,r24
	ldi r24,lo8(84)
	out 0xd,r24
	ldi r24,lo8(-1)
	out 0xf,r24
	out 0xe,r24
	sbi 0x17,1
	lds r24,USI_UART_status
	ori r24,lo8(1<<0)
	sts USI_UART_status,r24
/* #APP */
 ;  130 "USI_UART.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ret
	.size	usi_uart_init_tx, .-usi_uart_init_tx
	.section	.text.usi_uart_tx_byte,"ax",@progbits
.global	usi_uart_tx_byte
	.type	usi_uart_tx_byte, @function
usi_uart_tx_byte:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	lds r28,uart_tx_head
	subi r28,lo8(-(1))
	andi r28,lo8(15)
.L5:
	lds r25,uart_tx_tail
	cp r28,r25
	breq .L5
	rcall reverse_byte
	mov r30,r28
	ldi r31,0
	subi r30,lo8(-(uart_tx_buff))
	sbci r31,hi8(-(uart_tx_buff))
	st Z,r24
	sts uart_tx_head,r28
	lds r24,USI_UART_status
	sbrc r24,0
	rjmp .L3
/* epilogue start */
	pop r28
	rjmp usi_uart_init_tx
.L3:
/* epilogue start */
	pop r28
	ret
	.size	usi_uart_tx_byte, .-usi_uart_tx_byte
	.section	.text.usi_uart_tx_str,"ax",@progbits
.global	usi_uart_tx_str
	.type	usi_uart_tx_str, @function
usi_uart_tx_str:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
.L9:
	ld r24,Y+
	tst r24
	breq .L11
	rcall usi_uart_tx_byte
	rjmp .L9
.L11:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	usi_uart_tx_str, .-usi_uart_tx_str
	.section	.text.usi_uart_tx_str_P,"ax",@progbits
.global	usi_uart_tx_str_P
	.type	usi_uart_tx_str_P, @function
usi_uart_tx_str_P:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
.L13:
	movw r24,r28
	movw r30,r28
/* #APP */
 ;  193 "USI_UART.c" 1
	lpm r18, Z
	
 ;  0 "" 2
/* #NOAPP */
	tst r18
	breq .L15
	adiw r28,1
	movw r30,r24
/* #APP */
 ;  193 "USI_UART.c" 1
	lpm r24, Z
	
 ;  0 "" 2
/* #NOAPP */
	rcall usi_uart_tx_byte
	rjmp .L13
.L15:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	usi_uart_tx_str_P, .-usi_uart_tx_str_P
	.section	.text.__vector_14,"ax",@progbits
.global	__vector_14
	.type	__vector_14, @function
__vector_14:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r24
	push r25
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 7 */
.L__stack_usage = 7
	lds r24,USI_UART_status
	sbrs r24,1
	rjmp .L17
	lds r24,USI_UART_status
	andi r24,lo8(~(1<<1))
	sts USI_UART_status,r24
	ldi r24,lo8(-5)
	out 0xe,r24
	lds r24,usi_uart_tx_data
	lsl r24
	lsl r24
	lsl r24
	ori r24,lo8(7)
	rjmp .L20
.L17:
	lds r25,uart_tx_head
	lds r24,uart_tx_tail
	cp r25,r24
	breq .L19
	lds r24,USI_UART_status
	ori r24,lo8(1<<1)
	sts USI_UART_status,r24
	lds r30,uart_tx_tail
	subi r30,lo8(-(1))
	andi r30,lo8(15)
	sts uart_tx_tail,r30
	ldi r31,0
	subi r30,lo8(-(uart_tx_buff))
	sbci r31,hi8(-(uart_tx_buff))
	ld r24,Z
	sts usi_uart_tx_data,r24
	ldi r24,lo8(-5)
	out 0xe,r24
	lds r24,usi_uart_tx_data
	lsr r24
	lsr r24
	ori r24,lo8(-128)
.L20:
	out 0xf,r24
	rjmp .L16
.L19:
	lds r24,USI_UART_status
	andi r24,lo8(~(1<<0))
	sts USI_UART_status,r24
	out 0x33,__zero_reg__
	in r24,0x18
	ori r24,lo8(15)
	out 0x18,r24
	in r24,0x17
	andi r24,lo8(-16)
	out 0x17,r24
	out 0xd,__zero_reg__
	ldi r24,lo8(32)
	out 0x3a,r24
	in r24,0x3b
	ori r24,lo8(32)
	out 0x3b,r24
.L16:
/* epilogue start */
	pop r31
	pop r30
	pop r25
	pop r24
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_14, .-__vector_14
	.section	.text.__vector_5,"ax",@progbits
.global	__vector_5
	.type	__vector_5, @function
__vector_5:
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
	in r24,0x32
	subi r24,lo8(-(-96))
	out 0x32,r24
/* epilogue start */
	pop r24
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_5, .-__vector_5
	.section	.bss.USI_UART_status,"aw",@nobits
	.type	USI_UART_status, @object
	.size	USI_UART_status, 1
USI_UART_status:
	.zero	1
	.section	.bss.uart_tx_tail,"aw",@nobits
	.type	uart_tx_tail, @object
	.size	uart_tx_tail, 1
uart_tx_tail:
	.zero	1
	.section	.bss.uart_tx_head,"aw",@nobits
	.type	uart_tx_head, @object
	.size	uart_tx_head, 1
uart_tx_head:
	.zero	1
	.section	.bss.uart_tx_buff,"aw",@nobits
	.type	uart_tx_buff, @object
	.size	uart_tx_buff, 16
uart_tx_buff:
	.zero	16
	.section	.bss.usi_uart_tx_data,"aw",@nobits
	.type	usi_uart_tx_data, @object
	.size	usi_uart_tx_data, 1
usi_uart_tx_data:
	.zero	1
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
.global __do_clear_bss
