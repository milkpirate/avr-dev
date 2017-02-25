.include "m8def.inc"
 
.def temp  = r16
.def temp1 = r17
.def temp2 = r18
 
.org 0x0000
           rjmp    main                ; Reset Handler
.org OVF0addr
           rjmp    multiplex
 
;
;********************************************************************
; Die Multiplexfunktion
;
; Aufgabe dieser Funktion ist es, bei jedem Durchlauf eine andere Stelle
; der 7-Segmentanzeige zu aktivieren und das dort vorgesehene Muster
; auszugeben
; Die Funktion wird regelmässig in einem Timer Interrupt aufgerufen
;
multiplex:
           push    temp                ; Alle verwendeten Register sichern
           push    temp1
           in      temp, SREG
           push    temp
           push    ZL
           push    ZH
 
           ldi     temp1, 0            ; Die 7 Segment ausschalten
           out     PORTC, temp1
 
                                       ; Das Muster für die nächste Stelle ausgeben
                                       ; Dazu zunächst mal berechnen, welches Segment als
                                       ; nächstest ausgegeben werden muss
           ldi     ZL, LOW( Segment0 ) 
           ldi     ZH, HIGH( Segment0 )
           lds     temp, NextSegment
           add     ZL, temp
           adc     ZH, temp1
 
           ld      temp, Z             ; das entsprechende Muster holen und ausgeben
           out     PORTD, temp
 
           lds     temp1, NextDigit    ; Und die betreffende Stelle einschalten
           out     PORTC, temp1
 
           lds     temp, NextSegment
           inc     temp
           sec
           rol     temp1               ; beim nächsten Interrupt kommt reihum die
           cpi     temp1, 0b11101111   ; nächste Stelle dran.
           brne    multi1
           ldi     temp, 0
           ldi     temp1, 0b11111110
 
multi1:
           sts     NextSegment, temp
           sts     NextDigit, temp1
 
           pop     ZH                  ; die gesicherten Register wiederherstellen
           pop     ZL
           pop     temp
           out     SREG, temp
           pop     temp1
           pop     temp
           reti
;
;************************************************************************
; 16 Bit-Zahl aus dem Registerpaar temp (=low), temp1 (=high) ausgeben
; die Zahl muss kleiner als 10000 sein, da die Zehntausenderstelle
; nicht berücksichtigt wird.
; Werden mehr als 4 7-Segmentanzeigen eingesetzt, dann muss dies
; natürlich auch hier berücksichtigt werden
;
out_number:
           push    temp
           push    temp1
 
           ldi     temp2, -1            ; Die Tausenderstelle bestimmen
_out_tausend:
           inc     temp2
           subi    temp, low(1000)      ; -1000
           sbci    temp1, high(1000)
           brcc    _out_tausend
 
           ldi     ZL, low(2*Codes)     ; fuer diese Ziffer das Codemuster fuer
           ldi     ZH, high(2*Codes)    ; die Anzeige in der Codetabelle nachschlagen
           add     ZL, temp2
 
           lpm
           sts     Segment3, r0         ; und dieses Muster im SRAM ablegen
                                        ; die OvI Routine sorgt dann duer die Anzeige
           ldi     temp2, 10
 
_out_hundert:                           ; die Hunderterstelle bestimmen
           dec     temp2                
           subi    temp, low(-100)      ; +100
           sbci    temp1, high(-100)
           brcs    _out_hundert
 
           ldi     ZL, low(2*Codes)     ; wieder in der Codetabelle das entsprechende
           ldi     ZH, high(2*Codes)    ; Muster nachschlagen
           add     ZL, temp2
 
           lpm
           sts     Segment2, r0         ; und im SRAM hinterlassen
 
           ldi     temp2, -1
_out_zehn:                              ; die Zehnerstelle bestimmen
           inc     temp2
           subi    temp, low(10)        ; -10
           sbci    temp1, high(10)
           brcc    _out_zehn
 
           ldi     ZL, low(2*Codes)     ; wie gehabt: Die Ziffer in der Codetabelle
           ldi     ZH, high(2*Codes)    ; aufsuchen
           add     ZL, temp2
 
           lpm
           sts     Segment1, r0         ; und entsprechend im SRAM ablegen
 
_out_einer:                             ; bleiben noch die Einer
           subi    temp, low(-10)       ; +10
           sbci    temp1, high(-10)
 
           ldi     ZL, low(2*Codes)     ; ... Codetabelle
           ldi     ZH, high(2*Codes)
           add     ZL, temp
 
           lpm
           sts     Segment0, r0         ; und ans SRAm ausgeben
 
           pop     temp1
           pop     temp
 
           ret
;
;**************************************************************************
;
main:
           ldi     temp, HIGH(RAMEND)
           out     SPH, temp
           ldi     temp, LOW(RAMEND)  ; Stackpointer initialisieren
           out     SPL, temp
;                                     die Segmenttreiber initialisieren
           ldi     temp, $FF
           out     DDRD, temp
;                                     die Treiber für die einzelnen Stellen
           ldi     temp, $0F
           out     DDRC, temp
;                                     initialisieren der Steuerung für die
;                                     Interrupt Routine
           ldi     temp, 0b11111110
           sts     NextDigit, temp
 
           ldi     temp, 0
           sts     NextSegment, temp
 
           ldi     temp, ( 1 << CS01 ) | ( 1 << CS00 )
           out     TCCR0, temp
 
           ldi     temp, 1 << TOIE0
           out     TIMSK, temp
 
           sei
 
           ldi     temp, 0
           ldi     temp1, 0
 
loop:
           inc     temp
           brne    _loop
           inc     temp1
_loop:
           rcall    out_number
 
           cpi     temp, low( 4000 )
           brne    wait
           cpi     temp1, high( 4000 )
           brne    wait
 
           ldi     temp, 0
           ldi     temp1, 0
 
wait:      ldi     r21, 1
wait0:     ldi     r22, 0
wait1:     ldi     r23, 0
wait2:     dec     r23
           brne    wait2
           dec     r22
           brne    wait1
           dec     r21
           brne    wait0
 
           rjmp    loop
 
Codes:
    .db  0b11000000, 0b11111001     ; 0: a, b, c, d, e, f
                                    ; 1: b, c
    .db  0b10100100, 0b10110000     ; 2: a, b, d, e, g
                                    ; 3: a, b, c, d, g
    .db  0b10011001, 0b10010010     ; 4: b, c, f, g
                                    ; 5: a, c, d, f, g
    .db  0b10000010, 0b11111000     ; 6: a, c, d, e, f, g
                                    ; 7: a, b, c
    .db  0b10000000, 0b10010000     ; 8: a, b, c, d, e, f, g
                                    ; 9: a, b, c, d, f, g 
 
           .DSEG
NextDigit:   .byte 1         ; Bitmuster für die Aktivierung des nächsten Segments
NextSegment: .byte 1         ; Nummer des nächsten aktiven Segments
Segment0:    .byte 1         ; Ausgabemuster für Segment 0
Segment1:    .byte 1         ; Ausgabemuster für Segment 1
Segment2:    .byte 1         ; Ausgabemuster für Segment 2
Segment3:    .byte 1         ; Ausgabemuster für Segment 3
