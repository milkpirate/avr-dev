.def fuse	= r16
;=====================================================================
;		read fuse bits, 12words of program memory
;=====================================================================
read_fuse_low:
	ldi		ZL,		0	; Z = 0x0000
	rjmp	read_bits
read_lock_bits:
	ldi		ZL,		1	; Z = 0x0001
	rjmp	read_bits
read_ext_bits:
	ldi		ZL,		2	; Z = 0x0002
	rjmp	read_bits
read_fuse_high:
	ldi		ZL,		3	; Z = 0x0003
read_bits:
	ldi		ZH,		0
	ldi		fuse,	(1<<BLBSET) | (1<<SELFPRGEN)
	out		SPMCSR,	fuse
	lpm		fuse
	ret
;=====================================================================




.def fuse	= r16

ldi		ZL,		0
;=====================================================================
;		read fuse bits, 8words of program memory
;		(+1word to load 0 to ZL before call)
;=====================================================================
read_fuse_high:		; Z = 0x0003
	inc		ZL
read_ext_bits:		; Z = 0x0002
	inc		ZL
read_lock_bits:		; Z = 0x0001
	inc		ZL
read_fuse_low:		; Z = 0x0000
	ldi		ZH,		0
	ldi		fuse,	(1<<BLBSET) | (1<<SELFPRGEN)
	out		SPMCSR,	fuse
	lpm		fuse,	Z
	ret
;=====================================================================