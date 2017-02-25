; I2C-Ein-/Ausgänge:
.equ  I2C_PORT  = PORTA
.equ  SDA       = PA0  ; SDA = PortA/Bit0
.equ  SCL       = PA1  ; SCL = PortA/Bit1

; I2C-Slave-Adressen:
.equ  LM92_addr   = 0x4B  ; Adresse des Temperatursensors





;***************************** I2C MACROS **********************************

.macro SCL_Up      ; steigende Flanke von SCL
  cbi  I2C_PORT-1,SCL  ; SCL = hochohmig
.endmacro

.macro SCL_Dwn      ; fallende Flanke von SCL
  sbi  I2C_PORT-1,SCL  ; SCL = log. 0
.endmacro

.macro SDA_Hi      ; setzt SDA auf 1
  cbi  I2C_PORT-1,SDA  ; SDA = hochohmig
.endmacro

.macro SDA_Lo      ; setzt SDA auf 0
  sbi  I2C_PORT-1,SDA  ; SDA = log. 0
.endmacro


;************************** Sensor Temperatur ******************************
; Sub: Liest Temperatur vom Sensor
; Parameter:  -
; Return:  Temperatur TEMP_H, TEMP_L
; Scratch-Reg:  r16, r17
;***************************************************************************

read_temperatur:
    ldi  r16, LM92_addr
    clc      ; I2C Write
    rol  r16
    rcall  i2c_start  ; Start + I2C Adresse + Write senden
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor  ; NACK: Sensor nicht ansprechbar
    clr  r16
    rcall  i2c_write  ; Pointerregister -> TemperaturRegister LM92
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor
    ldi  r16, LM92_addr
    sec      ; I2C Read
    rol  r16
    rcall  i2c_rep_start  ; Start + I2C Adresse + Read senden
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor  ; NACK: Sensor nicht ansprechbar
    set
    rcall  i2c_read
    sts  TEMP_MSB,r16
    clt
    rcall  i2c_read
    sts  TEMP_LSB,r16
    rcall  i2c_stop
    ret
no_sensor:
    ret


#ifdef  LM92_SHUTDOWN
;************************** Sensor Temperatur ******************************
; Sub: Setzt den LM92 in Shutdown
; Parameter:  -
; Return:    
; Scratch-Reg:  r16, r17
;***************************************************************************

LM92_shutdown_on:
    ldi  r16, LM92_addr
    clc      ; I2C Write
    rol  r16
    rcall  i2c_start  ; Start + I2C Adresse + Write senden
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor; NACK: Sensor nicht ansprechbar
    ldi  r16,1    ; Pointerregister -> ConfigurationRegister LM92
    rcall  i2c_write
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor
    ldi  r16,1    ; ConfigurationRegister LM92 -> set Shutdown Bit
    rcall  i2c_write
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor
    rcall  i2c_stop
    ret


LM92_shutdown_off:
    ldi  r16, LM92_addr
    clc      ; I2C Write
    rol  r16
    rcall  i2c_start  ; Start + I2C Adresse + Write senden
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor  ; NACK: Sensor nicht ansprechbar
    ldi  r16,1  ; Pointerregister -> ConfigurationRegister LM92
    rcall  i2c_write
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor
    ldi  r16,0  ; ConfigurationRegister LM92 -> clear Shutdown Bit
    rcall  i2c_write
    in  r16, SREG
    sbrs  r16,SREG_T
    rjmp  no_sensor
    rcall  i2c_stop
    ret
#endif

;************************** Software I2C Routinen **************************
wait1us:    ; @ 8Mhz
  nop
  ret

i2c_init:
  cbi  I2C_PORT, SCL
  cbi  I2C_PORT, SDA
  SCL_Up
  SDA_Hi
  ret  

i2c_rep_start:      ; Wiederholen der Startbedingung
  SCL_Dwn      ; setzt SCL auf 0
  rcall   wait1us    ; Zeitschleife
  nop
  nop
  nop
  SCL_up      ; setzt SCL auf 1
  rcall   wait1us    ; Zeitschleife
  nop
  nop
  nop
i2c_start:        
  SDA_Lo      ; SDA = 0: Startbedingung
  rcall   wait1us    ; Zeitschleife
  rcall   wait1us

i2c_write:      ; schreibt ein Byte zum Slave
  sec      ; Carry = 1
  rol     r16    ; nach links schieben, 1->LSB, MSB->C
  rjmp    i2c_bit1  ; Sonderbehandlung für das 1. Bit

i2c_wr_bit:
  lsl     r16    ; wenn r16 leer ist, ...
i2c_bit1:
  breq    i2c_get_ack  ; ... ist der Transfer abgeschlossen
  SCL_Dwn      ; fallende Flanke von SCL
  brcc    i2c_wr_low  ; Sprung, wenn Bit im Carry = 0
  nop      ; zum Ausgleich der Laufzeiten
  SDA_Hi      ; setzt SDA auf 1
  rjmp    i2c_scl_high
i2c_wr_low:
  SDA_Lo      ; setzt SDA auf 0
  rjmp    i2c_scl_high; zum Ausgleich der Taktzeiten

i2c_scl_high:
  rcall   wait1us
  SCL_Up      ; steigende Flanke von SCL
i2c_WB1:
  sbis    I2C_PORT-2,SCL  ; Wait-State des Slaves ?
  rjmp    i2c_WB1
  rcall   wait1us    ; Zeitschleife
  rjmp    i2c_wr_bit

i2c_get_ack:      ; Acknowledge des Slaves einlesen
  SCL_Dwn      ; fallende Flanke von SCL
  SDA_Hi      ; setzt SDA hochohmig
  rcall   wait1us    ; Zeitschleife
  nop
  nop
  nop
  SCL_Up      ; steigende Flanke von SCL
i2c_GA1:  
  sbis    I2C_PORT-2,SCL  ; Test, ob Wait-State des Slaves
  rjmp    i2c_GA1
  clt      ; Ack-Flag = 0 (T-Flag in SREG)  [NACK]
  sbis    I2C_PORT-2,SDA  ; wenn SDA = 1,
  set         ; Ack-Flag = 1 (T-Flag in SREG) [ACK]
  rcall   wait1us    ; Zeitschleife
  ret

i2c_read:
  ldi     r16,1    ; als Bitzähler vorbesetzen
i2c_RB1:
  SCL_Dwn      ; fallende Flanke von SCL
  SDA_Hi      ; setzt SDA hochohmig
  rcall  wait1us    ; Zeitschleife 5us
  nop
  nop
  nop
  SCL_Up      ; steigende Flanke von SCL

i2c_RB2:
  sbis    I2C_PORT-2,SCL   ; Test, ob Wait-State des Slaves
  rjmp    i2c_RB2
  clc      ; Carry = 0
  sbic    I2C_PORT-2,SDA   ; wenn SDA = 1
  sec      ;   Carry = 1
  rcall   wait1us    ; Zeitschleife
  nop
  rol     r16    ; gelesenes Bit ins Byte schieben
  brcc    i2c_RB1    ; Sprung, wenn Einlesen nicht beendet

i2c_ack:      ; gibt Acknowledge aus
  SCL_Dwn      ; fallende Flanke von SCL
  in  r17, SREG
  sbrc    r17,SREG_T  ; Skip, wenn ACK = 1
  rjmp    i2c_SA1    ; Sprung, wenn NACK = 0
  nop
  SDA_Hi      ; setzt SDA auf 1
  rjmp    i2c_SA2
i2c_SA1:
  SDA_Lo      ; setzt SDA auf 0
  nop      ; zum Ausgleich der Taktzeiten
  nop      ; zum Ausgleich der Taktzeiten
i2c_SA2:
  rcall  wait1us
  SCL_Up      ; steigende Flanke von SCL
i2c_SA3:
  sbis    I2C_PORT-2,SCL   ; Test, ob Wait-State des Slaves
  rjmp    i2c_SA3
  rcall   wait1us    ; Zeitschleife
  ret

i2c_stop:      ; gibt Stopp-Bedingung aus
  SCL_Dwn      ; fallende Flanke von SCL
  SDA_Lo      ; setzt SDA auf 0
  rcall   wait1us    ; Zeitschleife
  nop
  nop
  nop
  SCL_Up      ; steigende Flanke von SCL
  rcall   wait1us    ; Zeitschleife
  SDA_Hi      ; setzt SDA auf 1
  rcall   wait1us    ; Zeitschleife
  nop
  ret