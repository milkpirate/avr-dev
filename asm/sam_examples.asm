            .nolist
            .include "m32def.inc"
            .include "sam.inc"
            .list
;
; if-(then)-else-end macro examples
; 
; simple if-then-else example
            cpi   r16,0x20
            ifeq  space_chr
              ;...some code
            else  space_chr
              ;...some code
            end   space_chr

; no else part
            cpi   r16,0
            ifeq  null_chr
              ;...some code
            end   null_chr

; if after a skip - switch is active low due to a pullup
            sbic  porta,0
            ifs   switch_A
              ;...on code
            else  switch_a
              ;...off code
            end   switch_a
            
; IFxx would results in a branch out of range
            cpi   r16,27
            ifeq_far    esc_chr
              ;...some very long code
            end   esc_chr

; nesting
            cpi   r16,'a'
            ifeq  a_chr
              cpi   r17,'b'
              ifeq   a_and_b
                ;...a&b
              else   a_and_b
                ;...a&-b
              end    a_and_b
            else  a_chr
              cpi r17,'c'
              ifeq  c_but_no_a
                ;...-a&+c
              else  c_but_no_a
                ;...-a&c
              end   c_but_no_a
            end   a_chr

; 2 or more conditions are anded together (all conditions must be true)
.dseg
buffer:     .BYTE 400
end_buffer:
.cseg
            cpi   zh,high(end_buffer)
            ifeq_and    end_buffer_reached
            cpi   zl,low(end_buffer)
            ifeq        end_buffer_reached
              ldi   zh,high(buffer)       ;wrap buffer
              ldi   zl,low(buffer)
            end         end_buffer_reached
            ld    r0,z+                   ;read buffer

; 2 or more conditions are ored together (at least one condition must be true)
            cpi   r16,0
            ifeq_or     null_or_space
            cpi   r16,0x20
            ifeq        null_or_space
              ;...some code
            else        null_or_space
              ;...some code
            end         null_or_space

; when mixing IFxx_OR & IFxx_AND, the first true IFxx_OR takes the THEN path and
; the first false IFxx_AND takes the ELSE path (decreasing sequential precedence)
;
; want to or/and in any combination? - write your own IF blocks or use nesting!
;
;
; do-exit-loop examples
;
; typical endless loop
            do    main
              ;...some code
            loop  main

; waiting for an event
            do    wait_xmit
              sbis  ucsra,udre      ;until usart transmit buffer empty
            loop  wait_xmit

; countdown loop
; similar to: for r16 = 40 to 1 step -1
            ldi   r16,40
            do    count_40
              dec   r16
            loopne count_40

; reading a buffer until end
; similar to: for z = buffer to (end_buffer - 1)
            ldi   zh,high(buffer)   ;init buffer pointer
            ldi   zl,low(buffer)
            do    read_buf
              ld    r0,z+
              cpi   zh,high(end_buffer)
            loopne read_buf
              cpi   zl,low(end_buffer)
            loopne read_buf

; using exit and nesting
            do    skip_space
              do    wait_rx
                sbis  ucsra,rxc
              loop  wait_rx
              in    r16,udr
              cpi   r16,0x20
            exitne    skip_space
              inc   r17       ;count spaces
            loop  skip_space

; long loops - LOOPxx or EXITxx branches would be out of range
            do    long_loop
              ;...some very long code
              cpi   r16,27
              ifeq  esc_received
            exit  long_loop
              end   esc_received
            loop  long_loop
