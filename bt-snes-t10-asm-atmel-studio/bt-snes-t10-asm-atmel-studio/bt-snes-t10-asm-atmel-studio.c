/*
 * bt_snes_t10_asm_atmel_studio.c
 *
 * Created: 24.03.2015 00:37:18
 *  Author: Lenny
 */ 

#define F_CPU		9600000UL
#define BAUD		115200
#define VAL_OCR		((F_CPU + BAUD/2) / BAUD)	//round to closest int

// includes
#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/sleep.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

// further defines
#define nop()		__asm volatile ("nop")

/*	  _____________
	 /1 °         6|
 O--|PB0        PB3|--O RESET
	|      t10     |
 O--|GND        VCC|--O
	|              |
 O--|PB1        PB2|--O
	|______________|
*/

// pin defines
#define UART_TX			(1<<1)
#define CTRL_DAT		(1<<1)

#define CTRL_LAT		(1<<0)
#define CTRL_CLK		(1<<2)

// transmission defines
#define	START_FLAG		18
#define	ACK				19

// global vars
volatile uint16_t outframe;
const char button_let[] PROGMEM = "VBNM34567890";	//	alternativ 2
							//	   QETZOPFGHYXC			alternativ 1
							//     JU21WSADKILR			original

// flags
volatile uint8_t flags = 0;
#define			 SENT	(1<<0)

// function definitions
static void uart_tx(char c);
static void uart_tx_buttons(uint16_t read_buttons);
static void sleep(uint8_t mode);
static void init_sleep();
static void init_ports(void);
static void init_uart(void);
static uint16_t check_12_buttons(void);

int main(void)
{
	OSCCAL = 150;		// rc oscilator callibration
	
	init_uart();
	init_ports();
	init_sleep();
	
    while(1)
    {
		uint16_t read_btns = check_12_buttons();	// get button status	0b111111111111;	//0b101100101111; //

		if(read_btns)
		{
			uart_tx(START_FLAG);		// start transmission
			uart_tx_buttons(read_btns);	// send buttons
			uart_tx(ACK);				// terminate transmission
		}

		sleep(SLEEP_MODE_PWR_DOWN);
	}
}

void uart_tx_buttons(uint16_t read_buttons)
{
	uint8_t i = 11;
	do
	{
		if(read_buttons & 1)
		{
			if(flags & SENT)	uart_tx(',');
			else				flags |= SENT;

			uart_tx(pgm_read_byte(&button_let[i]));
		}
		read_buttons >>= 1;
	} while (i--);

	flags &= ~SENT;
}

uint16_t check_12_buttons(void)
{
	uint16_t read_buttons = 0;

	// latch in
	PORTB |=  CTRL_LAT;	// high
	PORTB &= ~CTRL_LAT;	// low

	uint8_t i = 11;
	do{
		read_buttons <<= 1;

		// inverse logic
		if (!(PINB & CTRL_DAT)) read_buttons |= 1;

		// clock line
		PORTB &= ~CTRL_CLK;	// low
		PORTB |=  CTRL_CLK;	// high
	} while (i--);

	return read_buttons;
}


void sleep(uint8_t mode)
{
	while(outframe);		// wait for transmission

	uint8_t ddrb = DDRB;	// backup actual DRRB
	DDRB = 0;				// set all to input, saves power

	set_sleep_mode(mode);	// set sleep mode
	sleep_enable();			// enable sleep mode
	sei();					// enable global interrupts to wake up
	sleep_cpu();			// halt cpu
	// --------------------	// we wake up here again (wdt ISR)
	sleep_disable();		// disable sleep

	DDRB = ddrb;			// restore DDRB
}

void init_sleep(void)
{
	wdt_enable(WDTO_15MS);	// set wdt timeout to time_out (15ms)
	WDTCSR |= (1<<WDIE);	// interrupt instead of reset
	sei();					// enable global interrupts
}

void init_ports(void)
{
	// ctrl
	DDRB  |=  CTRL_CLK | CTRL_LAT;		// set CLK, LAT output
	PORTB |=  CTRL_CLK;					// set CLK high
	PORTB &= ~CTRL_LAT;					// set LAT low

	DDRB  &= ~CTRL_DAT;					// set DAT input
	PORTB |=  CTRL_DAT;					// set pullups for DAT
}

void init_uart(void)
{
	uint8_t sreg = SREG;

	cli();

	OCR0A  = VAL_OCR;			// preset 1st overflow val

	TCCR0B  = (1<<CS00);
	TIMSK0 &= ~(1<<OCIE0A);		// turn compare match interrupt off
	TIFR0   =  (1<<OCF0A);		// set compare match flag (to be on the safe side)

	PORTB |= UART_TX;			// turn pullup on
	DDRB  |= UART_TX;			// set as output

	outframe = 0;
	SREG = sreg;
}

void uart_tx(char c)
{
	do	// wait until last outframe is sent
	{
		sei();
		nop();
		cli();
	}
	while (outframe);

	// frame = [*P76543210S]  S=start=0, P=stop=1, *=endmark=1
	outframe = (3<<9) | (c<<1);

	TIMSK0 |= (1<<OCIE0A);	// turn interrupt on for sending
	TIFR0   = (1<<OCF0A);	// as well as interrupt flag

	sei();	// enable global interrupts that
			// the transmission gets triggered
}

ISR(WDT_vect)				// wake up again
{
	WDTCSR |= (1<<WDIE);	// re-set interrupt bit
							// otherwise we would reset
							// the mcu next overflow
}

ISR(TIM0_COMPA_vect)	// uart interrupt
{
	uint8_t	 sreg	= SREG;
	uint16_t data	= outframe;					// copy outframe

	OCR0A		   += VAL_OCR;					// set next overflow target

	if(data & 1)	PORTB |=  UART_TX;			// write bit to port
	else			PORTB &= ~UART_TX;

	if(1 == data)   TIMSK0 &= ~(1<<OCIE0A);		// if we're done with transmission
												// disable compm. interrput

	outframe = data >> 1;						// shift data and write it back to outframe
	SREG = sreg;
}