/*
 */

#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>

/*		 -°---------------
	BUZ	-|1 PB0		PB3 8|-	#RST
	GND	-|2 GND		VCC 7|-	3V
		-|3 PB1		PB2 6|-	LED
		 -----------------				*/

#define F_CPU	8000000

#define	BUZ	(1<<0)
#define LED	(1<<1)

#define TIMEOUT 	30U
#define BUZ_INTV	8000UL

#define timer_on()	(TCCR0B	|=	(1<<CS00))
#define timer_off()	(TCCR0B	&=	~(1<<CS00))

volatile uint8_t actl_dly_secs = 0;

// function declarations
void wdt_off(void);
void init_timer_ovf(void);
void init_sleep(void);
void init_port(void);
void sleep(void);

int main(void)
{
	init_port();
	init_sleep();
	init_timer();

	while(1)
	{
		if(actl_dly_secs < TIMEOUT)
		{
			sleep();
			actl_dly_secs++;	// count up delay timer 1s/sleep
		}
		else if(actl_dly_secs == TIMEOUT)
		{
			timer_on();			// turns buzzer and blinking on
			wdt_off();			// and wdt off (needed for sleep)
		}
	}
}

void wdt_off(void)
{
	cli();
	wdt_reset();

	RSTFLR	&=	~(1<<WDRF);
	CCP		 =	0xD8;
	WDTCSR	 =	(0<<WDE);

	sei();
}

void init_timer_ovf(void)
{
	OCR0A	 =	BUZ_INTV;
	TIMSK0	|=	(1<<OCIE0A);	// enable comp match intr.
	//TCCR0B	|=	(1<<CS00);	// keep timer off till timeout
}

void init_sleep(void)
{
	// init sleep
	wdt_enable(WDTO_1S);					// set wdt timeout to time_out (2s)
	WDTCSR |= (1<<WDIE);					// interrupt instead of reset
	set_sleep_mode(SLEEP_MODE_PWR_DOWN);	// set sleep mode
	sei();									// enable global interrupts
}

void init_port(void)
{
	// init ports
	DDRB	|= BUZ | LED;	// BUZ,LED to output
}

void sleep(void)
{
	uint8_t ddrb = DDRB;					// backup actual DRRB
	DDRB = 0;								// set all to input, saves power

	sleep_enable();							// enable sleep mode
	sei();									// enable global interrupts to wake up
	sleep_cpu();							// halt cpu
	// -----------------------------------	// we wake up here again (wdt ISR)
	sleep_disable();						// disable sleep

	DDRB = ddrb;							// restore DDRB
}

ISR(TIM0_COMPA_vect)	// noise = 1000Hz
{
	// buz = 1000Hz
	OCR0A	+=	BUZ_INTV;
	PORTB	^=	BUZ;

	// led = 4Hz
	static uint8_t led_intv = 0;
	led_intv = (led_intv + 1) % 251;
	if(led_intv == 250)	PORTB ^= LED;	// toggle led
}

ISR(WDT_vect)
{
	WDTCSR |= (1<<WDIE);	// re-set WDIE bit that we dont
							// reset MCU next overflow
}
