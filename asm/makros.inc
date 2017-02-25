; Makros für AVR-Assemblerprogramme
; Dr. Michael Schramm Softwareentwicklung
; www.schramm-software.de

.macro ld_i ;(reg, 8bit-Zahl) - LDI-Ersatz für R0-R15, zerstört R16
  ldi r16,@1
  mov @0,r16
.endmacro

.macro ldi_hl ;(reg, 16bit-Zahl)
  ldi @0h,high(@1)
  ldi @0l,low(@1)
.endmacro

.macro out_i ;(I/O-reg, 8bit-Zahl) - zerstört Inhalt von R16
  ldi r16,@1
 .if @0 < 64
  out @0,r16
 .else
  sts @0,r16
 .endif
.endmacro

.macro outi_hl ;(I/O-reg, 16bit-Zahl) - zerstört Inhalt von R16
  ldi r16,high(@1)
 .if @0h < 64
  out @0h,r16
 .else
  sts @0h,r16
 .endif
  ldi r16,low(@1)
 .if @0l < 64
  out @0l,r16
 .else
  sts @0l,r16
 .endif
.endmacro

.macro push_hl
  push @0h
  push @0l
.endmacro

.macro pop_hl
  pop @0l
  pop @0h
.endmacro

.macro for ;(reg, anzahl bzw. startwert, label); für reg ab R16
  ldi @0,@1
  .set @2 = pc
.endmacro

.macro next_down ;(reg, label)
  dec @0
.if pc-@1 < 64
  brne @1
.else
  breq pc+2
  rjmp @1
.endif
.endmacro

.macro next_up ;(reg, endwert, label)
  inc @0
  cpi @0,@1
.if pc-@1 < 64
  brne @2
.else
  breq pc+2
  rjmp @2
.endif
.endmacro

.macro loop ;(label, reg) - Register muss vorbelegt sein
  .set @0 = pc
.endmacro

.macro out_ ;(I/O-Reg, reg)
.if (@0 < 64)
  out  @0,@1
.else
  sts  @0,@1
.endif
.endmacro

.macro in_ ;(reg, I/O-Reg)
.if (@1 < 64)
  in  @0,@1
.else
  lds  @0,@1
.endif
.endmacro
