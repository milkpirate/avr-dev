;======================
;	device	attiny10
;======================
.include	tn10def.inc

;            _____________
;           /1 °         6|
; 		O--|PB0        PB3|--O RESET
;          |      t10     |
;  		O--|GND        VCC|--O
;          |              |
; 	    O--|PB1        PB2|--O
;          |______________|

;======================
; defines
;======================
.def	temp	= r16
.def	cnt		= r17
.def	patern	= r18

;======================
; reset / setup
;======================
reset:
	ldi	temp,	213
	out OSCCAL,	temp
	
	ldi	temp,	0xD8
	out	CCP,	temp
	
	clr	temp
	out CLKPSR,	temp
	
	ldi	temp,	0xFF
	out	DDRB,	temp
	out PORTB,	temp
	
	ldi		ZL,		LOW(0x4000 + rom*2)		; load letter table address
	ldi		ZH,		HIGH(0x4000 + rom*2)	; (+0x4000 for prog spc not RAM)
	ld		patern,	Z						; letter = (Z), post inc

main:
;==========================================================
	push	patern
	
	ldi		cnt,	8
loop:
	ror		patern
	brcs	set_port
	ldi		temp,	0
	rjmp	clear_port
set_port:
	ldi		temp,	0xFF
clear_port:
	out		PORTB,	temp
	dec		cnt
	brne	loop

	pop		patern
	rjmp	main
;==========================================================

rom:
	.db	0b11110000




