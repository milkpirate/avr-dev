/*
 ATtiny25/45/85 Blink
 Version: 1.0
 Author: Alex from Inside Gadgets (http://www.insidegadgets.com)
 Created: 25/04/2011
 Last Modified: 26/04/2011
 
 Blink an LED on the ATtiny25/45/85 using delay_ms and then timer to show both are operational.
 Uses the setup procedure and timer function/variables from the Arduino's wiring.c file as it's easier
 to use something that works rather than starting from scratch.
 
 */

#define F_CPU 1000000 // 1 MHz

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "setup.c"

// ATtiny25/45/85 Pin map
//                        +-\/-+
// Reset/Ain0 (D 5) PB5  1|o   |8  Vcc
//       Ain3 (D 3) PB3  2|    |7  PB2 (D 2) Ain1
//       Ain2 (D 4) PB4  3|    |6  PB1 (D 1) pwm1
//                  GND  4|    |5  PB0 (D 0) pwm0 <-- connect LED here
//                        +----+

#define		ledPin		PB0
#define		dly			250

int main(void) {
	
	setup();
	
	DDRB |= (1<<ledPin); // Set LED as an output
	
	while(1) {
		// Delay 1 second using delay_ms
		PORTB |= (1<<ledPin); // Turn on
		_delay_ms(dly);
		PORTB &= ~(1<<ledPin); // Turn off
		_delay_ms(dly);
	}
}
