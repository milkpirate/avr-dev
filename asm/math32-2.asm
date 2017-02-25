;**** A P P L I C A T I O N   N O T E   A V R ? ? ? ************************
;*
;* Title:               32-bit Arithmetic Routines with Macrolibrary
;* Project:             Math32
;* Version:             2.3
;* Last updated:        2003.09.15
;* Create Date:         1999.10.25
;* Target MCU:          AT90S8515 (as well as others AVR uC)
;*                      (C) ATMEL Corporation (mailto:avr@atmel.com)
;* Originator:          (C) 1999-2003 Andre Birua (mailto:birua@hotmail.com)
;*                      This Application Note absolutely free in use anybody
;* INTERPRETATION
;* This package of assembler subprograms is developed for integer arithmetic
;* with tracing of sign bit in 32 bits calculations and data reloads.
;* It is based on microcontroller register file to the maximum.
;* In real users projects available abundant digit capacity allows to avoid
;* overflow and reduces inaccuracy of rounding errors in chain calculations.
;* Included macro definitions will increase readability of assembler source
;* at bit by bit and multibyte data operations inside AVR software model
;*
;* DESCRIPTION
;* This Application Note lists:
;*   i) Math32 subroutines for the following:
;*      Add/Subtract/Multiply/Divide/Complement 32 bits operands,
;*      Binary 16 & 24 bits operand to/back BCD conversion,
;*      Binary 32 bits operand to BCD conversion,
;*      Initialization of data memory on a pattern,
;*      Load/Store group of registers from/to data space;
;*  ii) macro definitions call mathematical and data transfer subroutines;
;* iii) useful general macroinstructions for the AVR 8-Bit RISC family
;*
;* "ADD32"      Add without Carry       Rd32 = Rd32 + Rr32
;* "SUB32"      Subtract without Carry  Rd32 = Rd32 - Rr32
;* "MUL32"      Multiply Unsigned       Rd64 = Rd32 * Rr32
;* "DIV32"      Divide Unsigned         Rd32 = Rd32 / Rr32 (Rd64)
;* "COM32"      One's Complement        Rd32 = 0xffffffff - Rd32
;* "NEG32"      Two's Complement        Rd32 = 0x00000000 - Rd32
;* "BCD2bin"    BCD to Binary 16        Rd16 = Rd24|Rr24
;* "BCD3bin"    BCD to Binary 24        Rd24 = Rd32|Rr32
;* "Bin2BCD"    Binary 16 to BCD        Rd24 = Rd16|Rr16
;* "Bin3BCD"    Binary 24 to BCD        Rd32 = Rd24|Rr24
;* "Bin4BCD"    Binary 32 to BCD        Rd40 = Rd32|Rr32 || hwrd(Rr32)&Rd16
;* "MathMem"    Init Data Memory        (MA) = 0x00|0xff
;* "MathLoad"   Load Registers          Rd32|Rr32 = (MA)
;* "MathSave"   Store Registers         (MA) = Rd32|Rd64
;*
;* Rd64: destination registers (8) in the register file
;* Rd32: destination (and source) registers (4) in the register file
;* Rr32: source registers (4) in the register file
;* (MA): address for access to variable in the internal memory (SRAM)
;* Note: Math32 use high registers, r0 and lower 512 bytes of data space,
;*    so Rd64=r20:r27, Rd32=r20:r23, Rd24=r20:r22, Rd16=r20:r21,
;*       Rd40=r20:r24, Rr32=r16:r19, Rr24=r16:r18, Rr16=r16:r17, MA=0:511
;*
;* Number of words & cycles (Min|Max)           c o m m e n t s
;* "ADD32"      6    4|5    Size of Add32sign
;* "SUB32"     16    6|15   Size of Sub32sign
;* "MUL32"     24  460|556  Size of Mul32b, based on AVR200 16x16 unsigned
;* "DIV32"     28  528|688  Size of Div32b, based on AVR200 16/16 unsigned
;* "COM32"      5    4|4    Part of Sub32
;* "NEG32"      9    8|8    Part of Sub32
;* "BCD2bin"   26   86|89   Equivalent of AVR204, but smaller & quicker
;* "BCD3bin"   43   38|402  Different from BCD2bin translation algorithm
;* "Bin2BCD"   22   19|177  Equivalent of AVR204, but smaller & much faster
;* "Bin3BCD"   21   36|366  In the form of preamble for Bin2BCD
;* "Bin3BCD"   40   36|333  All-sufficient expansion of Bin2BCD
;* "Bin4BCD"   37  515|671  Based on AVR204 16-bit Bin to BCD conversion
;* "Bin4BCD"   48  874|878  All-sufficient transform instead of pre-Bin4BCD
;* "MathMem"   10    7|645  Size of MathMemLimit, max cycle for 128 bytes
;* "MathLoad"  15   41|46   Size and max cycle for Rr32 load
;* "MathSave"  14   13|78   Size and max cycle for Rd64 save
;* In total:  350 words     Usually +7 cycles: rcall & ret
;*
;* All routines are Code Size` optimized implementations and debugged with
;* macrocode for AVR macro assembler version 1.30 (Jan 27 1999 01:30:00) &
;*             AVR32 macro assembler version 1.30 (Sep  8 1999 01:30:00).
;*    However, AVR32 macro assembler version 1.54 (Nov 14 2001 14:05:48) &
;*             AVR32 macro assembler version 1.56 (May  6 2002 14:54:01)
;* generate dummy warnings: Register already defined by the .DEF directive
;* (command option for disable this kind of warning as yet is absent...)
;*                         CheckIt with AVR Studio !
;* NOTE
;* ` Bin4BCD transformations has partial loop optimization for speed-up
;* While using Math32, it is important to consider the allocation of the
;* microcontroller resources available for the program. It is required:
;* - to use r0,r16..r31 with Math32;
;* - to allocate variables used in calculation in the bottom of the memory;
;* - to use T flag as a sign bit (input, output and temporary),
;*   if you need to operate negative numbers or up-down overflow error
;*
;* VERSION
;* 1.0 Original version (in use starting with 1999.12.22)
;* 1.1 Fixed precedence bugs if macroparameter is an assembler expression
;* 1.2 Modify CBF & SBF & IBF macrocalls
;* 1.3 Full modification mathematical and data transfer macronotation
;* 1.4 Optimaze for speed and code size Mul32 & Div32 & BCD2bin & Bin2BCD
;* 2.0 Version for publication (added description, note and demo sections)
;* 2.1 Updated Bin2BCD, added Bin4BCD conversion & XCH macrocall
;* 2.2 Added functionally closed modifications of Bin3&4BCD translation
;* 2.3 Added BCD3bin conversion, normalize the comment of Bin3&4BCD
;*
;* DEMO
;* section below is a sample of macrocalls and not an ordinary Math32 usage
;*
;***************************************************************************

.include "8515def.inc"
.listmac                        ;split Toggle_mode <Ctrl+F11> at AVR Studio
.cseg                           ;press Step_Over <F10> etceteras of <Alt+D>
                rjmp    Demo    ;trace Registers <Alt+0> and Memory <Alt+4>

;Words *** general macrocode for the AVR 8-Bit RISC microcontroller ***
;2 "CLF"   CLear bit Flag in register via T flag
;2 "SEF"   SEt bit Flag in register via T flag
;2 "CBF"   Clear Bit(s) Flag(s) in register via temporary register
;2 "SBF"   Set Bit(s) Flag(s) in register via temporary register
;2 "IBF"   Invert Bit(s) Flag(s) in register via temporary register
;2 "OUTI"  OUT port Immediate via temporary register
;4 "OUTIW" OUT port Immediate Word via temporary register
;2 "OUTW"  OUT port Word from register pair
;2 "INW"   IN port Word to register pair
;3 "XCH"   data eXCHange between a two registers as exclusive OR only
;2 "MVW"   MoVe register pair as Word
;2 "MVI"   MoVe temporary register loaded Immediate
;4 "MOVS"  MOVe direct in data Space via temporary register
;8 "MOVSW" MOVe direct in data Space Word via temporary register
;3 "STSI"  STore direct to data Space Immediate via temporary register
;4 "STSIW" STore direct to data Space Immediate Word via temporary register
;4 "LDSW"  LoaD direct from data Space Word to register pair
;4 "STSW"  STore direct to data Space Word from register pair
;2 "LDIW"  LoaD Immediate Word to register pair
;2 "LDDW"  LoaD indirect with Displacement from data space Word to register pair
;2 "STDW"  STore indirect with Displacement to data space Word from register pair
;2 "PUSHW" PUSH register pair (Word) on stack
;2 "POPW"  POP register pair (Word) from stack

.macro CLF ; Register,Bit#
                clt
                bld     @0,@1
.endmacro
.macro SEF ; Register,Bit#
                set
                bld     @0,@1
.endmacro
.macro CBF ; Register,RegisterH,Bit#[,Bit#][,Bit#][,Bit#][,Bit#][,Bit#][,Bit#][,Bit#]
                ldi     @1,~(exp2(@2)|(-@3-1<0)*exp2(@3-0)|(-@4-1<0)*exp2(@4-0)|(-@5-1<0)*exp2(@5-0)|(-@6-1<0)*exp2(@6-0)|(-@7-1<0)*exp2(@7-0)|(-@8-1<0)*exp2(@8-0)|(-@9-1<0)*exp2(@9-0))
                and     @0,@1
.endmacro
.macro SBF ; Register,RegisterH,Bit#[,Bit#][,Bit#][,Bit#][,Bit#][,Bit#][,Bit#][,Bit#]
                ldi     @1,exp2(@2)|(-@3-1<0)*exp2(@3-0)|(-@4-1<0)*exp2(@4-0)|(-@5-1<0)*exp2(@5-0)|(-@6-1<0)*exp2(@6-0)|(-@7-1<0)*exp2(@7-0)|(-@8-1<0)*exp2(@8-0)|(-@9-1<0)*exp2(@9-0)
                or      @0,@1
.endmacro
.macro IBF ; Register,RegisterH,Bit#[,Bit#][,Bit#][,Bit#][,Bit#][,Bit#][,Bit#][,Bit#]
                ldi     @1,exp2(@2)|(-@3-1<0)*exp2(@3-0)|(-@4-1<0)*exp2(@4-0)|(-@5-1<0)*exp2(@5-0)|(-@6-1<0)*exp2(@6-0)|(-@7-1<0)*exp2(@7-0)|(-@8-1<0)*exp2(@8-0)|(-@9-1<0)*exp2(@9-0)
                eor     @0,@1
.endmacro
.macro OUTI ; Port,RegisterH,ConstantB
                ldi     @1,@2
                out     @0,@1
.endmacro
.macro OUTIW ; PortHL,RegisterH,ConstantW
                ldi     @1,high(@2)
                out     @0h,@1
                ldi     @1,low(@2)
                out     @0l,@1
.endmacro
.macro OUTW ; PortHL,RegisterHL
                out     @0h,@1h
                out     @0l,@1l
.endmacro
.macro INW ; RegisterHL,PortHL
                in      @0l,@1l
                in      @0h,@1h
.endmacro
.macro XCH ; Register,Register
                eor     @0,@1
                eor     @1,@0
                eor     @0,@1
.endmacro
.macro MVW ; RegisterHL,RegisterHL
                mov     @0h,@1h
                mov     @0l,@1l
.endmacro
.macro MVI ; RegisterL,RegisterH,ConstantB
                ldi     @1,@2
                mov     @0,@1
.endmacro
.macro MOVS ; Address,Register,Address
                lds     @1,@2
                sts     @0,@1
.endmacro
.macro MOVSW ; Address,Register,Address
                lds     @1,@2
                sts     @0,@1
                lds     @1,(@2)+1
                sts     (@0)+1,@1
.endmacro
.macro STSI ; Address,RegisterH,ConstantB
                ldi     @1,@2
                sts     @0,@1
.endmacro
.macro STSIW ; Address,RegisterH,ConstantW
                ldi     @1,low(@2)
                sts     @0,@1
                ldi     @1,high(@2)
                sts     (@0)+1,@1
.endmacro
.macro LDSW ; RegisterHL,Address
                lds     @0l,@1
                lds     @0h,(@1)+1
.endmacro
.macro STSW ; Address,RegisterHL
                sts     (@0)+1,@1h
                sts     @0,@1l
.endmacro
.macro LDIW ; RegisterHL,ConstantW
                ldi     @0l,low(@1)
                ldi     @0h,high(@1)
.endmacro
.macro LDDW ; RegisterHL,RegisterPair+Displacement
                ldd     @0l,@1
                ldd     @0h,@1+1
.endmacro
.macro STDW ; RegisterPair+Displacement,RegisterHL
                std     @0+1,@1h
                std     @0,@1l
.endmacro
.macro PUSHW ; RegisterHL
                push    @0l
                push    @0h
.endmacro
.macro POPW ; RegisterHL
                pop     @0h
                pop     @0l
.endmacro

;Words ***** mathematical and data transfer macrocalls *****
;3 "INITMEM" INITialize math data space (MEMory variable) in 0|0xff
;3 "MATHR16" load from MATH data space to Registers r16,r17,r18,r19
;3 "MATHR20" load from MATH data space to Registers r20,r21,r22,r23
;3 "OPERAND" load registers as mathematical OPERAND from math data space
;3 "RESULT2" store registers as mathematical RESULT to math data space (call)
;3 "RESULT3" store registers as mathematical RESULT to math data space (jump)
;1 "CNST16B" load immediate CoNSTant to r16 as Byte
;2 "CNST16W" load immediate CoNSTant to r16,r17 as Word
;3 "CNST16T" load immediate CoNSTant to r16,r17,r18 as Three bytes
;4 "CONST16" load immediate CONSTant to r16,r17,r18,r19 as double word
;4 "CONST20" load immediate CONSTant to r20,r21,r22,r23 as double word

.macro INITMEM ; Address[,Counter(1-128)[,0|1|limit]]
                ldi     ZL,@0
                ldi     ZH,@1-1<<1|high(@0)&1
                rcall   MathMem@2
.endmacro
.macro MATHR16 ; Address[,Bitmap]
                ldi     ZL,@0
                ldi     ZH,((-@1-1>0)*ObXXXX|@1-0)<<1|high(@0)&1
                rcall   R16MathLoad
.endmacro
.macro MATHR20 ; Address[,Bitmap]
                ldi     ZL,@0
                ldi     ZH,((-@1-1>0)*ObXXXX|@1-0)<<1|high(@0)&1
                rcall   R20MathLoad
.endmacro
.macro OPERAND ; Address[,[Bitmap][,r16|r20]]
                ldi     ZL,@0
                ldi     ZH,((-@1-1>0)*ObXXXX|@1-0)<<1|high(@0)&1
                rcall   @2MathLoad
.endmacro
.macro RESULT2 ; Address[,Bitmap]
                ldi     ZL,@0
                ldi     ZH,((-@1-1>0)*ObXXXX|@1-0)<<1|high(@0)&1
                rcall   MathSave-2*(((-@1-1>0)*ObXXXX|@1-0)>0x7f)
.endmacro
.macro RESULT3 ; Address[,Bitmap]
                ldi     ZL,@0
                ldi     ZH,((-@1-1>0)*ObXXXX|@1-0)<<1|high(@0)&1
                rjmp    MathSave-2*(((-@1-1>0)*ObXXXX|@1-0)>0x7f)
.endmacro
.macro CNST16B ; ConstantB (8 bits)
                ldi     r16,byte1(@0)
.endmacro
.macro CNST16W ; ConstantW (16 bits)
                ldi     r16,byte1(@0)
                ldi     r17,byte2(@0)
.endmacro
.macro CNST16T ; ConstantT (24 bits)
                ldi     r16,byte1(@0)
                ldi     r17,byte2(@0)
                ldi     r18,byte3(@0)
.endmacro
.macro CONST16 ; ConstantD (32 bits)
                ldi     r16,byte1(@0)
                ldi     r17,byte2(@0)
                ldi     r18,byte3(@0)
                ldi     r19,byte4(@0)
.endmacro
.macro CONST20 ; ConstantD (32 bits)
                ldi     r20,byte1(@0)
                ldi     r21,byte2(@0)
                ldi     r22,byte3(@0)
                ldi     r23,byte4(@0)
.endmacro

;***************************************************************************
;# # # # # # # # #    Assign Math32 Symbol and Notation    # # # # # # # # #
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;*
;*  Add32[sign], Sub32[sign], Mul32[b|w|t], Div32[b|w|t] :
;*    operand1                 operand2                   result
;*  r20r21r22r23   +|-|*|/   r16r17r18r19   =   r20r21r22r23[r24r25r26r27]
;*
;*            Com32, Neg32 :                    Bin2BCD20, BCD2bin20 :
;*    operand              result              operand            result
;*  r20r21r22r23  >>>  r20r21r22r23          r20r21[r22]  >>>  r20r21[r22]
;*
;*    BCD3bin, Bin3BCD, Bin4BCD :               Bin2BCD16, BCD2bin16 :
;*   operand              result               operand            result
;*  r16...r23  >>>  r20r21r22[r23[r24]]      r16r17[r18]  >>>  r20r21[r22]
;*
;***************************************************************************
.set ObXXXX=0b1111   ;default load & store memory variable bitmap upon
;little-endian format of numbers, i.e. abs.address(LSB) < abs.address(MSB)

;***************************************************************************
;*
;* Initialize Memory in Math Data Space
;*
;* First 512+127 bytes of data space can be initialize in 0 or 0xff
;* Limit: if Flag T==1 then EachMemoryByte=0 else EachMemoryByte=0xff
;*
;***************************************************************************
.def MathPattern=r28    ;YL
.def MathCounter=r29    ;YH

MathMemLimit:   brts    MathMem0x0      ;
MathMem0x1:     ser     MathPattern     ;
                cpse    ZH,ZH           ;skip next instruction
MathMem0x0:     clr     MathPattern     ;
                mov     MathCounter,ZH  ;copy counter
                cbr     ZH,0xfe         ;Z points to math data space
NextMemByte:    st      Z+,MathPattern  ;
                subi    MathCounter,2   ;
                brcc    NextMemByte     ;while MathCounter>=0
                ret                     ;
.equ MathMem=MathMem0x0 ;default initialize memory call

;***************************************************************************
;*
;* Registers Load from Math Data Space
;*
;* Load: r16r17r18r19r20r21r22r23   from   first 512+3 bytes of data space
;*         operand2    operand1             (max starting address: 0x1ff)
;*
;***************************************************************************
.def MathBmp=r26        ;only XL,XH from high registers
.def MathTmp=r27        ;do not keep useful data or not used below

R16MathLoad:    ldi     YL,16           ;Y points to operand2 LSB
                cpse    ZH,ZH           ;skip next instruction
R20MathLoad:    ldi     YL,20           ;Y points to operand1 LSB
                clr     YH              ;
                mov     MathBmp,ZH      ;copy bitmap
                cbr     ZH,0xfe         ;Z points to math data space
                sbr     MathBmp,0xe0    ;it is possible in each macrocall
MathLoadNext:   lsr     MathBmp         ;
                clr     MathTmp         ;load 0 to temp register
                sbrc    MathBmp,0       ;if bit 0 bitmap not clear
                ld      MathTmp,Z+      ;   load operand from memory to temp
                st      Y+,MathTmp      ;store temp to math register
                sbrc    MathBmp,4       ;
                rjmp    MathLoadNext    ;while bit 4 of bitmap not clear
                ret                     ;
.equ MathLoad=R20MathLoad ;default registers load call

;***************************************************************************
;*
;* Registers Save to Math Data Space
;*
;* Save: r20r21r22r23r24r25r26r27   to   first 512+7 bytes of data space
;*          result    (remainder)         (max starting address: 0x1ff)
;*
;***************************************************************************
.def MathBmp=r0         ;all high registers keep useful data or used below

                sec                     ;
                cpse    ZH,ZH           ;skip next instruction
R20MathSave:    clc                     ;
                mov     MathBmp,ZH      ;copy bitmap
                cbr     ZH,0xfe         ;Z points to math data space
                ror     MathBmp         ;now bitmap have all 8 bits
                ldi     YL,20           ;Y points to result LSB
MathSaveNext:   clr     YH              ;
                ld      YH,Y+           ;in order to not use other registers
                sbrc    MathBmp,0       ;if bit 0 bitmap not clear
                st      Z+,YH           ;       store result byte to memory
                lsr     MathBmp         ;
                brne    MathSaveNext    ;while not empty bitmap
                ret                     ;
.equ MathSave=R20MathSave ;default registers save call

;***************************************************************************
;*
;* Add32 == 32+32 Bit Unsigned Addition
;*
;* add1L::add1H  +  add2L::add2H  =  add1L::add1H
;*     item             item             sum
;* r20r21r22r23  +  r16r17r18r19  =  r20r21r22r23
;*
;***************************************************************************
.def    add20   = r16   ; item 2 byte 0 (LSB)
.def    add21   = r17   ; item 2 byte 1
.def    add22   = r18   ; item 2 byte 2
.def    add23   = r19   ; item 2 byte 3 (MSB)
.def    add10   = r20   ; item 1 byte 0 (LSB)
.def    add11   = r21   ; item 1 byte 1
.def    add12   = r22   ; item 1 byte 2
.def    add13   = r23   ; item 1 byte 3 (MSB)

Add32sign:      brts    Sub32sign       ;
Add32:          add     add10,add20     ;Add low bytes
                adc     add11,add21     ;Add higher bytes with carry
                adc     add12,add22     ;
                adc     add13,add23     ;
                ret                     ;

;***************************************************************************
;*
;* Sub32 == 32-32 Bit Unsigned Subtraction
;*
;* sub1L::sub1H  -  sub2L::sub2H  =  sub1L::sub1H
;*   minuend         subtrahend       difference
;* r20r21r22r23  -  r16r17r18r19  =  r20r21r22r23
;*
;***************************************************************************
.def    sub20   = r16   ; subtrahend byte 0 (LSB)
.def    sub21   = r17   ; subtrahend byte 1
.def    sub22   = r18   ; subtrahend byte 2
.def    sub23   = r19   ; subtrahend byte 3 (MSB)
.def    sub10   = r20   ; minuend byte 0 (LSB)
.def    sub11   = r21   ; minuend byte 1
.def    sub12   = r22   ; minuend byte 2
.def    sub13   = r23   ; minuend byte 3 (MSB)

Sub32sign:      clt                     ;sign +
Sub32:          sub     sub10,sub20     ;Subtract low bytes
                sbc     sub11,sub21     ;Subtract higher bytes with carry
                sbc     sub12,sub22     ;
                sbc     sub13,sub23     ;
                brcc    Return32u       ;return clear carry if result>=0
                set                     ;sign -
Neg32:          subi    sub10,1         ;if result<0
                sbci    sub11,0         ;   neg result
                sbci    sub12,0         ;
                sbci    sub13,0         ;   (dec result)
Com32:          com     sub10           ;       &
                com     sub11           ;   (com result)
                com     sub12           ;
                com     sub13           ;   return set carry after com
Return32u:      ret                     ;

;***************************************************************************
;*
;* Mul32 == 32x32 Bit Unsigned Multiplication
;*
;* mp32uL::mp32uH  x  mc32uL::mc32uH  =  m32uL::m32uH
;*   multiplier        multiplicand         result
;*  r20r21r22r23   x   r16r17r18r19   =  r20r21r22r23r24r25r26r27
;*
;***************************************************************************
.def    mc32u0  =r16    ; multiplicand byte 0 (LSB)
.def    mc32u1  =r17    ; multiplicand byte 1
.def    mc32u2  =r18    ; multiplicand byte 2
.def    mc32u3  =r19    ; multiplicand byte 3 (MSB)
.def    mp32u0  =r20    ; multiplier byte 0 (LSB)
.def    mp32u1  =r21    ; multiplier byte 1
.def    mp32u2  =r22    ; multiplier byte 2
.def    mp32u3  =r23    ; multiplier byte 3 (MSB)
.def    m32u0   =r20    ; result byte 0 (LSB)
.def    m32u1   =r21    ; result byte 1
.def    m32u2   =r22    ; result byte 2
.def    m32u3   =r23    ; result byte 3
.def    m32u4   =r24    ; result byte 4
.def    m32u5   =r25    ; result byte 5
.def    m32u6   =r26    ; result byte 6
.def    m32u7   =r27    ; result byte 7 (MSB)
.def    mcnt32u =r28    ; loop counter

Mul32b:         clr     mc32u1          ;multiplicand is one byte
Mul32w:         clr     mc32u2          ;                two bytes
Mul32t:         clr     mc32u3          ;                three bytes
Mul32:          clr     m32u7           ;clear 4 highest bytes of result
                clr     m32u6           ;
                clr     m32u5           ;
                sub     m32u4,m32u4     ;and carry
                ldi     mcnt32u,33      ;init loop counter
m32u_loop:      ror     m32u3           ;rotate result and multiplier
                ror     m32u2           ;
                ror     m32u1           ;
                ror     m32u0           ;
                dec     mcnt32u         ;decrement loop counter
                breq    Return32u       ;if counter zero return
                brcc    m32u_skip       ;if bit 0 of multiplier set
                add     m32u4,mc32u0    ;   add multiplicand to result
                adc     m32u5,mc32u1    ;
                adc     m32u6,mc32u2    ;
                adc     m32u7,mc32u3    ;
m32u_skip:      ror     m32u7           ;shift right result byte 7
                ror     m32u6           ;rotate right result
                ror     m32u5           ;
                ror     m32u4           ;
                rjmp    m32u_loop       ;

;***************************************************************************
;*
;* Div32 == 32/32 Bit Unsigned Division
;*
;* dd32uL::dd32uH / dv32uL::dv32uH = dres32uL::dres32uH (drem32uL::drem32uH)
;*    dividend          divisor            result            remainder
;*  r20r21r22r23  /  r16r17r18r19  =    r20r21r22r23        r24r25r26r27
;*
;***************************************************************************
.def    dv32u0   =r16   ; divisor byte 0 (LSB)
.def    dv32u1   =r17   ; divisor byte 1
.def    dv32u2   =r18   ; divisor byte 2
.def    dv32u3   =r19   ; divisor byte 3 (MSB)
.def    dres32u0 =r20   ; result byte 0 (LSB)
.def    dres32u1 =r21   ; result byte 1
.def    dres32u2 =r22   ; result byte 2
.def    dres32u3 =r23   ; result byte 3 (MSB)
.def    dd32u0   =r20   ; dividend byte 0 (LSB)
.def    dd32u1   =r21   ; dividend byte 1
.def    dd32u2   =r22   ; dividend byte 2
.def    dd32u3   =r23   ; dividend byte 3 (MSB)
.def    drem32u0 =r24   ; remainder byte 0 (LSB)
.def    drem32u1 =r25   ; remainder byte 1
.def    drem32u2 =r26   ; remainder byte 2
.def    drem32u3 =r27   ; remainder byte 3 (MSB)
.def    dcnt32u  =r28   ; loop counter

Div32b:         clr     dv32u1          ;divisor is one byte
Div32w:         clr     dv32u2          ;           two bytes
Div32t:         clr     dv32u3          ;           three bytes
Div32:          clr     drem32u0        ;clear 4 lower remainde byte
                clr     drem32u1        ;
                clr     drem32u2        ;
                sub     drem32u3,drem32u3;and carry
                ldi     dcnt32u,33      ;init loop counter
d32u_loop:      rol     dd32u0          ;shift left dividend
                rol     dd32u1          ;
                rol     dd32u2          ;
                rol     dd32u3          ;
                dec     dcnt32u         ;decrement loop counter
                breq    Com32           ;if counter zero invert result
                rol     drem32u0        ;shift dividend into remainder
                rol     drem32u1        ;
                rol     drem32u2        ;
                rol     drem32u3        ;
                sub     drem32u0,dv32u0 ;remainder = remainder - divisor
                sbc     drem32u1,dv32u1 ;
                sbc     drem32u2,dv32u2 ;
                sbc     drem32u3,dv32u3 ;
                brcc    d32u_loop       ;clear carry to be shifted into res
                add     drem32u0,dv32u0 ;if result negative
                adc     drem32u1,dv32u1 ;   restore remainder
                adc     drem32u2,dv32u2 ;
                adc     drem32u3,dv32u3 ;
                rjmp    d32u_loop       ;   set carry to be shifted into res

;***************************************************************************
;*
;* BCD2bin == BCD to 16-Bit Binary Conversion
;*
;* fBCD0:fBCD1:fBCD2  >>>  tbinL:tbinH
;*        dec                  hex
;*     r16r17r18      >>>     r20r21
;*
;***************************************************************************
.def    fBCD0   =r16    ; BCD value digits 0 and 1
.def    fBCD1   =r17    ; BCD value digits 2 and 3
.def    fBCD2   =r18    ; BCD value digit 4 (MSD is lowermost nibble)
.def    mp10L   =r20    : Low byte of number to be multiplied by 10
.def    mp10H   =r21    ; High byte of number to be multiplied by 10
.def    tbinL   =r20    ; Low byte of binary result (same as mp10L)
.def    tbinH   =r21    ; High byte of binary result (same as mp10H)
.def    copyL   =r22    ; temporary register
.def    copyH   =r23    ; temporary register

BCD2bin20:      mov     r16,r20         ;for compatibility with Math32
                mov     r17,r21         ;
                mov     r18,r22         ;
BCD2bin16:      cbr     fBCD2,0xf0      ;mask away upper nibble of fBCD2
                mov     mp10L,fBCD2     ;mp10L:mp10H = MSD
                clr     mp10H           ;
                clr     fBCD2           ;for adci mp10H,0 below
                rcall   mul10bcd        ;fBCDX = fBCD1
                mov     fBCD1,fBCD0     ;fBCDX = fBCD0
mul10bcd: ;mp10L:mp10H=10(10*mp10L:mp10H+highnibble(fBCDX))+lownibble(fBCDX)
                rcall   mul10add        ;10*mp10L:mp10H+highnibble(fBCDX)
mul10add: ;mp10L:mp10H = 10*mp10L:mp10H+lownibble(fBCDX)
                lsl     mp10L           ;multiply original by 2
                rol     mp10H           ;
                mov     copyL,mp10L     ;make copy (x2)
                mov     copyH,mp10H     ;
                lsl     copyL           ;multiply copy by 2 (x4)
                rol     copyH           ;
                lsl     copyL           ;multiply copy by 2 (x8)
                rol     copyH           ;
                add     mp10L,copyL     ;add copy to original (x10)
                adc     mp10H,copyH     ;
                swap    fBCD1           ;fBCDX upper<=>lower nibble
                mov     copyL,fBCD1     ;
                andi    copyL,0x0f      ;mask away upper nibble
                add     mp10L,copyL     ;add lower nibble
                adc     mp10H,fBCD2     ;high byte of result + carry
                ret                     ;
.equ BCD2bin=BCD2bin20 ;default registers BCD to BIN call

;***************************************************************************
;*
;* BCD3bin == BCD to 24-Bit Binary Conversion
;*
;* fBCD0:fBCD1:fBCD2:fBCD3  >>>  tbin0:tbin1:tbin2
;*           dec                        hex
;*       r16r17r18r19       >>>      r20r21r22
;*
;***************************************************************************
.def    fBCD0   =r16    ; BCD value digits 0 and 1
.def    fBCD1   =r17    ; BCD value digits 2 and 3
.def    fBCD2   =r18    ; BCD value digits 4 and 5
.def    fBCD3   =r19    ; BCD value digits 6 and 7 (MSD is 0|1)
.def    tbin0   =r20    ; binary value byte 0 (LSB)
.def    tbin1   =r21    ; binary value byte 1
.def    tbin2   =r22    ; binary value byte 2 (MSB)

BCD3bin20:      mov     r16,r20         ;for compatibility with Math32
                mov     r17,r21         ;
                mov     r18,r22         ;
                mov     r19,r23         ;
BCD3bin16:      ldi     tbin0,0xca              ;digit-to-digit presetting
                ldi     tbin1,0x1b              ;-1111110=0xef0bba
                ldi     tbin2,0xff              ;0xff1bca=0xef0bba-0xefeff0
                sbrc    fBCD3,4                 ; delete decimal correction
                subi    fBCD3,6                 ; if NUMBER<10000000 always
bcdbin_106:     subi    tbin0,byte1(-1000*1000) ;addit tbin,10^6
                sbci    tbin1,byte2(-1000*1000) ;
                sbci    tbin2,byte3(-1000*1000) ;
                subi    fBCD3,0x01              ;
                brcc    bcdbin_106              ;
bcdbin_105:     subi    tbin0,byte1(-100*1000)  ;addit tbin,10^5
                sbci    tbin1,byte2(-100*1000)  ;
                sbci    tbin2,byte3(-100*1000)  ;
                subi    fBCD2,0x10              ;
                brcc    bcdbin_105              ;
bcdbin_104:     subi    tbin0,byte1(-10*1000)   ;addit tbin,10^4
                sbci    tbin1,byte2(-10*1000)   ;
                sbci    tbin2,byte3(-10*1000)   ;
                subi    fBCD2,0x01              ;
                brhc    bcdbin_104              ;
bcdbin_103:     subi    tbin0,byte1(-1000)      ;addit tbin,10^3
                sbci    tbin1,byte2(-1000)      ;
                sbci    tbin2,byte3(-1000)      ;
                subi    fBCD1,0x10              ;
                brcc    bcdbin_103              ;
bcdbin_102:     subi    tbin0,byte1(-100)       ;addit tbin,10^2
                sbci    tbin1,byte2(-100)       ;
                sbci    tbin2,byte3(-100)       ;
                subi    fBCD1,0x01              ;
                brhc    bcdbin_102              ;
bcdbin_101:     subi    tbin0,byte1(-10)        ;addit tbin,10^1
                sbci    tbin1,byte2(-10)        ;
                sbci    tbin2,byte3(-10)        ;
                subi    fBCD0,0x10              ;
                brcc    bcdbin_101              ;addit tbin,0xefeff0+LSD
                add     tbin0,fBCD0             ; addend of tbin1 & tbin2 is
                adc     tbin1,fBCD1             ; arbitrarily chosen const
                adc     tbin2,fBCD2             ; (pre take off from tbin)
                ret
.equ BCD3bin=BCD3bin20 ;default registers BCD to BIN call

;***************************************************************************
;*
;* Bin2BCD == 16-bit Binary to BCD conversion
;*
;* fbinL:fbinH  >>>  tBCD0:tBCD1:tBCD2
;*     hex                  dec
;*   r16r17     >>>      r20r21r22
;*
;***************************************************************************
.def    fbinL   =r16    ; binary value Low byte
.def    fbinH   =r17    ; binary value High byte
.def    tBCD0   =r20    ; BCD value digits 0 and 1
.def    tBCD1   =r21    ; BCD value digits 2 and 3
.def    tBCD2   =r22    ; BCD value digit 4 (MSD is lowermost nibble)

Bin2BCD20:      mov     r16,r20         ;for compatibility with Math32
                mov     r17,r21         ;
Bin2BCD16:      ldi     tBCD2,0xff      ;initialize digit 4
binbcd_4:       inc     tBCD2           ;
                subi    fbinL,low(10000);subiw fbin,10000
                sbci    fbinH,high(10000)
                brcc    binbcd_4        ;
                ldi     tBCD1,0x9f      ;initialize digits 3 and 2
binbcd_3:       subi    tBCD1,0x10      ;
                subi    fbinL,low(-1000);addiw fbin,1000
                sbci    fbinH,high(-1000)
                brcs    binbcd_3        ;
binbcd_2:       inc     tBCD1           ;
                subi    fbinL,low(100)  ;subiw fbin,100
                sbci    fbinH,high(100) ;
                brcc    binbcd_2        ;
                ldi     tBCD0,0xa0      ;initialize digits 1 and 0
binbcd_1:       subi    tBCD0,0x10      ;
                subi    fbinL,-10       ;addi fbin,10
                brcs    binbcd_1        ;
                add     tBCD0,fbinL     ;LSD
binbcd_ret:     ret                     ;
.equ Bin2BCD=Bin2BCD20 ;default registers BIN to BCD call

;***************************************************************************
;*
;* Bin4BCD == 32-bit Binary to BCD conversion   [ together with Bin2BCD ]
;*
;* fbin0:fbin1:fbin2:fbin3  >>>  tBCD0:tBCD1:tBCD2:tBCD3:tBCD4
;*           hex                              dec
;*       r18r19r20r21       >>>         r20r21r22r23r24
;*
;***************************************************************************
.def    fbin0   =r18    ; binary value byte 0 (LSB)
.def    fbin1   =r19    ; binary value byte 1
.def    fbin2   =r20    ; binary value byte 2
.def    fbin3   =r21    ; binary value byte 3 (MSB)
.def    tBCD0   =r20    ; BCD value digits 0 and 1 (same as fbin2)
.def    tBCD1   =r21    ; BCD value digits 2 and 3 (same as fbin3)
.def    tBCD2   =r22    ; BCD value digits 4 and 5
.def    tBCD3   =r23    ; BCD value digits 6 and 7
.def    tBCD4   =r24    ; BCD value digits 8 and 9 (MSD)

Bin4BCD:        rcall   Bin2BCD20       ;
                clr     tBCD3           ;initial highest bytes of result
                ldi     tBCD4,0xfe      ;
binbcd_loop:    subi    tBCD0,-0x33     ;add 0x33 to digits 1 and 0
                sbrs    tBCD0,3         ;if bit 3 clear
                subi    tBCD0,0x03      ;       sub 3
                sbrs    tBCD0,7         ;if bit 7 clear
                subi    tBCD0,0x30      ;       sub $30
                subi    tBCD1,-0x33     ;add 0x33 to digits 3 and 2
                sbrs    tBCD1,3         ;if bit 3 clear
                subi    tBCD1,0x03      ;       sub 3
                sbrs    tBCD1,7         ;if bit 7 clear
                subi    tBCD1,0x30      ;       sub $30
                subi    tBCD2,-0x33     ;add 0x33 to digits 5 and 4
                sbrs    tBCD2,3         ;if bit 3 clear
                subi    tBCD2,0x03      ;       sub 3
                sbrs    tBCD2,7         ;if bit 7 clear
                subi    tBCD2,0x30      ;       sub $30
                lsl     fbin0           ;
                rol     fbin1           ;shift lower word
                rol     tBCD0           ;through all bytes
                rol     tBCD1           ;
                rol     tBCD2           ;
                rol     tBCD3           ;
                rol     tBCD4           ;
                brmi    binbcd_loop     ;7 shifts w/o correction of MSD
                rol     fbinH           ;since Bin2BCD fbinH = 0xff
                brcc    binbcd_ret      ;  so as to do 16_lsl in total
                subi    tBCD3,-0x33     ;add 0x33 to digits 7 and 6
                sbrs    tBCD3,3         ;if bit 3 clear
                subi    tBCD3,0x03      ;       sub 3
                sbrs    tBCD3,7         ;if bit 7 clear
                subi    tBCD3,0x30      ;       sub $30
                subi    tBCD4,-0x03     ;add 0x03 to digit 8 only
                sbrs    tBCD4,3         ;if bit 3 clear
                subi    tBCD4,0x03      ;       sub 3
                rjmp    binbcd_loop     ;

;***************************************************************************
;*
;* Bin4BCD == 32-bit Binary to BCD conversion
;*
;* fbin0:fbin1:fbin2:fbin3  >>>  tBCD0:tBCD1:tBCD2:tBCD3:tBCD4
;*           hex                              dec
;*       r16r17r18r19       >>>         r20r21r22r23r24
;*
;***************************************************************************
.def    fbin0   =r16    ; binary value byte 0 (LSB)
.def    fbin1   =r17    ; binary value byte 1
.def    fbin2   =r18    ; binary value byte 2
.def    fbin3   =r19    ; binary value byte 3 (MSB)
.def    tBCD0   =r20    ; BCD value digits 0 and 1
.def    tBCD1   =r21    ; BCD value digits 2 and 3
.def    tBCD2   =r22    ; BCD value digits 4 and 5
.def    tBCD3   =r23    ; BCD value digits 6 and 7
.def    tBCD4   =r24    ; BCD value digits 8 and 9 (MSD)

Bin4BCD20:      mov     r16,r20         ;for compatibility with Math32
                mov     r17,r21         ;
                mov     r18,r22         ;
                mov     r19,r23         ;
Bin4BCD16:      clr     tBCD0           ;initial result (5 bytes)
                clr     tBCD1           ;       & shift
                clr     tBCD2           ;              loop
                ldi     tBCD3,0xfe      ;                  counter
                ldi     tBCD4,0xff      ;                         too
                rjmp    binbcd_jump     ;for speed-up and skip of MSD corr
binbcd_876:     subi    tBCD4,-0x03     ;add 0x03 to digit 8 only
                sbrs    tBCD4,3         ;if bit 3 clear
                subi    tBCD4,0x03      ;       sub 3
                subi    tBCD3,-0x33     ;add 0x33 to digits 7 and 6
                sbrs    tBCD3,3         ;if bit 3 clear
                subi    tBCD3,0x03      ;       sub 3
                sbrs    tBCD3,7         ;if bit 7 clear
                subi    tBCD3,0x30      ;       sub $30
binbcd_54:      subi    tBCD2,-0x33     ;add 0x33 to digits 5 and 4
                sbrs    tBCD2,3         ;if bit 3 clear
                subi    tBCD2,0x03      ;       sub 3
                sbrs    tBCD2,7         ;if bit 7 clear
                subi    tBCD2,0x30      ;       sub $30
binbcd_3210:    subi    tBCD1,-0x33     ;add 0x33 to digits 3 and 2
                sbrs    tBCD1,3         ;if bit 3 clear
                subi    tBCD1,0x03      ;       sub 3
                sbrs    tBCD1,7         ;if bit 7 clear
                subi    tBCD1,0x30      ;       sub $30
                subi    tBCD0,-0x33     ;add 0x33 to digits 1 and 0
                sbrs    tBCD0,3         ;if bit 3 clear
                subi    tBCD0,0x03      ;       sub 3
                sbrs    tBCD0,7         ;if bit 7 clear
                subi    tBCD0,0x30      ;       sub $30
binbcd_jump:    lsl     fbin0           ;
                rol     fbin1           ;
                rol     fbin2           ;
                rol     fbin3           ;shift input value
                rol     tBCD0           ;through all bytes
                rol     tBCD1           ;
                rol     tBCD2           ;
                rol     tBCD3           ;
                rol     tBCD4           ;
                brcs    binbcd_3210     ;16_lsl w/o correction of dig_87654
                inc     fbin0           ;
                brpl    binbcd_54       ;+7_lsl w/o correction of dig_876
                sbrs    fbin2,0         ;
                rjmp    binbcd_876      ;32_lsl in total (fbin = 0x1ffff)
                ret                     ;

;***************************************************************************
;*
;* Bin3BCD == 24-bit Binary to BCD conversion   [ together with Bin2BCD ]
;*
;* fbin0:fbin1:fbin2  >>>  tBCD0:tBCD1:tBCD2:tBCD3
;*        hex                        dec
;*     r16r17r18      >>>       r20r21r22r23
;*
;***************************************************************************
.def    fbin0   =r16    ; binary value byte 0 (LSB)
.def    fbin1   =r17    ; binary value byte 1
.def    fbin2   =r18    ; binary value byte 2 (MSB)
.def    tBCD0   =r20    ; BCD value digits 0 and 1
.def    tBCD1   =r21    ; BCD value digits 2 and 3
.def    tBCD2   =r22    ; BCD value digits 4 and 5
.def    tBCD3   =r23    ; BCD value digits 6 and 7 (MSD)

Bin3BCD:        ldi     tBCD3,0xff              ;initialize digits 7 and 6
binbcd_7:       inc     tBCD3                   ;
                subi    fbin0,byte1(10000*100)  ;subit fbin,1000000
                sbci    fbin1,byte2(10000*100)  ;
                sbci    fbin2,byte3(10000*100)  ;
                brcc    binbcd_7                ;
                subi    tBCD3,-6                ; delete decimal correction
                sbrs    tBCD3,4                 ; if NUMBER<10000000 always
                subi    tBCD3,6                 ;
                ldi     tBCD2,0x9f              ;initialize digits 5 and 4
binbcd_6:       subi    tBCD2,0x10              ;
                subi    fbin0,byte1(-10000*10)  ;addit fbin,100000
                sbci    fbin1,byte2(-10000*10)  ;
                sbci    fbin2,byte3(-10000*10)  ;
                brcs    binbcd_6                ;
binbcd_5:       inc     tBCD2                   ;
                subi    fbin0,byte1(10000)      ;subit fbin,10000
                sbci    fbin1,byte2(10000)      ;
                sbci    fbin2,byte3(10000)      ;
                brcc    binbcd_5                ;
                rjmp    binbcd_3-1              ;initialize digits 3 and 2

;***************************************************************************
;*
;* Bin3BCD == 24-bit Binary to BCD conversion
;*
;* fbin0:fbin1:fbin2  >>>  tBCD0:tBCD1:tBCD2:tBCD3
;*        hex                        dec
;*     r16r17r18      >>>       r20r21r22r23
;*
;***************************************************************************
.def    fbin0   =r16    ; binary value byte 0 (LSB)
.def    fbin1   =r17    ; binary value byte 1
.def    fbin2   =r18    ; binary value byte 2 (MSB)
.def    tBCD0   =r20    ; BCD value digits 0 and 1
.def    tBCD1   =r21    ; BCD value digits 2 and 3
.def    tBCD2   =r22    ; BCD value digits 4 and 5
.def    tBCD3   =r23    ; BCD value digits 6 and 7 (MSD)

Bin3BCD20:      mov     r16,r20         ;for compatibility with Math32
                mov     r17,r21         ;
                mov     r18,r22         ;
Bin3BCD16:      ldi     tBCD3,0xfa              ;initialize digits 7 and 6
binbcd_107:     subi    tBCD3,-0x10             ;
                subi    fbin0,byte1(10000*1000) ;subit fbin,10^7
                sbci    fbin1,byte2(10000*1000) ;
                sbci    fbin2,byte3(10000*1000) ;
                brcc    binbcd_107              ;
binbcd_106:     dec     tBCD3                   ;
                subi    fbin0,byte1(-10000*100) ;addit fbin,10^6
                sbci    fbin1,byte2(-10000*100) ;
                sbci    fbin2,byte3(-10000*100) ;
                brcs    binbcd_106              ;
                ldi     tBCD2,0xfa              ;initialize digits 5 and 4
binbcd_105:     subi    tBCD2,-0x10             ;
                subi    fbin0,byte1(10000*10)   ;subit fbin,10^5
                sbci    fbin1,byte2(10000*10)   ;
                sbci    fbin2,byte3(10000*10)   ;
                brcc    binbcd_105              ;
binbcd_104:     dec     tBCD2                   ;
                subi    fbin0,byte1(-10000)     ;addit fbin,10^4
                sbci    fbin1,byte2(-10000)     ;
                sbci    fbin2,byte3(-10000)     ;
                brcs    binbcd_104              ;
                ldi     tBCD1,0xfa              ;initialize digits 3 and 2
binbcd_103:     subi    tBCD1,-0x10             ;
                subi    fbin0,byte1(1000)       ;subiw fbin,10^3
                sbci    fbin1,byte2(1000)       ;
                brcc    binbcd_103              ;
binbcd_102:     dec     tBCD1                   ;
                subi    fbin0,byte1(-100)       ;addiw fbin,10^2
                sbci    fbin1,byte2(-100)       ;
                brcs    binbcd_102              ;
                ldi     tBCD0,0xfa              ;initialize digits 1 and 0
binbcd_101:     subi    tBCD0,-0x10             ;
                subi    fbin0,10                ;subi fbin,10^1
                brcc    binbcd_101              ;
                add     tBCD0,fbin0             ;LSD
                ret                             ;

;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Demo:   ;-)(-:-)(-;-)(-:-)(-;-)(-:-)(-;-)(-:-)(-;-)(-:-)(-;-)(-:-)(-;-)(-:-)

;***************************************************************************
;$ $ $ $ $ $ $ $ $    Illustrations with comments field    $ $ $ $ $ $ $ $ $
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.dseg
Variable:       .byte 4
VarWord1:       .byte 2
VarWord2:       .byte 2
Result:         .byte 8
.equ Address1   =VarWord1
.equ Address2   =VarWord2
.equ Address    =Variable
.set Constant   =0x4321

.cseg
.def Temp       =r16
.def TempL      =r16
.def TempH      =r17
.def Flags      =r15
.equ _Flag1     =1
.equ _Flag2     =2
.equ _Flag3     =3
.equ _signResult=0

;*** OUTI, OUTIW, OUTW, INW
                outiw   SP,Temp,RAMEND  ;initialize 16-bit Stack Pointer
                outi    TCNT0,Temp,0    ;clear Timer/Counter0 (8-bit)
                inw     Temp,TCNT1      ;read Timer/Counter1 (16-bit)
                outw    TCNT1,Temp      ;write Timer/Counter1 (16-bit)

;*** CLF, SEF, CBF, SBF, IBF
                clf     Flags,_Flag1             ;clear (0) bit _Flag1
                bld     Flags,_Flag2             ;      and bit _Flag2
                cbf     Flags,Temp,_Flag1,_Flag2 ;clear both at once
                sef     Flags,_Flag1             ;set (1) bit _Flag1
                bld     Flags,_Flag2             ;    and bit _Flag2
                sbf     Flags,Temp,_Flag1,_Flag2 ;set both at once
                ibf     Flags,Temp,_Flag1,_Flag2,_Flag3 ;invert of 3 flags
                ibf     TempL,TempH,0,2,4,6      ;invert only even bits

;*** XCH, MVW, MVI, MOVS, MOVSW
                xch     TempL,TempH     ;swap in Temp register pair
                xch     Temp,r0         ;swap bytes r0 & Temp
                mvw     X,Y     ;copy of Y register pair into X pair
                mvw     Z,Temp  ;copy of TempL&TempH into Z register pair
                mvi     Flags,Temp,exp2(_Flag1)|1<<_Flag2 ;initialize flags
                mvi     r0,Temp,Constant        ;load to low register (0-15)
                movs    Address1,Temp,Address2  ;copy of one memory byte
                movsw   Address1,Temp,Address2  ;copy of two memory bytes

;*** STSI, STSIW, LDSW, STSW
                stsi    Address,Temp,Constant   ;initialize of one memory byte
                stsiw   Address,Temp,Constant   ;initialize of two memory bytes
                ldsw    Temp,Address1   ;copy of two memory bytes
                stsw    Address2,Temp   ;  via Temp register pair

;*** LDIW, LDDW, STDW
                ldiw    Temp,Constant   ;initialize of register pair
                ldiw    Z,Address       ;initialize of address pointer
                lddw    Temp,Z+(Address1-Address) ;copy of two memory bytes
                stdw    Z+(Address2-Address),Temp ;  via Temp register pair

;*** PUSHW, POPW
                pushw   Y               ;copy of Y register pair
                popw    X               ;   into X register pair
                ldiw    Temp,Maths
                pushw   Temp
                ret                     ;equ jmp Maths
Maths:
;***** INITMEM
                InitMem Address         ;clear 128 bytes (latest Address+127)
                InitMem Address,0       ;equ InitMem Address
                InitMem Address,0,0     ;equ InitMem Address
                InitMem Address,,1      ;for 128 bytes each:=0xff
                InitMem Address,1       ;clear one byte at Address
                InitMem Address1,Address2-Address1+2,Limit
                ;limitation: if bit_T=0 then 4_bytes:=0xff else 4_bytes:=0
                ldi     MathPattern,0xab
                InitMem Address,,+1     ;128_bytes:=0xab doubly, but possibly

;***** MATHR16, MATHR20, OPERAND
                Operand Address         ;equ MathR20 Address,obXXXX
                MathR20 Address         ;equ Operand Address
.set ObXXXX=0b11
                MathR16 Address         ;equ Operand Address,0b0011,r16
.set ObXXXX=0b1111   ;default
                Operand Address,,r16    ;equ MathR16 Address,obXXXX
                Operand Address,,r20    ;equ MathR20 Address,obXXXX
                Operand Address,0b11    ;equ MathR20 Address,0b0011
                Operand Address,0b11,r16;equ MathR16 Address,0b0011
;load data with displacement (equ *256, *65536, *16777216)
                MathR20 Address,0b0110          ;(data word)<<8
                MathR16 Address,0b1000          ;(data byte)<<24

;***** CONST20, CONST16, CNST16T
; WARNING: AVRASM ver. 1.30 don't understand 32 bits constants, but all it
; expressions are internally 32 bits (the higher versions of assembler
; directly operate on value up to 0xffffffff)
                Const20 0x76543210              ;error v1.30 (0x00003210)
                Const20 1985229328              ;error v1.30 (12816)
                Const16 0x7654<<16|0x3210       ;ok (0x76543210)
                Cnst16t 0x7654*1024*1024+0x1234 ;ok (0x401234)

;***** CNST16B, CNST16W
                Cnst16b Constant        ;equ Const16 byte1(Constant)
                rcall   Div32b          ;    rcall Div32 ;but briefly
                Cnst16w Constant<<1     ;non-equ Const16 Constant<<1
                rcall   Mul32w          ;        rcall Mul32 ;word overflow

;***** RESULT2, RESULT3
                Result2 Address         ;equ Result2 Address,obXXXX
;store data with displacement (equ /256, /65536, /16777216 and more)
                Result2 Address,1<<7            ;(byte result)>>56
                Result2 Address,0b111100        ;(double word result)>>16
                Result2 Address,obXXXX<<4       ;(double word result)>>32
                rjmp    JointTail+3
JointTail:      Result3 Address,0xff    ;equ Result2 Address,0b11111111
                rcall   JointTail       ;concluding RET inside Result call

;******* register pairs
.def AL=r16
.def AH=r17
.def BL=r18
.def BH=r19
.def CL=r20
.def CH=r21
.def DL=r22
.def DH=r23
.def WL=r24
.def WH=r25
                ldiw    C,0             ;equ
                ldiw    D,0x7654        ;    Const20 0x7654<<16
                ldiw    A,0x3210        ;equ Cnst16w 0x3210
                ldi     AL,0x10         ;equ Cnst16b 0x10
                mvw     A,C     ;copy of Const20
                mvw     B,D     ;   into Const16
                adiw    WL,1    ;as well as "adiw" for X,Y,Z register pairs
                sbiw    WL,1    ;as well as "sbiw" for X,Y,Z register pairs

;******* testing calculations
                InitMem Variable,4,1            ; 0xffffffff to memory

                Operand Variable
                Const16 0xffff<<16|0xffff
                rcall   Mul32                   ; 0xffffffff * 0xffffffff
                Result2 Result,0b11111111       ; 0xfffffffe00000001

                Operand Variable
                Const16 0x1010<<16|0x1010
                rcall   Div32                   ; 0xffffffff / 0x10101010
                Result2 Result,0b11111111       ; 0xf (0x0f0f0f0f)

                Operand Variable,0b111
                Cnst16t 0x00ff<<16|0xffff
                rcall   Div32t                  ; 0xffffff / 0xffffff
                Result2 Result                  ; 0x1 (0x0 no rollout)

                Operand Variable,0b1100
                Cnst16w 0xffff
                rcall   Div32w                  ; 0xffff0000 / 0xffff
                Result2 Result                  ; 0x10000 (0x0 no rollout)

;******* data translations 16-bit (overall maximum 65535=0xffff)
;result Rd16|24
                Const20 0x2748
                rcall   BCD2bin         ;02748 = 0x0abc
                Cnst16t 6<<16|0x5535
                rcall   BCD2bin16       ;65535 = 0xffff
                Result2 Address,0b11
                rcall   Bin2BCD         ;0xffff = 65535
                Cnst16w 0xabba
                rcall   Bin2BCD16       ;0xabba = 43962

;******* data translations 32-bit (overall maximum 655359999=0x270fffff)
;BCD2Bin
                stsiw   Variable,Temp,0x5432    ;
                stsiw   Variable+2,Temp,0x9876  ;BCD 98765432 >>>
                Operand Variable,0b11
                rcall   BCD2bin
                pushw   C               ;temporary result always is 2 bytes
                Operand Variable+2,0b11 ;or 0b111 if BCD have all 5 digits
                rcall   BCD2bin
                ldiw    D,0
                Cnst16w 10000
                rcall   Mul32w
                popw    A               ;B pair by this time =0
                rcall   Add32
                Result2 Result,0b1111           ;>>> HEX 0x05e30a78
;Bin2BCD
                stsiw   Variable,Temp,0xffff    ;
                stsiw   Variable+2,Temp,0x270f  ;HEX 0x270fffff >>>
                Operand Variable,0b1111
                Cnst16w 10000           ;remainder always is 2 bytes
                rcall   Div32w          ;          as temporary result
                rcall   Bin2BCD
                Result2 Result+2,0b111
                mvw     A,W             ;W pair do not changed beyond
                rcall   Bin2BCD16
                Result2 Result,0b11             ;>>> BCD 655359999

;******* 32-bit Bin4BCD conversion (overall maximum 4294967295=0xffffffff)
;result Rd40
                ldi     YL,18           ;one more dishonest trick
                Operand Variable,0b1111,1+
                rcall   Bin4BCD         ;0x270fffff >>> 655359999
                Const20 0x1234<<16|0x5678
                Result2 18
                rcall   Bin4BCD         ;0x12345678 >>> 305419896
                Const16 0xab98<<16|0xfedc
                mvw     C,A
                rcall   Bin4BCD         ;0xfedcab98 >>> 4275874712
                InitMem Variable,3,1    ; 0xffffff to memory
                MathR20 Variable,0b111
                MathR16 Variable,0b111
                rcall   Mul32t          ;(0xffffff)^2 = 0xfffffe000001
                Result2 18,0b111100     ;      /65536 = 0xfffffe00
                rcall   Bin4BCD         ;0xfffffe00 >>> 4294966784

;******* data translations 32-bit (overall maximum 4294967295=0xffffffff)
;Bin4BCD20
                Operand Variable,0b1111
                rcall   Bin4BCD20       ;0x27ffffff >>> 671088639
                Const20 0x1234<<16|0x5678
                rcall   Bin4BCD20       ;0x12345678 >>> 305419896
                ldiw    D,0
                ldiw    C,0xab
                rcall   Bin4BCD20       ;      0xab >>> 171
;Bin4BCD16
                rcall   Bin4BCD16       ;   0x1ffff >>> 131071
                Const16 0xfedc<<16|0xab98
                rcall   Bin4BCD16       ;0xfedcab98 >>> 4275874712
                InitMem Variable,4,1
                MathR16 Variable,0b1111
                rcall   Bin4BCD16       ;0xffffffff >>> 4294967295

;******* data translations 24-bit (overall maximum 16777215=0xffffff)
;BCD3bin
                Const20 $1670<<16|$2650
                rcall   BCD3bin         ;16702650 >>> 0xfedcba
                ldiw    B,0
                ldiw    A,9
                rcall   BCD3bin16       ;00000009 >>> 0x000009 (fastest)
                ldiw    D,0x1599
                ldiw    C,0x9990
                rcall   BCD3bin20       ;15999990 >>> 0xf423f6 (slowest)
;Bin3BCD
                Const16 0x98<<16|0x967f
                rcall   Bin3BCD         ;0x98967f >>> 09999999
                rcall   Bin3BCD         ;0xffff09 >>> 16776969
                Cnst16t $0d00*256+$df22
                rcall   Bin3BCD         ;0x0ddf22 >>> 00909090 (fastest)
                Cnst16t $f500*256+$871d
                rcall   Bin3BCD         ;0xf5871d >>> 16090909 (slowest)
;Bin3BCD20
                MathR20 Variable,0b111
                rcall   Bin3BCD20       ;0xffffff >>> 16777215
                rcall   Bin3BCD20       ;0x777215 >>> 07827989
                Const20 $a600*256+$75a2
                rcall   Bin3BCD20       ;0xa675a2 >>> 10909090 (slowest)
;Bin3BCD16
                Cnst16t $8a00*256+$b75d
                rcall   Bin3BCD16       ;0x8ab75d >>> 09090909 (fastest)
                ldi     AH,0xff
                rcall   Bin3BCD16       ;  0xffff >>> 65535
                ldi     AL,0
                rcall   Bin3BCD16       ;0x000000 >>> 00000000

;******* formula recalculation: Result=(VarWord1-0xfff)/7+VarWord2/0x100
;VarWordX>=0
                InitMem Variable,16             ;clear VarWordX & Result
                rcall   Formula                 ; -0x249.0000 as result

                ldiw    Temp,0xabcd             ;these 2 lines are not equ
                stsw    VarWord1,Temp           ;stsiw VarWord1,Temp,0xabcd
                stsw    VarWord2,Temp
                rcall   Formula                 ; 0x16ed.cd00 as result

                stsiw   VarWord1,Temp,0x00ff
                stsiw   VarWord2,Temp,0xff00
                rcall   Formula                 ; -0x125.9249 as result

                stsiw   VarWord1,Temp,0x0f0f
                stsiw   VarWord2,Temp,0xf0f0
                rcall   Formula                 ; 0x00ce.a6dc as result

                InitMem VarWord1,4,1            ; 0x2349.2392 at the end
                ldiw    Temp,Demo
                pushw   Temp                    ;getting into demo loop
Formula:
                MathR20 VarWord1,0b1100
                Const16 0xfff<<16
                rcall   Sub32sign
                Cnst16b 7
                rcall   Div32b
                Result2 16              ;faster than call MathR16 20
                MathR16 20              ;included for comparison only
                MathR20 VarWord2,0b110
                rcall   Add32sign
                bld     Flags,_signResult
                Result3 Result
.exit
;***************************************************************************
;*
;* REMARK
;* Sometimes expression as macroparameter must be enclosed in parentheses,
;* because they not are always present in above macrocalls
;* (remember about the priority of AVR assembler operators).
;* Accommodate oneself to ATmega: MOVW instruction e.g., etc.
;*
;***************************************************************************
;Feedback: please, include abbr."Math32" in Your e-mail subject line (!spam)
;from time to time it is possible mailbox overflow &| shut-down - I am sorry
;to make mention of http://www.i.com.ua/~birua when occasion offers - Thanks
;All the best & good luck! <EOF>
