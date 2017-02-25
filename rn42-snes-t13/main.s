	.file	"main.c"
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
 ;  GNU C99 (GCC) version 6.1.0 (avr)
 ; 	compiled by GNU C version 5.3.0, GMP version 4.3.2, MPFR version 2.4.2, MPC version 0.8.1, isl version 0.15
 ;  GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 ;  options passed:  -fpreprocessed main.i -mn-flash=1 -mno-skip-bug
 ;  -mmcu=avr25 -msp8 -auxbase-strip obj\Release\main.o -Os -Wall -std=c99
 ;  -std=c99 -fverbose-asm
 ;  options enabled:  -faggressive-loop-optimizations -falign-functions
 ;  -falign-jumps -falign-labels -falign-loops -fauto-inc-dec
 ;  -fbranch-count-reg -fcaller-saves -fchkp-check-incomplete-type
 ;  -fchkp-check-read -fchkp-check-write -fchkp-instrument-calls
 ;  -fchkp-narrow-bounds -fchkp-optimize -fchkp-store-bounds
 ;  -fchkp-use-static-bounds -fchkp-use-static-const-bounds
 ;  -fchkp-use-wrappers -fcombine-stack-adjustments -fcommon -fcompare-elim
 ;  -fcprop-registers -fcrossjumping -fcse-follow-jumps -fdefer-pop
 ;  -fdevirtualize -fdevirtualize-speculatively -fdwarf2-cfi-asm
 ;  -fearly-inlining -feliminate-unused-debug-types
 ;  -fexpensive-optimizations -fforward-propagate -ffunction-cse -fgcse
 ;  -fgcse-lm -fgnu-runtime -fgnu-unique -fguess-branch-probability
 ;  -fhoist-adjacent-loads -fident -fif-conversion -fif-conversion2
 ;  -findirect-inlining -finline -finline-atomics -finline-functions
 ;  -finline-functions-called-once -finline-small-functions -fipa-cp
 ;  -fipa-cp-alignment -fipa-icf -fipa-icf-functions -fipa-icf-variables
 ;  -fipa-profile -fipa-pure-const -fipa-ra -fipa-reference -fipa-sra
 ;  -fira-hoist-pressure -fira-share-save-slots -fira-share-spill-slots
 ;  -fisolate-erroneous-paths-dereference -fivopts -fkeep-static-consts
 ;  -fleading-underscore -flifetime-dse -flra-remat -flto-odr-type-merging
 ;  -fmath-errno -fmerge-constants -fmerge-debug-strings
 ;  -fmove-loop-invariants -fomit-frame-pointer -foptimize-sibling-calls
 ;  -fpartial-inlining -fpeephole -fpeephole2 -fplt -fprefetch-loop-arrays
 ;  -freg-struct-return -freorder-blocks -freorder-functions
 ;  -frerun-cse-after-loop -fsched-critical-path-heuristic
 ;  -fsched-dep-count-heuristic -fsched-group-heuristic -fsched-interblock
 ;  -fsched-last-insn-heuristic -fsched-rank-heuristic -fsched-spec
 ;  -fsched-spec-insn-heuristic -fsched-stalled-insns-dep -fschedule-fusion
 ;  -fsemantic-interposition -fshow-column -fshrink-wrap -fsigned-zeros
 ;  -fsplit-ivs-in-unroller -fsplit-wide-types -fssa-backprop -fssa-phiopt
 ;  -fstdarg-opt -fstrict-aliasing -fstrict-overflow
 ;  -fstrict-volatile-bitfields -fsync-libcalls -fthread-jumps
 ;  -ftoplevel-reorder -ftrapping-math -ftree-bit-ccp
 ;  -ftree-builtin-call-dce -ftree-ccp -ftree-ch -ftree-coalesce-vars
 ;  -ftree-copy-prop -ftree-dce -ftree-dominator-opts -ftree-dse
 ;  -ftree-forwprop -ftree-fre -ftree-loop-if-convert -ftree-loop-im
 ;  -ftree-loop-ivcanon -ftree-loop-optimize -ftree-parallelize-loops=
 ;  -ftree-phiprop -ftree-pre -ftree-pta -ftree-reassoc -ftree-scev-cprop
 ;  -ftree-sink -ftree-slsr -ftree-sra -ftree-switch-conversion
 ;  -ftree-tail-merge -ftree-ter -ftree-vrp -funit-at-a-time -fverbose-asm
 ;  -fzero-initialized-in-bss -msp8

	.text
	.type	uart_tx_char, @function
uart_tx_char:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
.L2:
/* #APP */
 ;  292 "main.c" 1
	sei
 ;  0 "" 2
 ;  293 "main.c" 1
	nop
 ;  0 "" 2
 ;  294 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r18,outframe	 ;  outframe.1_5, outframe
	lds r19,outframe+1	 ;  outframe.1_5, outframe
	or r18,r19	 ;  outframe.1_5
	brne .L2	 ; ,
	lsl r24	 ;  tmp51
	sbc r25,r25	 ;  tmp51
	ori r25,6	 ;  _10,
	sts outframe+1,r25	 ;  outframe, _10
	sts outframe,r24	 ;  outframe, _10
	in r24,0x39	 ;  _12, MEM[(volatile uint8_t *)89B]
	ori r24,lo8(4)	 ;  _13,
	out 0x39,r24	 ;  MEM[(volatile uint8_t *)89B], _13
	ldi r24,lo8(4)	 ;  tmp55,
	out 0x38,r24	 ;  MEM[(volatile uint8_t *)88B], tmp55
/* #APP */
 ;  305 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ret
	.size	uart_tx_char, .-uart_tx_char
	.type	uart_tx_str_P, @function
uart_tx_str_P:
	push r28	 ; 
	push r29	 ; 
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24	 ;  str, str
.L5:
	movw r24,r28	 ;  __addr16, str
	movw r30,r28	 ; , str
/* #APP */
 ;  318 "main.c" 1
	lpm r18, Z	 ;  __result
	
 ;  0 "" 2
/* #NOAPP */
	cpse r18,__zero_reg__	 ;  __result,
	rjmp .L6	 ; 
/* epilogue start */
	pop r29	 ; 
	pop r28	 ; 
	ret
.L6:
	adiw r28,1	 ;  str,
	movw r30,r24	 ; , __addr16
/* #APP */
 ;  318 "main.c" 1
	lpm r24, Z	 ;  __result
	
 ;  0 "" 2
/* #NOAPP */
	rcall uart_tx_char	 ; 
	rjmp .L5	 ; 
	.size	uart_tx_str_P, .-uart_tx_str_P
	.type	check_buttons, @function
check_buttons:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r18,0	 ;  counter
	ldi r20,lo8(-1)	 ;  old_buttons,
	ldi r21,lo8(-1)	 ;  old_buttons,
.L11:
	lsl r18	 ;  counter
	sbi 0x18,0	 ; ,
	cbi 0x18,0	 ; ,
	ldi r19,lo8(12)	 ;  ivtmp_4,
	ldi r24,0	 ;  <retval>
	ldi r25,0	 ;  <retval>
.L9:
	lsl r24	 ;  <retval>
	rol r25	 ;  <retval>
	sbis 0x16,1	 ; ,
	ori r24,1	 ;  <retval>,
.L8:
	cbi 0x18,2	 ; ,
	sbi 0x18,2	 ; ,
	subi r19,lo8(-(-1))	 ;  ivtmp_4,
	brne .L9	 ; ,
	cp r24,r20	 ;  <retval>, old_buttons
	cpc r25,r21	 ;  <retval>, old_buttons
	brne .L10	 ; ,
	ori r18,lo8(1)	 ;  counter,
.L10:
	ldi r30,lo8(900)	 ; ,
	ldi r31,hi8(900)	 ; ,
1:	sbiw r30,1	 ; 
	brne 1b
	movw r20,r24	 ;  old_buttons, <retval>
	cpi r18,lo8(-1)	 ;  counter,
	brne .L11	 ; ,
/* epilogue start */
	ret
	.size	check_buttons, .-check_buttons
	.type	delay_ms, @function
delay_ms:
	push r28	 ; 
	push r29	 ; 
	 ; SP -= 2	 ; 
	rcall .
	in r28,__SP_L__	 ; 
	clr r29	 ; 
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+2,r25	 ;  ms, ms
	std Y+1,r24	 ;  ms, ms
.L15:
	ldd r24,Y+1	 ;  ms.2_3, ms
	ldd r25,Y+2	 ;  ms.2_3, ms
	movw r18,r24	 ;  ms.4_4, ms.2_3
	subi r18,1	 ;  ms.4_4,
	sbc r19,__zero_reg__	 ;  ms.4_4
	std Y+2,r19	 ;  ms, ms.4_4
	std Y+1,r18	 ;  ms, ms.4_4
	or r24,r25	 ;  ms.2_3
	brne .L16	 ; ,
/* epilogue start */
	subi r28,lo8(-(2))	 ; ,
	out __SP_L__,r28	 ; ,
	pop r29	 ; 
	pop r28	 ; 
	ret
.L16:
	ldi r24,lo8(2399)	 ; ,
	ldi r25,hi8(2399)	 ; ,
1:	sbiw r24,1	 ; 
	brne 1b
	rjmp .
	nop
	rjmp .L15	 ; 
	.size	delay_ms, .-delay_ms
	.section	.text.startup,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r25,__SREG__	 ;  sreg, MEM[(volatile uint8_t *)95B]
/* #APP */
 ;  261 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(83)	 ;  tmp157,
	out 0x36,r24	 ;  MEM[(volatile uint8_t *)86B], tmp157
	ldi r24,lo8(1)	 ;  tmp159,
	out 0x33,r24	 ;  MEM[(volatile uint8_t *)83B], tmp159
	in r24,0x39	 ;  _32, MEM[(volatile uint8_t *)89B]
	andi r24,lo8(-5)	 ;  _33,
	out 0x39,r24	 ;  MEM[(volatile uint8_t *)89B], _33
	ldi r24,lo8(4)	 ;  tmp163,
	out 0x38,r24	 ;  MEM[(volatile uint8_t *)88B], tmp163
	sbi 0x18,3	 ; ,
	sbi 0x17,3	 ; ,
	sts outframe+1,__zero_reg__	 ;  outframe,
	sts outframe,__zero_reg__	 ;  outframe,
	out __SREG__,r25	 ;  MEM[(volatile uint8_t *)95B], sreg
	in r24,0x17	 ;  _21, MEM[(volatile uint8_t *)55B]
	ori r24,lo8(5)	 ;  _22,
	out 0x17,r24	 ;  MEM[(volatile uint8_t *)55B], _22
	sbi 0x18,2	 ; ,
	cbi 0x18,0	 ; ,
	cbi 0x17,1	 ; ,
	sbi 0x18,1	 ; ,
	rcall check_buttons	 ; 
	movw r28,r24	 ;  read_btns,
	ldi r24,lo8(gamepad_ee)	 ; ,
	ldi r25,hi8(gamepad_ee)	 ; ,
	rcall eeprom_read_byte	 ; 
	mov r18,r24	 ; , gamepad
	andi r18,lo8(1)	 ; ,
	mov r9,r18	 ;  gamepad,
	or r28,r29	 ;  read_btns
	breq .L18	 ; ,
	com r24	 ;  _18
	andi r24,lo8(1)	 ;  _18,
	mov r9,r24	 ;  gamepad, _18
	mov r22,r24	 ; , gamepad
	ldi r24,lo8(gamepad_ee)	 ; ,
	ldi r25,hi8(gamepad_ee)	 ; ,
	rcall eeprom_write_byte	 ; 
.L18:
	ldi r24,lo8(-18)	 ; ,
	ldi r25,lo8(2)	 ; ,
	rcall delay_ms	 ; 
	ldi r24,lo8(__c.1790)	 ; ,
	ldi r25,hi8(__c.1790)	 ; ,
	rcall uart_tx_str_P	 ; 
	ldi r24,lo8(-56)	 ; ,
	ldi r25,0	 ; 
	rcall delay_ms	 ; 
	ldi r24,lo8(__c.1792)	 ; ,
	ldi r25,hi8(__c.1792)	 ; ,
	rcall uart_tx_str_P	 ; 
	ldi r24,lo8(50)	 ; ,
	ldi r25,0	 ; 
	rcall delay_ms	 ; 
	ldi r24,lo8(__c.1794)	 ; ,
	ldi r25,hi8(__c.1794)	 ; ,
	rcall uart_tx_str_P	 ; 
	ldi r24,lo8(50)	 ; ,
	ldi r25,0	 ; 
	rcall delay_ms	 ; 
	ldi r24,lo8(__c.1796)	 ; ,
	ldi r25,hi8(__c.1796)	 ; ,
	rcall uart_tx_str_P	 ; 
	tst r9	 ;  gamepad
	brne .+2	 ; 
	rjmp .L19	 ; 
	ldi r24,lo8(__c.1798)	 ; ,
	ldi r25,hi8(__c.1798)	 ; ,
.L57:
	rcall uart_tx_str_P	 ; 
	ldi r24,lo8(50)	 ; ,
	ldi r25,0	 ; 
	rcall delay_ms	 ; 
	tst r9	 ;  gamepad
	brne .+2	 ; 
	rjmp .L21	 ; 
	ldi r24,lo8(__c.1802)	 ; ,
	ldi r25,hi8(__c.1802)	 ; ,
.L58:
	rcall uart_tx_str_P	 ; 
	ldi r24,lo8(50)	 ; ,
	ldi r25,0	 ; 
	rcall delay_ms	 ; 
	ldi r24,lo8(__c.1806)	 ; ,
	ldi r25,hi8(__c.1806)	 ; ,
	rcall uart_tx_str_P	 ; 
	ldi r24,lo8(-12)	 ; ,
	ldi r25,lo8(1)	 ; ,
	rcall delay_ms	 ; 
	ldi r16,lo8(-1)	 ;  read_btns_old,
	ldi r17,lo8(-1)	 ;  read_btns_old,
	ldi r19,lo8(keys.1757+6)	 ; ,
	mov r10,r19	 ;  _147,
	ldi r19,hi8(keys.1757+6)	 ; ,
	mov r11,r19	 ;  _147,
	clr r12	 ;  tmp198
	inc r12	 ;  tmp198
	mov r13,__zero_reg__	 ; 
.L23:
	rcall check_buttons	 ; 
	movw r28,r24	 ;  read_btns,
	cp r16,r24	 ;  read_btns_old, read_btns
	cpc r17,r25	 ;  read_btns_old, read_btns
	breq .L30	 ; ,
	tst r9	 ;  gamepad
	breq .L25	 ; ,
	ldi r24,lo8(-3)	 ; ,
	rcall uart_tx_char	 ; 
	ldi r24,lo8(6)	 ; ,
	rcall uart_tx_char	 ; 
	movw r16,r28	 ;  _39, read_btns
	clr r17	 ;  _39
	sbrs r28,4	 ;  tmp19,
	rjmp .L39	 ; 
	ldi r24,lo8(126)	 ;  tmp,
.L26:
	sbrc r16,5	 ;  _39,
	ldi r24,lo8(-127)	 ;  tmp,
.L27:
	rcall uart_tx_char	 ; 
	sbrs r16,6	 ;  _39,
	rjmp .L40	 ; 
	ldi r24,lo8(127)	 ;  tmp,
.L28:
	sbrc r28,7	 ;  tmp25,
	ldi r24,lo8(-127)	 ;  tmp,
.L29:
	rcall uart_tx_char	 ; 
	ldi r24,0	 ; 
	rcall uart_tx_char	 ; 
	ldi r24,0	 ; 
	rcall uart_tx_char	 ; 
	movw r24,r28	 ;  tmp182, read_btns
	ldi r18,4	 ; ,
	1:
	lsr r25	 ;  tmp182
	ror r24	 ;  tmp182
	dec r18	 ; 
	brne 1b
	andi r24,lo8(-16)	 ;  tmp,
	mov r25,r28	 ;  tmp183,
	andi r25,lo8(15)	 ;  tmp183,
	or r24,r25	 ; , tmp183
	rcall uart_tx_char	 ; 
	ldi r24,0	 ; 
	rcall uart_tx_char	 ; 
.L30:
	movw r16,r28	 ;  read_btns_old, read_btns
	rjmp .L23	 ; 
.L19:
	ldi r24,lo8(__c.1800)	 ; ,
	ldi r25,hi8(__c.1800)	 ; ,
	rjmp .L57	 ; 
.L21:
	ldi r24,lo8(__c.1804)	 ; ,
	ldi r25,hi8(__c.1804)	 ; ,
	rjmp .L58	 ; 
.L39:
	ldi r24,0	 ;  tmp
	rjmp .L26	 ; 
.L40:
	ldi r24,0	 ;  tmp
	rjmp .L28	 ; 
.L25:
	ldi r24,lo8(keys.1757)	 ; ,
	mov r14,r24	 ;  ivtmp.51,
	ldi r24,hi8(keys.1757)	 ; ,
	mov r15,r24	 ;  ivtmp.51,
	movw r16,r14	 ;  ivtmp.73,
	movw r20,r28	 ;  read_buttons, read_btns
.L33:
	movw r30,r16	 ; , ivtmp.73
	ld r24,Z	 ;  _53, MEM[base: _152, offset: 0B]
	tst r24	 ;  _53
	breq .L31	 ; ,
	subi r24,lo8(-(-4))	 ;  mask,
	movw r18,r12	 ; , tmp198
	rjmp 2f
	1:
	lsl r18	 ; 
	rol r19	 ; 
	2:
	dec r24	 ;  mask
	brpl 1b
	movw r24,r18	 ;  _57,
	and r18,r20	 ;  tmp188, read_buttons
	and r19,r21	 ;  tmp188, read_buttons
	or r18,r19	 ;  tmp188
	breq .L32	 ; ,
	com r24	 ;  tmp189
	com r25	 ;  tmp189
	and r20,r24	 ;  read_buttons, tmp189
	and r21,r25	 ;  read_buttons, tmp189
.L31:
	subi r16,-1	 ;  ivtmp.73,
	sbci r17,-1	 ;  ivtmp.73,
	cp r10,r16	 ;  _147, ivtmp.73
	cpc r11,r17	 ;  _147, ivtmp.73
	brne .L33	 ; ,
	ldi r24,0	 ;  ivtmp.60
	ldi r25,0	 ;  ivtmp.60
.L37:
	movw r18,r12	 ;  tmp190, tmp198
	mov r0,r24	 ; , ivtmp.60
	rjmp 2f
	1:
	lsl r18	 ;  tmp190
	rol r19	 ;  tmp190
	2:
	dec r0	 ; 
	brpl 1b
	and r18,r20	 ;  tmp192, read_buttons
	and r19,r21	 ;  tmp192, read_buttons
	or r18,r19	 ;  tmp192
	breq .L34	 ; ,
	ldi r30,lo8(keys.1757)	 ;  ivtmp.59,
	ldi r31,hi8(keys.1757)	 ;  ivtmp.59,
	ldi r18,0	 ;  ivtmp.52
	ldi r19,0	 ;  ivtmp.52
.L36:
	ld r22,Z+	 ;  _71, MEM[base: _91, offset: 0B]
	cpse r22,__zero_reg__	 ;  _71,
	rjmp .L35	 ; 
	subi r18,lo8(-(keys.1757))	 ;  tmp194,
	sbci r19,hi8(-(keys.1757))	 ;  tmp194,
	ldi r22,lo8(4)	 ;  tmp195,
	add r22,r24	 ;  tmp195, ivtmp.60
	movw r30,r18	 ; , tmp194
	st Z,r22	 ;  keys, tmp195
.L34:
	adiw r24,1	 ;  ivtmp.60,
	cpi r24,12	 ;  ivtmp.60,
	cpc r25,__zero_reg__	 ;  ivtmp.60
	brne .L37	 ; ,
	ldi r24,lo8(-3)	 ; ,
	rcall uart_tx_char	 ; 
	ldi r24,lo8(9)	 ; ,
	rcall uart_tx_char	 ; 
	ldi r24,lo8(1)	 ; ,
	rcall uart_tx_char	 ; 
	ldi r24,0	 ; 
	rcall uart_tx_char	 ; 
	ldi r24,0	 ; 
	rcall uart_tx_char	 ; 
.L38:
	movw r30,r14	 ; , ivtmp.51
	ld r24,Z+	 ; , MEM[base: _168, offset: 0B]
	movw r14,r30	 ;  ivtmp.51,
	rcall uart_tx_char	 ; 
	cp r16,r14	 ;  ivtmp.73, ivtmp.51
	cpc r17,r15	 ;  ivtmp.73, ivtmp.51
	brne .L38	 ; ,
	rjmp .L30	 ; 
.L32:
	movw r30,r16	 ; , ivtmp.73
	st Z,__zero_reg__	 ;  MEM[base: _152, offset: 0B],
	rjmp .L31	 ; 
.L35:
	subi r18,-1	 ;  ivtmp.52,
	sbci r19,-1	 ;  ivtmp.52,
	cpi r18,6	 ;  ivtmp.52,
	cpc r19,__zero_reg__	 ;  ivtmp.52
	brne .L36	 ; ,
	rjmp .L34	 ; 
	.size	main, .-main
	.text
.global	__vector_6
	.type	__vector_6, @function
__vector_6:
	push r1	 ; 
	push r0	 ; 
	in r0,__SREG__	 ; ,
	push r0	 ; 
	clr __zero_reg__	 ; 
	push r18	 ; 
	push r19	 ; 
	push r24	 ; 
	push r25	 ; 
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 7 */
.L__stack_usage = 7
	in r19,__SREG__	 ;  sreg, MEM[(volatile uint8_t *)95B]
	lds r24,outframe	 ;  data, outframe
	lds r25,outframe+1	 ;  data, outframe
	in r18,0x36	 ;  _6, MEM[(volatile uint8_t *)86B]
	subi r18,lo8(-(83))	 ;  _7,
	out 0x36,r18	 ;  MEM[(volatile uint8_t *)86B], _7
	sbrs r24,0	 ;  data,
	rjmp .L60	 ; 
	sbi 0x18,3	 ; ,
.L61:
	cpi r24,1	 ;  data,
	cpc r25,__zero_reg__	 ;  data
	brne .L62	 ; ,
	in r18,0x39	 ;  _16, MEM[(volatile uint8_t *)89B]
	andi r18,lo8(-5)	 ;  _17,
	out 0x39,r18	 ;  MEM[(volatile uint8_t *)89B], _17
.L62:
	lsr r25	 ;  _19
	ror r24	 ;  _19
	sts outframe+1,r25	 ;  outframe, _19
	sts outframe,r24	 ;  outframe, _19
	out __SREG__,r19	 ;  MEM[(volatile uint8_t *)95B], sreg
/* epilogue start */
	pop r25	 ; 
	pop r24	 ; 
	pop r19	 ; 
	pop r18	 ; 
	pop r0	 ; 
	out __SREG__,r0	 ; ,
	pop r0	 ; 
	pop r1	 ; 
	reti
.L60:
	cbi 0x18,3	 ; ,
	rjmp .L61	 ; 
	.size	__vector_6, .-__vector_6
	.local	keys.1757
	.comm	keys.1757,6,1
	.section	.progmem.data,"a",@progbits
	.type	__c.1806, @object
	.size	__c.1806, 5
__c.1806:
	.string	"R,1\r"
	.type	__c.1804, @object
	.size	__c.1804, 9
__c.1804:
	.string	"SH,0200\r"
	.type	__c.1802, @object
	.size	__c.1802, 9
__c.1802:
	.string	"SH,0210\r"
	.type	__c.1800, @object
	.size	__c.1800, 14
__c.1800:
	.string	"Keyboard-t13\r"
	.type	__c.1798, @object
	.size	__c.1798, 13
__c.1798:
	.string	"Gamepad-t13\r"
	.type	__c.1796, @object
	.size	__c.1796, 12
__c.1796:
	.string	"SN,SNES-BT-"
	.type	__c.1794, @object
	.size	__c.1794, 9
__c.1794:
	.string	"S=,5500\r"
	.type	__c.1792, @object
	.size	__c.1792, 3
__c.1792:
	.string	"+\r"
	.type	__c.1790, @object
	.size	__c.1790, 4
__c.1790:
	.string	"$$$"
.global	gamepad_ee
	.section	.eeprom,"aw",@progbits
	.type	gamepad_ee, @object
	.size	gamepad_ee, 1
gamepad_ee:
	.zero	1
	.comm	outframe,2,1
	.ident	"GCC: (GNU) 6.1.0"
.global __do_clear_bss
