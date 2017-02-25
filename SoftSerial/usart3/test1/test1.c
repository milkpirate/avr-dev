/*------------------------------------------------*/
/* TEST1 : A test program for software UART       */
/*------------------------------------------------*/
/* Communicating via ISP cable                    */


#include <avr/io.h>
#include <avr/pgmspace.h>
#include <inttypes.h>
#include "suart.h"

#define	SYSCLK		8000000UL



int main (void)
{
	static const prog_char mess1[] = "test1.c software uart sample program\r\n";
	const prog_char *s;
	char c;

	/* Initialize I/O ports */
	PORTB = 0b10111111;	/* PB6:Inv-Tx, PB5:Inv-Rx */
	DDRB  = 0b01000000;
	PORTD = 0b01111111;	/* Pull-up Port D */


	/* Send message */
	s = mess1;
	for (;;) {
		c = pgm_read_byte(s++);
		if (!c) break;
		xmit(c);
	}

	/* Receives data and echos it in incremented data */
	for(;;) {
		c = rcvr();
		c++;
		xmit(c);
	}

}

