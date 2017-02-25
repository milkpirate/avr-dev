;======================
;   device  attiny10
;======================
;.include   tn10def.inc
;            _____________
;           /1 °         6|
;       O--|PB0        PB3|--O RESET
;          |      t10     |
;       O--|GND        VCC|--O
;          |              |
;       O--|PB1        PB2|--O
;          |______________|

;======================
; defines
;======================
.def    temp	= r16
.def	char	= r17
.def	srg		= r18
.def	cnt		= r19
.def	letter	= r20

.def	btnL	= r24
.def	btnH	= r25

.def	tmpL	= r26
.def	tmpH	= r27

.def	outL	= r28
.def	outH	= r29

;======================
; equations
;======================
.equ	OCRVAL	= 100

.equ	TX		= PB0
.equ	DAT		= PB0
.equ	LTC		= PB1
.equ	CLK		= PB2

.equ	START_FLAG	= 18
.equ	ACK			= 19	

;======================
; macros
;======================
.macro  adi		; usage: adi HiReg, value
        subi    @0,-@1
.endm

.macro  adci	; usage: adi HiReg, value
        sbci    @0,-@1
.endm

.macro	skptc	; skip if T=0
        brtc	PC+2
.endmacro

;======================
; intr. vecs
;======================
.org	0x0000		rjmp	reset		; reset Handler
.org	INT0addr	reti				; not implemented
.org	PCI0addr	reti				; not implemented
.org	ICP0addr	reti				; not implemented
.org	OVF0addr	reti				; not implemented
.org	OC0Aaddr	rjmp	isr_comp_a	; comp_a ISR vec place
.org	OC0Baddr	reti				; not implemented
.org	ACIaddr		reti				; not implemented
.org	WDTaddr		rjmp	isr_wdt		; wdt ISR
.org	VLMaddr		reti				; not implemented
.org	ADCCaddr	reti				; not implemented
.org	INT_VECTORS_SIZE				; End of vector table.

;======================
; reset / setup
;======================
reset:
    ; Initialize stack:
    ldi		temp,	HIGH(RAMEND)
    out		SPH,	temp
    ldi		temp,	LOW(RAMEND)
    out		SPL,	temp
	
	; set RC osc to 8MHz:
	ldi		temp,	0xD8		; unlock change protection with signature 0xD8
	out		CCP,	temp		; for clock prescaler change
	ldi		temp,	0			; set prescaler to 1
	out		CLKPSR,	temp

	; calibrate RC osc to 11,52MHz
	ldi		temp,	213			; calibration value
	out		OSCCAL,	temp		; (199-200 interferens with dradio @ 97,9MHz)

	; set comp match A initially to 100
	ldi		temp,	0	
	out		OCR0AH,	temp
	ldi		temp,	OCRVAL
	out		OCR0AL,	temp

	; turn timer on:
    in      temp,   TCCR0B
    sbr     temp,   CS00
    out     TCCR0B, temp

	; enable comp match A interrupt
    in      temp,   TIMSK0          ; turn overflow interrupt on
    sbr     temp,   OCIE0A
    out     TIMSK0, temp

    ; init ports
	ldi		temp,	(1<<LTC) | (1<<CLK)		; CLK, LTC = output
	out		DDRB,	temp
	ldi		temp,	(1<<DAT) | (1<<CLK)		; CLK = high
	out		PORTB,	temp					; DAT/TX = input + pullup

	; inti wdt
	in		temp,	WDTCSR
	ori		temp,	(1<<WDIE) | (1<<WDE)	; enable wdt, and int
	out		WDTCSR,	temp					; by default interrupt will fire ever 16ms
	
	; init sleep
	in		temp,	SMCR
	sbr		temp,	SM1
	out		SMCR,	temp					; set "power down"-mode

;======================
; main loop
;======================
main:
	rcall	get_button_states

	; check if there were buttons pressed?
	mov		temp,	btnH		; temp = btnH
	or		temp,	btnL		; temp |= btnL
	brne	PC+2				; temp == 0 ? no => start transmission
	rjmp	go_sleep			;			 yes => go to sleep

	ldi		letter,	START_FLAG	; transmit START_FLAG
	rcall	tx_letter

	rcall	tx_buttons			; transmit button letters
	
	ldi		letter,	ACK			; transmit ACK
	rcall	tx_letter
	
	rjmp	go_sleep			; go to sleep
    ;rjmp    main				; go_sleep jumps to main

; get button states
;======================
get_button_states:
	sbi		DDRB,	DAT			; DAT = input
	sbi		PORTB,	DAT			; DAT = pullup
	sbi		PORTB,	LTC			; latch btns in
	clr		btnL				; clear btn variable
	clr		btnH				; (and wait a little)
	cbi		PORTB,	LTC			; LTC = 0
	
	ldi		cnt,	12			; loop counter
get_btn_loop:
	clc							; C = 0
	rol		btnL				; btn <<= 1
	rol		btnH
	sbis	PINB,	DAT			; PINN[DAT] == 1 then skip (inverse logic)
	ori		btnL,	1			; btn |= 1
	cbi		PORTB,	CLK			; clock shift register
	dec		cnt					; cnt-- (and wait a little)
	sbi		PORTB,	CLK			; (doesnt affect SREG)
	brne	get_btn_loop		; cnt == 0 ? no => go on
	ret

; transmit letter of btn presses
;======================
tx_buttons:
	clt							; clear SENT flag = T
	sbi		DDRB,	TX			; TX = output
	sbi		PORTB,	TX			; TX = 1 (idle state)
	
	ldi		ZL,		LOW(0x4000 + letters*2)		; load letter table address
	ldi		ZH,		HIGH(0x4000 + letters*2)	; (+0x4000 for prog spc, not RAM)
	
	ldi		cnt,	12			; loop counter
btn_trnas_loop:
	ld		letter,	Z+			; letter = (Z++) (doesnt affect SREG)
	ror		btnH				; btn_ >>= 1,
	ror		btnL				; C = btn<0>
	brcc	next_btn			; C == 1 ? no > next btn
	skptc						; already sent data?
	rcall	tx_comma			; yes > send comma
	rcall	tx_letter			; transmit actual letter
	set							; set sent flag = T
next_btn:
	dec		cnt					; cnt--
	brne	btn_trnas_loop		; cnt == 0 ? no > go on transmitting
	
	ret

; send uart charater
;======================
tx_comma:
	ldi		letter,	','
tx_letter:						; wait till last char
	sei							; has been sent that
	nop							; we can send next one
	;cli
	mov		temp,	outL		; temp = outL | outH
	or		temp,	outH		; temp == 0 <=> outH,outL = 0
	brne	tx_letter			;			<=> out = 0

	;								 outH		outL
	; build outframe:			  [0000|0*Ph][gfed|cbaS] S=start(0), P=stop(1), *=endemarke(1)
	ldi		outH,	0b00000011	; [0000|0011][0000|0000]
	mov		outL,	letter		; [0000|0011][hged|dcba]
	clc							; C=0
	rol		outL				; [0000|0011][gfed|cba0], C=h
	rol		outH				; [0000|011h][gfed|cba0], C=0

	in		temp,	TIMSK0		; enable comp A interrupt for sending
	sbr		temp,	OCIE0A
	out		TIMSK0,	temp

	in		temp,	TIFR0		; "clear" interrupt flag
	sbr		temp,	OCF0A
	out		TIFR0,	temp

	sei							; reenable global interrupts
	ret

; prepare for sleep
;======================
go_sleep:
	in		temp,	SMCR		; set "power down"-mode
	sbr		temp,	SM1
	out		SMCR,	temp
	
	sei							; enable global interrupts
	sleep						; we wake up here again
	
	cbr		temp,	SM1
	out		SMCR,	temp		; set "power down"-mode
	
	rjmp	main

; wdt interrupt to wake up again
;======================
isr_wdt:
	in		temp,	WDTCSR
	sbr		temp,	(1<<WDIE)	; reenable wdt int.
	out		WDTCSR,	temp
	reti

; overflow interrupt
;====================== 
isr_comp_a:
	in		srg,	SREG	; save sreg

	; OCR0A += OCRVAL
	in		tmpL,	OCR0AL	; read OCR0A word
	in		tmpH,	OCR0AH
	adi		tmpL,	OCRVAL	; add OCRVAL
	adci	tmpH,	1		; take care of carry; not intuative
	out		OCR0AH,	tmpH	; write new OCRVAL back
	out		OCR0AL,	tmpL	; now we can reuse XL/XH in ISR

	; TX = outL[0]
	sbrc	outL,	0		; outL[0] == 0 ?
	sbi		PORTB,	TX		; no => TX = 1
	sbrs	outL,	0		; outL[0] == 1 ?
	cbi		PORTB,	TX		; no => TX = 0

	; out == 0 ?
	tst		outH			; out == 1 ?
	ldi		tmpL,	1		; (comp with carry 
	cpc		outL,	tmpL	; works only with registers )

	; yes => TIMSK0[OCIE0A] = 0
	brne	PC+4			; no => go on
	in		tmpL,	TIMSK0	; yes => diable comp A
	cbr		tmpL,	OCIE0A	; interrupt
	out		TIMSK0,	tmpL

	; out >>= 1
	clc						; C = 0
	ror		outH			; outH >>= 1, C = outH[0]
	ror		outL			; outL >>= 1, C = outL[0] <=> out >>= 1

	out		SREG,	srg		; restore sreg
    reti

; letter list (size = 12)
;======================
letters:
	.db		"ABCDEFGHIJKL"