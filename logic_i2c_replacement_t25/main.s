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
	rcall usi_twi_slave_init
	in r24,0x7
	ori r24,lo8(35)
	out 0x7,r24
	in r24,0x6
	ori r24,lo8(-122)
	out 0x6,r24
	ldi r18,lo8(86)
.L4:
	sbi 0x6,6
.L3:
	sbic 0x6,0
	rjmp .L3
	in r24,0x5
	mov r22,r18
	rcall __udivmodqi4
	sts id_select,r24
	rjmp .L4
	.size	main, .-main
	.section	.text.get_rom_data,"ax",@progbits
.global	get_rom_data
	.type	get_rom_data, @function
get_rom_data:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(8)
	brsh .L7
	lds r30,id_select
	lsl r30
	lsl r30
	lsl r30
	rjmp .L11
.L7:
	ldi r25,lo8(-8)
	add r25,r24
	cpi r25,lo8(8)
	brsh .L9
	ldi r30,lo8(16)
	rjmp .L11
.L9:
	ldi r25,lo8(-96)
	add r25,r24
	cpi r25,lo8(16)
	brsh .L10
	ldi r30,lo8(-64)
.L11:
	add r30,r24
	rjmp .L8
.L10:
	ldi r30,lo8(48)
.L8:
	ldi r31,0
	subi r30,lo8(-(rom_data))
	sbci r31,hi8(-(rom_data))
/* #APP */
 ;  100 "main.c" 1
	lpm r24, Z
	
 ;  0 "" 2
/* #NOAPP */
	ret
	.size	get_rom_data, .-get_rom_data
.global	id_select
	.section	.bss.id_select,"aw",@nobits
	.type	id_select, @object
	.size	id_select, 1
id_select:
	.zero	1
.global	rom_data
	.section	.progmem.data.rom_data,"a",@progbits
	.type	rom_data, @object
	.size	rom_data, 49
rom_data:
	.byte	-64
	.byte	37
	.byte	9
	.byte	-127
	.byte	56
	.byte	27
	.byte	0
	.byte	0
	.byte	-64
	.byte	-87
	.byte	8
	.byte	20
	.byte	0
	.byte	0
	.byte	27
	.byte	0
	.byte	-64
	.byte	-87
	.byte	8
	.byte	5
	.byte	0
	.byte	-124
	.byte	35
	.byte	0
	.byte	52
	.byte	76
	.byte	-110
	.byte	71
	.byte	38
	.byte	51
	.byte	-81
	.byte	-79
	.byte	0
	.byte	0
	.byte	20
	.byte	0
	.byte	0
	.byte	0
	.byte	20
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	-128
	.byte	0
	.byte	0
	.byte	0
	.byte	-128
	.byte	-1
	.comm	buffer_adr,2,1
	.comm	rxbuffer,4,1
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.4.4_1229) 4.8.1"
.global __do_clear_bss
