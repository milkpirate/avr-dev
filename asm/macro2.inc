.MACRO	ldx		;(Adresse)
        ldi     XL, LOW(@0)
        ldi     XH, HIGH(@0)
.ENDMACRO

.MACRO	ldy		;(Adresse)
        ldi     YL, LOW(@0)
        ldi     YH, HIGH(@0)
.ENDMACRO

.MACRO	ldz		;(Adresse)
        ldi     ZL, LOW(@0)
        ldi     ZH, HIGH(@0)
.ENDMACRO

.MACRO  lsp		;load stack pointer
        ldi		@0, low(@1)
        out		SPL, @0
        ldi		@0, high(@1)
        out		SPH, @0
.ENDMACRO

.MACRO	swap	;(Rd, Rr)
        eor     @0, @1
        eor     @1, @0
        eor     @0, @1
.ENDMACRO

.macro	addi	;Rd + K
		subi @0, -(@1)
.endmacro

.MACRO	addiw	;(RdL:RdH, K)
        subi    @0L, LOW(-@1)  
        sbci    @0H, HIGH(-@1)
.ENDMACRO

.macro	ldiw	;usage: Rd, Rr, K => Rd <- KL; Rr <- KH
		ldi		@0, low(@2)
		ldi		@1, high(@2)
.endmacro

.macro	inp		;Rd <- P, read IO reg
  .if @1 < 0x40
	in	@0, @1
  .else
  	lds	@0, @1
  .endif
.endm

.macro	outp	;P  <- Rd, write IO reg
  .if @0 < 0x40
	out	@0, @1
  .else
  	sts	@0, @1
  .endif
.endm

.macro	outi	;P  <- K, write immediate
  ldi r16,@1
 .if @0 < 64
  out @0,r16
 .else
  sts @0,r16
 .endif
.endmacro

.macro	bbis	;port,bit,target
  .if @0 < 0x20
 	sbic	@0, @1
	rjmp	@2
  .elif @0 < 0x40
	in	zl, @0
	sbrc	zl, @1
	rjmp	@2
  .else
	lds	zl, @0
	sbrc	zl, @1
	rjmp	@2
  .endif
.endm

.macro	bbic	;port,bit,target, branch if bit in IO reg. clear
  .if @0 < 0x20
 	sbis	@0, @1
	rjmp	@2
  .elif @0 < 0x40
	in	zl, @0
	sbrs	zl, @1
	rjmp	@2
  .else
	lds	zl, @0
	sbrs	zl, @1
	rjmp	@2
  .endif
.endm