/*
 * attiny10_blink.c
 *
 * Created: 27.09.2013 23:56:30
 *  Author: Lenny
 */

/*
var/reg &= ~(1 << bit)      // clear bit in var/reg
var/reg |=  (1 << bit)      // set bit in var/reg
var/reg ^=  (1 << bit)      // toggle bit in var/reg
bit = var/reg & (1 << bit); // check bin in var/reg
*/

#define F_CPU 8000000UL

#include <avr/io.h>
#include <util/delay.h>

void delay_1ms(uint16_t);

int main(void)
{
	DDRB	= 0xFF;
	OSCCAL	= 150;			// calibrate to 1MHz

    while(1)
    {
        PORTB	^=	0xFF;
		_delay_ms(250);
    }
}
