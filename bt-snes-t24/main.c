// device
// attiny24

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

/*			 -°------V---------
	VCC		-|1 VCC		GND 14|-	GND
	X1		-|2 X1		PA0 13|-	DAT
	X2		-|3 X2		PA1 12|-	LAT
	RST		-|4 #RST	PA2 11|-	CLK
	MUL		-|5 PB2		PA3 10|-	LED
	TX		-|6 PA7		PA4  9|-	SCK
	RX/MO	-|7 PA6		PA5  8|-	MI
			 ------------------					*/

// uart
#define UART_TX			(1<<7)
#define UART_RX			(1<<6)
#define UART_TX_PORT	PORTA
#define UART_TX_DDR		DDRA
#define UART_TX_PIN		PINA

// ctrl port
#define CTRL_DAT	(1<<0)
#define CTRL_LAT	(1<<1)
#define CTRL_CLK	(1<<2)
#define CTRL_PORT	PORTA
#define CTRL_DDR	DDRA
#define CTRL_PIN	PINA

// led port
#define LED_PIN		(1<<3)
#define LED_PORT	PORTA
#define LED_DDR		DDRA

// multi port
#define MUL_DIR		(1<<2)
#define MUL_PORT	PORTB
#define MUL_DDR		DDRB
#define MUL_PIN		PINA

// transmission defines
#define	START_FLAG	18
#define	ACK			19

// global vars
volatile uint16_t outframe;
const char button_let[] PROGMEM = "JU21WSADKILR";	// letters to send
							//     qwertzuiopas		alternatives
							//	   dfghjklyxcvb
							//	   QWERTZUIOPAS
							//	   DFGHJKLYXCVB
							//	   1234567890nm

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
static void init_wdt(uint8_t time_out);
static void init_ports(void);
static void init_uart(void);
static uint16_t check_12_buttons(void);

int main(void)
{
	OSCCAL = 201;
	/*	 OSCCAL	|	F_CPU (MHz)
		-----------------------
		 201	|	11.52
		 31		|	 5.76		*/

	init_uart();
	init_ports();
	init_wdt(WDTO_15MS);

	uint16_t read_btns_old = 0xFFFF;
	uint16_t read_btns;

	while(1)
	{
		read_btns = check_12_buttons();	// get button status	0b111111111111;	//0b101100101111; //

		if(read_btns)
		{
			uart_tx(START_FLAG);				// start transmission
			uart_tx_buttons(read_btns);			// send buttons
			uart_tx(ACK);						// terminate transmission
		}

		if(!read_btns && read_btns_old)			// clear key presses
		{
			uart_tx(START_FLAG);				// start transmission
			uart_tx(ACK);						// terminate transmission
		}

		read_btns_old = read_btns;

		sleep(SLEEP_MODE_PWR_SAVE);
		/*  mode:			|	datasheet name	|	consumption @ 5V	|	consumption @ 3.3V
		---------------------------------------------------------------------------------------
		SLEEP_MODE_PWR_DOWN	|	Power-Down		|	~1-3 mA (~0.6 mA)	|	~1-2 mA (~0.4 mA)
		SLEEP_MODE_PWR_SAVE	|	Standby			|	~1-3 mA (~0.6 mA)	|	~1-2 mA (~0.4 mA)
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

	uint8_t ddrb = DDRB;	// backup actual DDRB
	uint8_t ddra = DDRA;	// and DDRA as well
	DDRB = 0;				// set all to input, saves power
	DDRA = LED_PIN;			// but leave LED on

	set_sleep_mode(mode);	// set sleep mode
	sleep_enable();			// enable sleep mode
	sei();					// enable global interrupts to wake up
	sleep_cpu();			// halt cpu
	// --------------------	// we wake up here again (wdt ISR)
	sleep_disable();		// disable sleep

	DDRB = ddrb;			// restore DDRB
	DDRA = ddra;			// and DDRA
}

void init_wdt(uint8_t time_out)
{
	wdt_enable(time_out);	// set wdt timeout to time_out (15ms)
	WDTCSR |= (1<<WDIE);	// interrupt instead of reset
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

	LED_DDR   |=  LED_PIN;					// set LED pin to output
	LED_PORT  |=  LED_PIN;					// turn it on
}

void init_uart(void)
{
	uint8_t sreg = SREG;

	cli();

	OCR0A   = VAL_OSC;			// preset 1st overflow val

	//TCCR0A = (1<<WGM01);		// CTC, overflow int. at OCRA
	TCCR0B  = (1<<CS00);		// normal mode instead of CTC

	TIMSK0 &= ~(1<<OCIE0A);		// turn compare match interrupt off
	TIFR0   =  (1<<OCF0A);		// set compare match flag (to be on the safe side)

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

	TIMSK0 |= (1<<OCIE0A);	// turn interrupt on for sending
	TIFR0   = (1<<OCF0A);	// as well as interrupt flag

	sei();	// enable global interrupts that
			// the transmission gets triggered
}

ISR(WDT_vect)			// wake up again
{
	WDTCSR |= (1<<WDIE);	// re-set interrupt bit
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

	if(1 == data)   TIMSK0 &= ~(1<<OCIE0A);		// if we're done with transmission
												// disable compm. interrput

	outframe = data >> 1;	// shift data and write it back to outframe
	SREG = sreg;
}
