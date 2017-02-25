.include "m8def.inc"
 
.def temp1 = r16
.def temp2 = r17
.def temp3 = r18
 
 
           ldi temp1, LOW(RAMEND)      ; LOW-Byte der obersten RAM-Adresse
           out SPL, temp1
           ldi temp1, HIGH(RAMEND)     ; HIGH-Byte der obersten RAM-Adresse
           out SPH, temp1
 
           rcall lcd_init              ; Display initialisieren
           rcall lcd_clear             ; Display löschen
 
           ldi ZL, LOW(text*2)         ; Adresse des Strings in den
           ldi ZH, HIGH(text*2)        ; Z-Pointer laden
 
           rcall lcd_flash_string      ; Unterprogramm gibt String aus der
                                       ; durch den Z-Pointer adressiert wird
loop:
           rjmp loop
 
text:
           .db ".",0                ; Stringkonstante, durch eine 0
                                       ; abgeschlossen  
 
.include "lcd-routines.asm"            ; LCD Funktionen 
