;-----------------------------------------------------------------------------:
; 8bit/8bit Unsigned Division
;
; Register Variables
;  Call:  dvd = dividend (0x00..0xff)
;         dvr = divisor (0x01..0x7f)
;         mod = <don't care>
;         cnt = <don't care> (high register must be allocated)
;
;  Result:	dvd = dvd / dvr
;         	dvr = <not changed>
;         	mod  = dvd % dvr
;         	cnt   = 0
;
; Size  = 11 words
; Clock = 66..74 cycles  (+ret)
; Stack = 0 byte

divu08:		
	clr		mod				; mod = 0
	ldi		cnt,	8		; cnt = 8
	
							;do{
	lsl		dvd				; dvd *= 2
	rol		mod				; mod *= 2 + carry
	cp		mod,	dvr		; if (mod => dvr)
	brlo	PC+3			; {
	inc		dvd				;	dvd++
	sub		mod,	dvr		;	mod -= dvr }
	dec		cnt				;}
	brne	PC-7			;while(--cnt)
			
	/*
round:
	mov		cnt,	dvr		; cnt = dvr
	lsr		cnt				; cnt /= 2
	cp		cnt,	mod		; if (mod > cnt)
	brsh	PC+5			; {
	inc		dvd				; dvd++
	mov		cnt,	dvr		; cnt = dvr
	sub		dvr,	mod		; cnt -= mod
	mov		mod,	cnt		; mod = cnt }
	*/
	
	ret