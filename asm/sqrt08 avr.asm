;-----------------------------------------------------------
;	8bit Integer Sqrt (radix = sqrt(radicand))
;
;	Registers Variables:
;		rad		= radicant (0x00..0xff)
;		msk		= <don't care> (high register!)
;		tmp		= <don't care>
;
;	Result:
;		rdx		= radix
;		rad		= reminder
;		msk		= 0
;
;	Size	= 21 words
;	Clock	= ??..?? cycles (+ret)
;	Stack	= 0 byte

sqrt08:
	push	msk					; save registers to stack
	push	tmp
	
	ldi		msk,	0x40		; uint8_t msk	= 0x40
	clr		rdx					; uint8_t rdx	= 0
	clr		tmp					; uint8_t tmp	= 0

	tst		msk					; while(msk != 0) {
	breq	PC+12				; 	(exit loop it not true)
	clr		tmp					;	tmp = 0
	or		tmp,	msk			;	tmp |= msk
	or		tmp,	rdx			;	tmp |= rdx
	lsr		rdx					;	rdx >>=	 1
	cp		rad,	tmp			;	if(rad >= tmp)
	brlo	PC+3				; 	(goto if-end)
								;	{
	sub		rad,	tmp			;	rad -= tmp
	or		rdx,	msk			;	rdx |= msk
								;	}(if-end)
	lsr		msk					;
	lsr		msk					;	msk >>= 2
	rjmp	PC-12				; }(while-end)
	
	pop		tmp					; restore registers from stack
	pop		msk
	
	ret							; return rdx
	
/*
int isqrt(unsinged int radicand)
{
	unsinged int mask	= 0x40000000;
	unsinged int radix	= 0;
	unsinged int temp	= 0;
	
	while(mask != 0)
	{
		temp = radix | mask;
		radix >>= 1;
		if(radicand >= temp)
		{
			radicand -= temp;
			radix |= mask;
		}
		mask >>= 2;
	}
	
	return radix;
}
*/
	
	
	