// device
// attiny25

// basic defines
#define F_CPU		11520000UL
#define BAUD		(F_CPU / 100)
#define VAL_OSC		((F_CPU + BAUD/2) / BAUD)	//round to closest int

// includes
#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/sleep.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
//#include <util/delay.h>

// further defines
#define nop()		__asm volatile ("nop")

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

// ctrl port
#define CTRL_DAT		(1<<1)
#define CTRL_LAT		(1<<0)
#define CTRL_CLK		(1<<2)
#define CTRL_PORT		UART_TX_PORT
#define CTRL_DDR		UART_TX_DDR
#define CTRL_PIN		UART_TX_PIN

// transmission defines
#define	START_FLAG		18
#define	ACK				19

// global vars
volatile uint16_t outframe;
const char button_let[] PROGMEM = "QETZOPFGHYXC";	//	alternativ 1
							//	   VBNM34567890			alternativ 2
							//     JU21WSADKILR			original
							//	  |RLXArlduSsYB|
							//	  |0123456789ab| = 12

// 	DIR: r=right, l=left, u=up, d=down
//	S=start, s=select, R=right shoulder...

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
	OSCCAL = 189;		// 11.52 MHz calibration

	init_uart();
	init_ports();
	init_sleep();

	uint16_t read_btns_old = 0xFFFF;
	uint16_t read_btns;

	while(1)
	{
		read_btns = check_12_buttons();	// get button status	0b111111111111;	//0b101100101111; //

		if(read_btns)
		{
			uart_tx(START_FLAG);		// start transmission
			uart_tx_buttons(read_btns);	// send buttons
			uart_tx(ACK);				// terminate transmission
		}

		if(!read_btns && read_btns_old)			// clear key presses
		{
			uart_tx(START_FLAG);				// start transmission
			uart_tx(ACK);						// terminate transmission
		}

		read_btns_old = read_btns;

		sleep(SLEEP_MODE_PWR_DOWN);
		/*  mode:			|	datasheet name	|	consumption @ 5V	|	consumption @ 3.3V
		---------------------------------------------------------------------------------------
		SLEEP_MODE_PWR_DOWN	|	Power-Down		|	~1-3 mA (~0.6 mA)	|	~1-2 mA (~0.4 mA)
		SLEEP_MODE_ADC		|	ADC low noise	|	~5-7 mA (~3.5 mA)	|	~2-3 mA (~1.3 mA)
		SLEEP_MODE_IDLE		|	Idle			|	~6-7 mA (~4.4 mA)	|	~3-4 mA (~2.0 mA)		*/
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
	CTRL_PORT |=  CTRL_LAT;	// high
	CTRL_PORT &= ~CTRL_LAT;	// low

	uint8_t i = 11;
	do{
		read_buttons <<= 1;

		// inverse logic
		if (!(CTRL_PIN & CTRL_DAT)) read_buttons |= 1;

		// clock line
		CTRL_PORT &= ~CTRL_CLK;	// low
		CTRL_PORT |=  CTRL_CLK;	// high
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
	WDTCR |= (1<<WDIE);		// interrupt instead of reset
	sei();					// enable global interrupts
}

void init_ports(void)
{
	// ctrl
	CTRL_DDR  |=  CTRL_CLK | CTRL_LAT;		// set CLK, LAT output
	CTRL_PORT |=  CTRL_CLK;					// set CLK high
	CTRL_PORT &= ~CTRL_LAT;					// set LAT low

	CTRL_DDR  &= ~CTRL_DAT;					// set DAT input
	CTRL_PORT |=  CTRL_DAT;					// set pullups for DAT
}

void init_uart(void)
{
	uint8_t sreg = SREG;

	cli();

	OCR0A  = VAL_OSC;			// preset 1st overflow val

	//TCCR0A = (1<<WGM01);		// normal mode instead of CTC
	TCCR0B = (1<<CS00);

	TIMSK &= ~(1<<OCIE0A);		// turn compare match interrupt off
	TIFR   =  (1<<OCF0A);		// set compare match flag (to be on the safe side)

	UART_TX_PORT |= UART_TX;	// turn pullup on
	UART_TX_DDR  |= UART_TX;	// set as output

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

	TIMSK |= (1<<OCIE0A);	// turn interrupt on for sending
	TIFR   = (1<<OCF0A);	// as well as interrupt flag

	sei();	// enable global interrupts that
			// the transmission gets triggered
}

ISR(WDT_vect)			// wake up again
{
	WDTCR |= (1<<WDIE);	// re-set interrupt bit
						// otherwise we would reset
						// the mcu next overflow
}

ISR(TIM0_COMPA_vect)	// uart interrupt
{
	uint8_t	 sreg	= SREG;
	uint16_t data	= outframe;	// copy outframe

	OCR0A		   += VAL_OSC;	// set next overflow target

	if(data & 1)	UART_TX_PORT |=  UART_TX;	// write bit to port
	else			UART_TX_PORT &= ~UART_TX;

	if(1 == data)   TIMSK &= ~(1<<OCIE0A);		// if we're done with transmission
												// disable compm. interrput

	outframe = data >> 1;	// shift data and write it back to outframe
	SREG = sreg;
}
