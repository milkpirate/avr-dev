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

;======================
; reset / setup
;======================
reset:
	ldi	temp,	213
	out OSCCAL,	temp

; write signature for change enable of protected I/O register
	ldi	temp,	0xD8
	out	CCP,	temp

; set clock prescaler to 1
	clr	temp
	out CLKPSR,	temp
	
main:
	rjmp	main