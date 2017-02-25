; fast: 15 words, 15 ticks +ret
rev_byte_fast:
	mov		y,	x			; y = x
	andi	x,	0b10101010	; x &= 0x55
	lsl		x				; x <<= 1
	lsl		y				; y >>= 1
	andi	y,	0b10101010	; y &= 0x55
	or		x,	y			; x |= y
; x = ((x & 0x55) << 1) | ((x >> 1) & 0x55)
	mov		y,	x			; y = x
	andi	x,	0b00110011	; x &= 0x33
	lsl		x
	lsl		x				; x <<= 2
	lsr		y
	lsr		y				; y >>= 2
	andi	y,	0b00110011	; y &= 0x33
	or		x,	y			; x |= y
	swap	x
; x = ((x & 0x33) << 2) | ((x >> 2) & 0x33)
; ==> x = [abcd|efgh] ~~> x = [hgfe|dcba]
	ret

; small: 5 words, 41 ticks +ret
rev_byte_small:
	ldi		r18,	8	;1
swap_em:
	ror		r16			;1
	rol		r17			;1
	dec 	r18			;1
	brne	swap_em		;2
	ret