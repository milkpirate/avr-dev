;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 LCD-Routinen                ;;
;;                 ============                ;;
;;              (c)andreas-s@web.de            ;;
;;                                             ;;
;; 4bit-Interface                              ;;
;; DB4-DB7:       PD0-PD3                      ;;
;; RS:            PD4                          ;;
;; E:             PD5                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
.def temp2 = r22
.def temp3 = r23
 
.equ LCD_PORT = PORTD
.equ LCD_DDR  = DDRD
.equ PIN_RS   = 4
.equ PIN_E    = 5

.ifndef XTAL
.equ XTAL = 4000000
.endif

 ;sendet ein Datenbyte an das LCD
lcd_data:
           push  temp2
           push  temp3
           mov   temp2, temp1            ; "Sicherungskopie" für
                                         ; die Übertragung des 2.Nibbles
           swap  temp1                   ; Vertauschen
           andi  temp1, 0b00001111       ; oberes Nibble auf Null setzen
           sbr   temp1, 1<<PIN_RS        ; entspricht 0b00010000
           in    temp3, LCD_PORT
           andi  temp3, 0x80
           or    temp1, temp3
           out   LCD_PORT, temp1         ; ausgeben
           rcall lcd_enable              ; Enable-Routine aufrufen
                                         ; 2. Nibble, kein swap da es schon
                                         ; an der richtigen stelle ist
           andi  temp2, 0b00001111       ; obere Hälfte auf Null setzen 
           sbr   temp2, 1<<PIN_RS        ; entspricht 0b00010000
           or    temp2, temp3
           out   LCD_PORT, temp2         ; ausgeben
           rcall lcd_enable              ; Enable-Routine aufrufen
           rcall delay50us               ; Delay-Routine aufrufen

           pop   temp3
           pop   temp2
           ret                           ; zurück zum Hauptprogramm
 
 ; sendet einen Befehl an das LCD
lcd_command:                            ; wie lcd_data, nur ohne RS zu setzen
           push  temp2
           push  temp3

           mov   temp2, temp1
           swap  temp1
           andi  temp1, 0b00001111
           in    temp3, LCD_PORT
           andi  temp3, 0x80
           or    temp1, temp3
           out   LCD_PORT, temp1
           rcall lcd_enable
           andi  temp2, 0b00001111
           or    temp2, temp3
           out   LCD_PORT, temp2
           rcall lcd_enable
           rcall delay50us
 
           pop   temp3
           pop   temp2
           ret
 
 ; erzeugt den Enable-Puls
lcd_enable:
           sbi LCD_PORT, PIN_E          ; Enable high
           nop                          ; 3 Taktzyklen warten
           nop
           nop
           cbi LCD_PORT, PIN_E          ; Enable wieder low
           ret                          ; Und wieder zurück                     
 
 ; Pause nach jeder Übertragung
delay50us:                              ; 50us Pause
           ldi  temp1, ( XTAL * 50 / 3 ) / 1000000
delay50us_:
           dec  temp1
           brne delay50us_
           ret                          ; wieder zurück
 
 ; Längere Pause für manche Befehle
delay5ms:                               ; 5ms Pause
           ldi  temp1, ( XTAL * 5 / 607 ) / 1000
WGLOOP0:   ldi  temp2, $C9
WGLOOP1:   dec  temp2
           brne WGLOOP1
           dec  temp1
           brne WGLOOP0
           ret                          ; wieder zurück
 
 ; Initialisierung: muss ganz am Anfang des Programms aufgerufen werden
lcd_init:
           push  temp1
           in    temp1, LCD_DDR
           ori   temp1, (1<<PIN_E) | (1<<PIN_RS) | 0x0F
           out   LCD_DDR, temp1

           ldi   temp3,6
powerupwait:
           rcall delay5ms
           dec   temp3
           brne  powerupwait
           ldi   temp1,    0b00000011   ; muss 3mal hintereinander gesendet
           out   LCD_PORT, temp1        ; werden zur Initialisierung
           rcall lcd_enable             ; 1
           rcall delay5ms
           rcall lcd_enable             ; 2
           rcall delay5ms
           rcall lcd_enable             ; und 3!
           rcall delay5ms
           ldi   temp1,    0b00000010   ; 4bit-Modus einstellen
           out   LCD_PORT, temp1
           rcall lcd_enable
           rcall delay5ms
           ldi   temp1,    0b00101000   ; 4 Bot, 2 Zeilen
           rcall lcd_command
           ldi   temp1,    0b00001100   ; Display on, Cursor off
           rcall lcd_command
           ldi   temp1,    0b00000100   ; endlich fertig
           rcall lcd_command

           pop   temp1
           ret
 
 ; Sendet den Befehl zur Löschung des Displays
lcd_clear:
           push  temp1
           ldi   temp1,    0b00000001   ; Display löschen
           rcall lcd_command
           rcall delay5ms
           pop   temp1
           ret

 ; Cursor Home
lcd_home:
           push  temp1
           ldi   temp1,    0b00000010   ; Cursor Home
           rcall lcd_command
           rcall delay5ms
           pop   temp1
           ret

 ; Einen konstanten Text aus dem Flash Speicher
 ; ausgeben. Der Text wird mit einer 0 beendet
lcd_flash_string:
           push  temp1

lcd_flash_string_1:
           lpm   temp1, Z+
           cpi   temp1, 0
           breq  lcd_flash_string_2
           rcall  lcd_data
           rjmp  lcd_flash_string_1

lcd_flash_string_2:
           pop   temp1
           ret

 ; Eine Zahl aus dem Register temp1 dezimal ausgeben
lcd_number:
           push  temp1
           push  temp2
           push  temp3

           mov   temp2, temp1
                                  ; abzählen wieviele Hunderter
                                          ; in der Zahl enthalten sind
           ldi   temp1, '0'
lcd_number_1:
           subi  temp2, 100
           brcs  lcd_number_2
           inc   temp1
           rjmp  lcd_number_1
                                          ;
                                          ; die Hunderterstelle ausgeben
lcd_number_2:
           rcall lcd_data
           subi  temp2, -100              ; 100 wieder dazuzählen, da die
                                          ; vorherhgehende Schleife 100 zuviel
                                          ; abgezogen hat

                                          ; abzählen wieviele Zehner in
                                          ; der Zahl enthalten sind
           ldi   temp1, '0'
lcd_number_3:
           subi  temp2, 10
           brcs  lcd_number_4
           inc   temp1
           rjmp  lcd_number_3

                                          ; die Zehnerstelle ausgeben
lcd_number_4:
           rcall lcd_data
           subi  temp2, -10               ; 10 wieder dazuzählen, da die
                                          ; vorhergehende Schleife 10 zuviel
                                          ; abgezogen hat

                                          ; die übrig gebliebenen Einer
                                          ; noch ausgeben
           ldi   temp1, '0'
           add   temp1, temp2
           rcall lcd_data

           pop   temp3
           pop   temp2
           pop   temp1
           ret

; eine Zahl aus dem Register temp1 hexadezimal ausgeben
lcd_number_hex:
           push  temp1

           swap  temp1
           andi  temp1, $0F
           rcall lcd_number_hex_digit

           pop   temp1
           push  temp1

           andi  temp1, $0F
           rcall lcd_number_hex_digit

           pop   temp1
           ret

lcd_number_hex_digit:
           cpi   temp1, 10
           brlt  lcd_number_hex_digit_1
           subi  temp1, -( 'A' - '9' - 1 )
lcd_number_hex_digit_1:
           subi  temp1, -'0'
           rcall  lcd_data
           ret

  
