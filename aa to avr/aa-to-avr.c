/**
 *
 * test to power an avr from just one AA cell
 *
 */

 /*
var/reg &= ~(1 << bit)      // clear bit in var/reg
var/reg |=  (1 << bit)      // set bit in var/reg
var/reg ^=  (1 << bit)      // toggle bit in var/reg
bit = var/reg & (1 << bit); // check bin in var/reg
*/

#define F_CPU 1200000		// 1,2MHz internal osci (= 9,6 MHz / 8)

#include <avr/io.h>
#include <util/delay.h>

void sleep_ms(uint8_t);

int main(void) {
	DDRB  |= (1<<PB0) | (1<<PB1);
	
	TCCR0A = (1<<WGM01)|(1<<WGM00)|(1<<COM0A1)|(0<<COM0A0);
	TCCR0B = (1<<CS00);
	
	OCR0A  = 128;		// 50% duty cycle
	
	while(1)	{
		PORTB ^= (1 << PB1);
		sleep_ms(250);
	}
	
	return 0;
}

void sleep_ms(uint8_t ms)	{
    while (ms--) _delay_ms(1);
}