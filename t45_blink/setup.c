/*
 ATtiny25/45/85 Blink
 Version: 1.0
 Author: Alex from Inside Gadgets (http://www.insidegadgets.com)
 Created: 25/04/2011
 Last Modified: 28/04/2011
 
 Blink an LED on the ATtiny25/45/85 using delay_ms and then timer to show both are operational.
 Uses the setup procedure and timer function/variables from the Arduino's wiring.c file as it's easier
 to use something that works rather than starting from scratch.
  
 */
 
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

#ifndef boolean
	typedef uint8_t boolean;
#endif 
#ifndef byte
	typedef uint8_t byte;
#endif

// START Arduino wiring.c - to use the timers
#define clockCyclesPerMicrosecond() ( F_CPU / 1000000L )
#define clockCyclesToMicroseconds(a) ( (a) / clockCyclesPerMicrosecond() )

// the prescaler is set so that timer0 ticks every 64 clock cycles, and the
// the overflow handler is called every 256 ticks.
#define MICROSECONDS_PER_TIMER0_OVERFLOW (clockCyclesToMicroseconds(64 * 256))

// the whole number of milliseconds per timer0 overflow
#define MILLIS_INC (MICROSECONDS_PER_TIMER0_OVERFLOW / 1000)

// the fractional number of milliseconds per timer0 overflow. we shift right
// by three to fit these numbers into a byte. (for the clock speeds we care
// about - 8 and 16 MHz - this doesn't lose precision.)
#define FRACT_INC ((MICROSECONDS_PER_TIMER0_OVERFLOW % 1000) >> 3)
#define FRACT_MAX (1000 >> 3)

volatile unsigned long timer0_overflow_count = 0;
volatile unsigned long timer0_millis = 0;
static unsigned char timer0_fract = 0;

//different name, TIMER0_OVF_vect to this
SIGNAL(TIM0_OVF_vect)
{
	// copy these to local variables so they can be stored in registers
	// (volatile variables must be read from memory on every access)
	unsigned long m = timer0_millis;
	unsigned char f = timer0_fract;
	
	m += MILLIS_INC;
	f += FRACT_INC;
	if (f >= FRACT_MAX) {
		f -= FRACT_MAX;
		m += 1;
	}
	
	timer0_fract = f;
	timer0_millis = m;
	timer0_overflow_count++;
}

unsigned long millis(void) {
	unsigned long m;
	uint8_t oldSREG = SREG;
	
	// disable interrupts while we read timer0_millis or we might get an
	// inconsistent value (e.g. in the middle of a write to timer0_millis)
	cli();
	m = timer0_millis;
	SREG = oldSREG;
	
	return m;
}

// END Arduino wiring.c

// Used from Arduino wiring.c - to setup the ATtiny
void setup(void) {
	sei(); // Turn on interrupts
	
	/* dumpt everything, and only added the 2 timers the attiny has */
	// on the ATmega168, timer 0 is also used for fast hardware pwm
	// (using phase-correct PWM would mean that timer 0 overflowed half as often
	// resulting in different millis() behavior on the ATmega8 and ATmega168)
	sbi(TCCR0A, WGM01);
	sbi(TCCR0A, WGM00);
	// set timer 0 prescale factor to 64
	sbi(TCCR0B, CS01);
	sbi(TCCR0B, CS00);
	// enable timer 0 overflow interrupt
	sbi(TIMSK, TOIE0);

	// timers 1 are used for phase-correct hardware pwm
	// this is better for motors as it ensures an even waveform
	// note, however, that fast pwm mode can achieve a frequency of up
	// 8 MHz (with a 16 MHz clock) at 50% duty cycle
	// set timer 1 prescale factor to 64
	sbi(TCCR1, CS12); // Inside Gadgets fix
	sbi(TCCR1, CS11);
	sbi(TCCR1, CS10);
	sbi(TCCR1, PWM1A);
	
	// set a2d prescale factor to 128
	// 16 MHz / 128 = 125 KHz, inside the desired 50-200 KHz range.
	// XXX: this will not work properly for other clock speeds, and
	// this code should use F_CPU to determine the prescale factor.
	/* added F_CPU prescaler */
	#if F_CPU >= 16000000L //128
		sbi(ADCSRA, ADPS2);
		sbi(ADCSRA, ADPS1);
		sbi(ADCSRA, ADPS0);
	#elif F_CPU >= 8000000L //64
		sbi(ADCSRA, ADPS2);
		sbi(ADCSRA, ADPS1);
	#else				//8
		sbi(ADCSRA, ADPS1);
		sbi(ADCSRA, ADPS0);
	#endif
		// enable a2d conversions
		sbi(ADCSRA, ADEN);
}