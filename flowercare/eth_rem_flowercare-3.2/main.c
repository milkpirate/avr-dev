/*********************************************
 * vim:sw=8:ts=8:si:et
 * To use the above modeline in vim you add "set modeline" in your .vimrc
 * Author: Guido Socher
 * Copyright: GPL V2
 * See http://www.gnu.org/licenses/gpl.html
 *
 * Ethernet flower care
 * 
 * See http://tuxgraphics.org/electronics/
 *
 * Chip type           : Atmega328p (no atmega168) with ENC28J60
 *********************************************/
 
#define F_CPU		16000000			// 16MHz

#include <avr/io.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>

volatile uint16_t	secNow	= 0;	// variable to count seconds

/*
// eeprom layout
#define	E_LVL_DRY	0
#define	E_LVL_WET	(E_LVL_DRY + 1)
#define E_DUR_BTN	(E_LVL_WET + 1)
#define	E_DUR_PER	(E_DUR_BTN + 1)

// we water at gPeriodicSec==0 and then we initialize gPeriodicMin again with 24H=43200s
static int16_t periodicSec		= 0;	// secs (down) counter for periodic watering
*/

void init_tone(void)
{
	// set up timer for external tone
	
	DDRD |=		(1<<PD5);				// enable PD5 as output
	TCCR0A |= 	(1<<COM0B0);			// connect OC0B to PD5 and toggle it on compare match
	
	// 16MHz / 64presc = 250000Hz
	// 250000Hz / (INTERVAL+1) = 8064.51Hz
	// 8064.51Hz / 2 = 4032.25Hz
	TCCR0B |=	(1<<CS00) | (1<<CS01);	// set presc. to 64 and enable counter
	TIMSK0 =	(1<<OCIE0B);			// enable comp.match.int

	# define INTERVAL_TONE	30		
	OCR0B =		INTERVAL_TONE;			// preset overflow target
}

ISR(TIMER0_COMPB_vect)
{
	OCR0B += INTERVAL_TONE;				// set next overflow taget
}

void init_sec(void)
{
	// set up time base (1sec)
	
	TCCR1B |=	(1<<CS12);		// set presc. to 256 and enable counter
	TIMSK1 |=	(1<<OCIE1A);	// enable comp.match.int
	
	# define INTERVAL_SEC	0xF423
	OCR1A	=	INTERVAL_SEC;	// preset overflow target (= 62499)
	cli();						// turn interrupts off
}

ISR(TIMER1_COMPA_vect)
{
	OCR1A	+=	INTERVAL_SEC;	// set next overflow taget
	secNow++;
}

uint8_t read8_adc_channel(uint8_t channel) 
{
	// make conversions in free running mode
	ADMUX =		(1<<REFS0)|(channel & 0x0F);				// set channel, Vref = AVcc = 5V
    ADCSRA =	(1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);	// enable ADC, presc. = 128
	
	if (channel < 6)	DIDR0 = (1<<channel);				// switch off digital input line (6,7 have no digital input)
	ADCSRA |=	(1<<ADSC);									// start conversion 
	while(ADCSRA & (1<<ADSC));								// wait for results
	
	DIDR0 =		0;											// restore digital pin function
	return		ADC >> 2;									// return most significant 8 bits
}

#define LEDOFF()	PORTB|=(1<<PB1)		// set output to VCC, red LED off
#define LEDON()		PORTB&=~(1<<PB1)	// set output to GND, red LED on
#define LEDTGL()	PORTB^=(1<<PB1)		// toggle led pin
#define LEDISOFF()	PORTB&(1<<PB1)		// to test the state of the LED

#define RELAYOFF()	PORTD&=~(1<<PD7)	// turn relay off
#define RELAYON()	PORTD|=(1<<PD7)		// tunr relay on

volatile uint8_t	flags 	= 0;	// flag byte

#define	PERIODIC_WATER_ON			(1<<0)		// periodic watering on/off
#define	PERIODIC_WATER_UNLESS_WET	(1<<1)		// water unless it is wet
#define WATER_IS_ON					(1<<2)		// tells if water is running
#define BLINK						(1<<3)		// tells if water is running

#define SETFLAG(x)	(flags |= (x))		// set flag
#define CLRFLAG(x)	(flags &= ~(x))		// clear flag
#define GETFLAG(x)	(flags & (x))		// get flag

int main(void)
{
	init_tone();		// generate tone
	init_sec();			// generate secs
	sei();				// enable interrupts
	
	DDRB  |=	(1<<PB1);		// enable LED output
	LEDOFF();					// turn it off
	
	DDRB  &=	~(1<<PINB0);	// PB0 manual watering button
	PORTB |= 	(1<<PINB0);		// internal pullup resistor on
	
	DDRD  |=	(1<<DDD7);		// the transistor on PD7 (relay)
	PORTD &=	~(1<<PD7);		// transistor off
	
	// default levels for dry and wet
	static uint8_t levelDry		= 80;	// at which value it is dry, led will start to blink
	static uint8_t levelWet		= 115;	// at which value it is wet, between wet and dry is normal
	static uint8_t curHumidat	= 0;	// current humidity

	// timing secs
	uint8_t durationButton		= 6;	// how long to water when the manual button is pressed
	uint8_t durationWater		= 30;	// how long to water during periodic watering
	uint8_t relayTimeout		= 60;	// we dont want to flood the room
	uint8_t humCheckInterval	= 5;	// check every 5mins
	
	uint16_t checkStart			= 0;
	uint16_t waterStart			= 0;
	uint16_t blinkStart			= 0;
	uint16_t relayStart			= 0;
	
	while(1)
	{
		// new checking interval
		if ( ( secNow - checkStart > humCheckInterval ) || secNow == 0 )
		{
			curHumidat = read8_adc_channel(0);	// get humidity
			
			if (curHumidat < levelDry)			// are we dry?
			{
				SETFLAG(WATER_IS_ON);			// set watering flag
				waterStart = secNow;			// set start time for watering
			}
			else if ( (curHumidat >= levelDry) && (curHumidat < levelWet) )	// between both levels, we warn
			{
				SETFLAG(BLINK); 				// turn blinking on
			}
			else if (curHumidat > levelWet)		// everythings wet?
			{
				CLRFLAG(WATER_IS_ON);	// turn water off (flag)
				CLRFLAG(BLINK);			// turn blinking off (flag)
				RELAYOFF();				// turn relay off
				LEDOFF();				// turn led off
			}
			
			checkStart = secNow;		// reset timing
		}
		
		// blinking
		if ( GETFLAG(BLINK) && (secNow != blinkStart) )	// we blink each sec
		{
			LEDTGL();
			blinkStart = secNow;
		}
		
		// do we (still) have to water? 
		if (GETFLAG(WATER_IS_ON))
		{
			if (secNow - waterStart < durationWater)
			{
				RELAYON();				// turn relay off
				SETFLAG(WATER_IS_ON);	// clear water is on flag
			}
			else if (secNow - waterStart > durationWater)
			{
				RELAYOFF();				// turn relay off
				CLRFLAG(WATER_IS_ON);	// clear water is on flag
			}
			else if (secNow - relayStart > relayTimeout)
			{
				RELAYOFF();				// turn relay off
				CLRFLAG(WATER_IS_ON);	// clear water is on flag
			}
		}
		
	}
	return (0);
}
