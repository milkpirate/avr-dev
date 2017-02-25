/*
 *
 */

// attiny25
#define F_CPU	11060000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#include "USI_UART_config.h"

int main( void )
{
    while(1)                                                                // Run forever
    {
		usi_uart_tx_str_P(PSTR("\n\rHello you there!"));
		_delay_ms(250);
    }
 	return 0;
}

