.global sendNLF
sendNLF:
	sbi		PORTB,	TX
	;nop					; +40ns
	cbi		PORTB,	TX
	ret
	
send:
	; Z = data pointer
	; X = manchester pointer
	
	in		sreg,	SREG				; backup SREG
	cli									; turn interrupts off
	
	; save registers to stack
	push	cnt2
	push	data
	push	pat
	push	patf
	push	manL
	push	manH
	
	; let X point to manch. table (for latter use *)
	clr		manL
	clr		manH
	subi	manL,	LOW(-(manTabl))		
	sbci	manH,	HIGH(-(manTabl))
	
	; prepartre first data send (time cirtical)
	mov		cnt,	LENGTH
	ld		data,	Z+					; load data byte to data
	mov		manL,	data				; lookup
	andi	manL,	0b00001111			; mask lower nibble
	subi	manL,	LOW(-(manTabl))		; lookup nibbble => manch.
	
sendLoop:
	tst		cnt							; all sent?
	brne	sendPre						; no => send preamble
	rjmp	done						; yes => done
	
sendPre:
	ldi		cnt2,	14					; send 14x preamble
	ldi		pat,	0b01100110			; standard 0x55 pattern
	ldi		patf,	0b01100101			; final pattern
	
	;-2==========================================================================
	out		USIDR,	pat					; write pat to USI data reg.			1
	sbi		USICR,	USIWM0				; 1 turn USI module on					1
	rjmp	PC+1						;										2
	rjmp	PC+1						;										2
	rjmp	PC+1						;										2
	
preLoop:								;										~
	;-1======================================================================= =8
	out		USIDR,	pat					; send final pattern					1
	rjmp	PC+1						;										2
	rjmp	PC+1						;										2
	dec		cnt2						; cnt2--								1
	brne	preLoop						;								   1 / ^2
	nop									;										1
	;0======================================================================== =8
	out		USIDR,	patf				; send final pattern					1
	rjmp	PC+1						;										2
	nop									;										1
	
keepGoing:								;										~
	nop									;										1
	ld		pat,	X					; get first data nibble manch enc *		2
	swap	data						; swap to next data nibble				1
	;1======================================================================== =8
	out		USIDR,	pat					; send data nibble manch enc			1
	mov		manL,	data				; encode next data nibble				1
	andi	manL,	0x00001111			;										1
	subi	manL,	LOW(-(manTabl))		;										1
	ld		pat,	X					;										2
	ld		data,	Z+					; load next data byte					2
	;2======================================================================== =8
	out		USIDR,	pat					; OK									1
	mov		manL,	data				; encode next data nibble				1
	andi	manL,	0x00001111			;										1
	subi	manL,	LOW(-(manTabl))		;										1
	ld		pat,	X					;										2
	swap	data						;										1
	mov		manL,	data				;										1
	;3======================================================================== =8
	out		USIDR,	pat					;										1
	andi	manL,	0x00001111			;										1
	subi	manL,	LOW(-(manTabl))		;										1
	ld		pat,	X					;										2
	ld		data,	Z+					;										2
	mov		manL,	data				;										1
	;4======================================================================== =8
	out		USIDR,	pat					;										1
	andi	manL,	0x00001111			;										1
	subi	manL,	LOW(-(manTabl))		;										1
	ld		pat,	X					;										2
	swap	data						;										1
	mov		manL,	data				;										1
	andi	manL,	0b00001111			;										1
	;5======================================================================== =8
	out		USIDR,	pat					;										1
	subi	manL,	LOW(-(manTabl))		;										1
	ld		pat,	X					;										2
	ld		data,	Z+					;										2
	mov		manL,	data				;										1
	andi	manL,	0x00001111			;										1
	;6======================================================================== =8
	out		USIDR,	pat					;										1
	subi	manL,	LOW(-(manTabl))		;										1
	ld		pat,	X					;										2
	swap	data						;										1
	mov		manL,	data				;										1
	andi	manL,	0x00001111			;										1
	subi	manL,	LOW(-(manTabl))		;										1
	;7======================================================================== =8
	out		USIDR,	pat					;										1
	ld		pat,	X					;										2
	ld		data,	Z+					;										2
	mov		manL,	data				;										1
	andi	manL,	0x00001111			;										1
	subi	manL,	LOW(-(manTabl))		;										1
	;8======================================================================== =8
	out		USIDR,	pat					;										1
	dec		cnt							;										1
	brne	keepGoing					;								   1 / ^2
	
done:									;										~
	rjmp	PC+1						;										2
	rjmp	PC+1						;										2
	clr		pat							; clean up								1
	;9======================================================================== =8
	out		USIDR,	pat
	cbi		USICR,	USIWM0
	
	; restore registers from stack
	pop		manH
	pop		manL
	pop		patf
	pop		pat
	pop		data
	pop		cnt2
	
	ret
	
	
	
	
	
	
	
	
	
	
	

	