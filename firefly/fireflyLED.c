/*
 *  fireflyLED      a low-power firefly that uses an LED as a dark sensor
 */

#include  <avr/io.h>
#include  <avr/interrupt.h>
#include  <avr/wdt.h>
#include  <avr/sleep.h>
#include  <util/delay.h>


#define  WDT_PRESCALE_MASK	((1<<WDP3)|(1<<WDP2)|(1<<WDP1)|(1<<WDP0))
#define  WDT_PRESCALE_SELECT	((1<<WDP2)|(1<<WDP0))

#define  LED_PORT				PORTB
#define  LED_DDR				DDRB
#define  LED_BIT				4
#define  LED_MASK				(1<<LED_BIT)

#define  NUM_DELAYS				16


volatile uint8_t			delays;


/*
 *  Local functions
 */
static  void			GoToSleep(void);
static  uint16_t		ReadLightLevel(void);
static  void			BlinkLED(void);
static  void			PulseLED_ms(int  duration);


int  main(void)
{
	uint8_t					mcuflags;
	uint16_t				v;

//
//  Record the reset flags locally, then clear all of the flags.
//
	mcuflags = MCUSR;
	MCUSR = 0;

//
//  Configure the LED port so the LED can be turned on and off.
//  Start with the LED off (output line is low).
//
	LED_PORT &= ~LED_MASK;
	LED_DDR |= LED_MASK;

	delays = 0;

//
//  Make sure the watchdog timer is disabled; we will turn it on
//  later when needed.
//
//  The first write to WDTCR protects the prescaler bits, as a
//  precaution against an inadvertant timeout.
//
//  Note that the two changes to WDTCR must complete within 4 clock
//  cycles!
//
	cli();
	wdt_disable();
	WDTCR |= (1<<WDCE) | (1<<WDE);
	WDTCR = 0x00;
	sei();


//
//  The main loop
//
//  A call to GoToSleep() puts the MCU in power-down mode.  Control
//  reaches the next statement after the watchdog interrupt restarts
//  the MCU.
//
//  The watchdog interrupt will decrement the variable delays until it
//  hits 0.  When delays equals 0, this loop will turn the LED's port
//  line into an A/D input and read the light level.  If the light
//  level is dark enough, this loop will also blink the LED.  Finally,
//  variable delays is reloaded with the correct value and the process
//  starts all over again.
//
	while (1)
	{
		GoToSleep();

		if (delays == 0)
		{
			LED_PORT &= ~LED_MASK;
			LED_DDR |= LED_MASK;
			_delay_ms(10);
			LED_DDR &= ~LED_MASK;

			v = ReadLightLevel();
			if (v < 10)
			{
				BlinkLED();
				_delay_ms(800);
				BlinkLED();
			}
			delays = NUM_DELAYS;
		}
	}
}



//
//  ReadLightLevel      measure voltage on LED, return as light level
//
//  This routine activates the A/D converter, sets up the A/D to read the
//  voltage on the LED, delays slightly to let the LED's charge bleed off,
//  then reads and returns one sample.
//
//  This routine assumes that the A/D has been powered down upon entry.
//  This routine also assumes that the LED's port line has been set up
//  as an A/D input.
//
static
uint16_t
ReadLightLevel(void)
{
	uint16_t			r;

	PRR &= ~(1<<PRADC);
	ADMUX = (1<<MUX1);
	ADCSRB = 0;
	ADCSRA = (1<<ADPS2) | (1<<ADPS1);
	ADCSRA |= (1<<ADEN) | (1<<ADIF);
	
	ADCSRA |= (1<<ADSC);
	while (ADCSRA & (1<<ADSC))  ;
	
	_delay_ms(3);
	
	ADCSRA |= (1<<ADSC);
	while (ADCSRA & (1<<ADSC))  ;
	
	// ADLAR = 0 =>
	r = ADCL;
	r = r + (ADCH << 8);
	return  r;
}




//
//  BlinkLED      set up the LED to blink, do the blink, turn off the LED
//
static
void
BlinkLED(void)
{
	LED_PORT &= ~LED_MASK;
	LED_DDR |= LED_MASK;
	PulseLED_ms(750);
	LED_PORT &= ~LED_MASK;
	LED_DDR &= ~LED_MASK;	
}



	
//
//  GoToSleep      put the MCU in power-down mode
//
static
void
GoToSleep(void)
{
//
//  Shut off the brown-out detect (BOD) so it doesn't consume power
//  during sleep.  This is a two-step, time-sensitive operation;
//  refer to the Atmel docs on the BODCR register.
//
	BODCR = (1<<BPDS) | (1<<BPDSE);
	BODCR = 0;

//
//  Start shutting off subsystems to minimize power draw.  In most
//  cases, it is enough to disable a subsystem before switching
//  to low-power modes.
//
	ADCSRA &= ~(1<<ADEN);
	ACSR &= (1<<ACD);
	DIDR0 = (1<<AIN1D) | (1<<AIN0D) | (1<<ADC0D) | (1<<ADC1D) | (1<<ADC2D) | (1<<ADC3D);

//
//  Select the timeout to use for the WDT and enable the WDT for
//  interrupt (not reset).
//
	WDTCR = (1<<WDCE) | (1<<WDE);
	WDTCR = (1<<WDCE) | (1<<WDE) | WDT_PRESCALE_SELECT;

	MCUSR = 0;

	WDTCR |= (1<<WDTIF) | (1<<WDTIE);

	wdt_reset();

	PRR = (1<<PRTIM0) | (1<<PRADC);
	set_sleep_mode(SLEEP_MODE_PWR_DOWN);
	sleep_mode();
}



//
//  PulseLED_ms      pulse the LED for a selected duration at fixed duty cycle
//
//  This routine uses a series of spin-loops for timing, based on the standard
//  AVR _delay_ms() function.  Note that the _delay_ms() function handles the
//  case of a zero argument by delaying 1 msec.
//
//  Note that the use of variables as arguments to _delay_ms() can cause issues.
//  If the compiler cannot optimize out the variable usage and really has to
//  load a variable to pass into _delay_ms(), the linker will drag in an extra
//  4K of code, which obviously isn't going to work on a 'tiny13a.  The variable
//  usage you see below is optimized out; anything more complex, or using a
//  volatile, will cause the linker bloat.
//
//  Upon entry, duration holds the period, in msecs, to blink the LED.
//
//  Upon exit, the LED is off.
//
static
void
PulseLED_ms(
	int			duration
)
{
	int				t;

	while (duration > 0)
	{
		LED_PORT |= LED_MASK;
		t = 2;
		_delay_ms(t);
		duration = duration - t;

		LED_PORT &= ~LED_MASK;
		t = 20;
		_delay_ms(t);
		duration = duration - t;
	}
}




//
//  Watchdog timeout ISR
//
ISR
(WDT_vect)
{
	wdt_disable();
	WDTCR |= (1<<WDCE) | (1<<WDE);
	WDTCR = 0x00;

	if (delays)  delays--;
}



