/*
 */

#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    // Insert code
    DDRB |= (1<<PB0);
    PORTB |= (1<<PB0);

    while(1)
    {
    	PORTB ^= (1<<PB0);
	}
    return 0;
}
