/*
*/

// basic defines
#define F_CPU		11520000UL

// common includes

// avr specific
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <util/delay.h>

/*		 -°------V--------
		-|1 #RST	VCC 8|-
		-|2 PB3		PB2 7|-	CLK
		-|3 PB4		PB1 6|-	DAT
		-|4 GND		PB0 5|-	LAT
		 -----------------					*/

// uart
#define UART_TX			(1<<3)
#define UART_RX			(1<<4)
#define UART_TX_PORT	PORTB
#define UART_TX_DDR		DDRB
#define UART_TX_PIN		PINB
#define BAUD			(F_CPU / 100)
#define VAL_OSC			((F_CPU + BAUD/2) / BAUD)	//round to closest int

// global vars
#define outframe	(*(volatile uint16_t *)(&GPIOR1))

// function definitions
static void uart_tx_char(char c);
static void init_uart(void);
void uart_tx_str(char *str);

int main(void)
{
    OSCCAL = 189;		// 11.52 MHz calibration

    init_uart();

    while(1)
    {
        uart_tx_str("hello hello");
        _delay_ms(250);
	}
}

void uart_tx_str(char *str)
{
    while(*str) uart_tx_char(*str++);
}

void init_uart(void)
{
    uint8_t sreg = SREG;
    cli();
    OCR0A  = VAL_OSC;			// preset 1st overflow value

    TCCR0B	=  (1<<CS00);

	TIMSK  &= ~(1<<OCIE0A);		// turn compare match interrupt off
    TIFR	=  (1<<OCF0A);		// set compare match flag (to be on the safe side)

    UART_TX_PORT |= UART_TX;	// turn pullup on
    UART_TX_DDR  |= UART_TX;	// set as output

    outframe = 0;
    SREG = sreg;
}

void uart_tx_char(char c)
{
    do	// wait until last outframe is sent
    {
        sei();
        __asm volatile ("nop");
        cli();
    }
    while (outframe);

    // frame = [*P76543210S]  S=start=0, P=stop=1, *=endmark=1
    outframe = (3<<9) | (c<<1);

    TIMSK |= (1<<OCIE0A);	// turn interrupt on for sending
    TIFR   = (1<<OCF0A);	// as well as interrupt flag

    sei();	// enable global interrupts that
    		// the transmission gets triggered
}

ISR(TIM0_COMPA_vect)	// uart interrupt
{
    uint8_t	 sreg	= SREG;
    uint16_t data	= outframe;	// copy outframe

    OCR0A		   += VAL_OSC;	// set next overflow target

    if(data & 1)	UART_TX_PORT |=  UART_TX;	// write bit to port
    else			UART_TX_PORT &= ~UART_TX;

    if(data == 1)   TIMSK &= ~(1<<OCIE0A);		// if we're done with transmission
    											// disable compm. interrput

    outframe = data >> 1;		// shift data and write it back to outframe
    SREG = sreg;
}
