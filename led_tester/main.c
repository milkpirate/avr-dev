/*
 */

// device = attiny84

// basic defines
#define F_CPU	8000000UL

// avr specific
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#include <lcd_routines.h>

// other includes
#include <stdio.h>
#include <stdfix.h>

// other defines
#define CH_HIGH		7
#define CH_LOW		6
#define CH_VLT		1

#define V_REF		1100			// [V]
#define V_MAX_SET	150				// [mV/10]
#define V_MAX_HIGH	(V_REF*(1+3))	// [V] = Vref*(R1+R2) (ratio sum)
#define V_MAX_LOW	V_REF			// [V] = Vref
#define R_SENSE		10				// [Ohm]

#define AVG_NUM		16				// power of 2 would do best
#define MSR_DLY		1				// [ms]

#define LCD_CC_R	1
#define LCD_CC_KR	2
#define LCD_CC__f	3
#define LCD_CC__t	4
#define LCD_CC__d	5
#define LCD_CC__L	6

// global variables
char buffer[6];
const uint8_t PROGMEM symbol_R[8]  = {0x00, 0x0E, 0x11, 0x11, 0x11, 0x0A, 0x1B, 0x00};
const uint8_t PROGMEM symbol_KR[8] = {0x14, 0x18, 0x14, 0x06, 0x09, 0x09, 0x06, 0x0F};
const uint8_t PROGMEM symbol__f[8] = {0x00, 0x00, 0x04, 0x0A, 0x08, 0x08, 0x1E, 0x08};
const uint8_t PROGMEM symbol__t[8] = {0x00, 0x00, 0x08, 0x08, 0x1C, 0x08, 0x08, 0x06};
const uint8_t PROGMEM symbol__d[8] = {0x00, 0x00, 0x02, 0x02, 0x0E, 0x12, 0x12, 0x0D};


#define	KILO	(1<<0)
#define	REFRESH	(1<<1)
#define	VALUES	(1<<2)
uint8_t flags = REFRESH;

// function definitions
void port_init(void);
void adc_init(void);
uint16_t get_vt(void);
uint16_t get_mA(void);
uint16_t get_vf(void);
uint16_t adc_read(uint8_t channel);

int main(void)
{
	port_init();
	lcd_init();
	adc_init();

	lcd_generatechar_P(LCD_CC_R, symbol_R);
	lcd_generatechar_P(LCD_CC_KR, symbol_KR);
	lcd_generatechar_P(LCD_CC__f, symbol__f);
	lcd_generatechar_P(LCD_CC__t, symbol__t);
	lcd_generatechar_P(LCD_CC__d, symbol__d);

	uint16_t current_d		= 0;
	uint16_t voltage_t		= 0;
	uint16_t voltage_f		= 0;
	uint16_t current_d_old	= 0;
	uint16_t voltage_f_old	= 0;
	uint16_t voltage_t_old 	= 0;

    while(1)
	{
		current_d = get_mA();	// [mA]
		voltage_f = get_vf();	// [mV]
		voltage_t = get_vt();	// [V]

		if ((current_d == 0) && (flags & REFRESH))
		{
			flags &= ~(VALUES | REFRESH);

			lcd_setcursor(0,0);
			lcd_string("   LED Tester   ");
			lcd_setcursor(0,1);
			lcd_string("(attache an LED)");
		}
		else if (current_d > 0)
		{
			if( (current_d != current_d_old) ||
				(voltage_f != voltage_f_old) ||
				(voltage_t != voltage_t_old) )
			{
				// update old-values
				current_d_old = current_d;
				voltage_f_old = voltage_f;
				voltage_t_old = voltage_t;

				// prep resistor
				uint16_t resistor_t = (voltage_t-voltage_f)/current_d;	// [mV]/[mA]=[R]
				if (resistor_t > 9999)									// 1000R = 1kR
				{
					resistor_t /= 1000;
					flags |= KILO;
				}
				else	flags &= ~KILO;

				// print out
				lcd_clear();

				// print I_d
				lcd_data('I'); lcd_data(LCD_CC__d);
				sprintf(buffer, "%2d", current_d); // +rounding
				lcd_string(buffer);

				lcd_string("mA V");
				// print V_f
				lcd_data(LCD_CC__f);
				voltage_f /= 100;
				lcd_data('0'+(voltage_f/10)); lcd_data('.'); lcd_data('0'+(voltage_f%10));

				// print V_t (floats)
				lcd_setcursor(0,1);
				lcd_data('V'); lcd_data(LCD_CC__t);
				sprintf(buffer, "%2d", voltage_t/10);
				lcd_string(buffer); lcd_data('.'); lcd_data('0'+(voltage_t%10));

				// print R_t
				lcd_string(" R"); lcd_data(LCD_CC__t);
				sprintf(buffer, "%4d", resistor_t);
				lcd_string(buffer);
				if(flags & KILO)	lcd_data(LCD_CC_KR);
				else				lcd_data(LCD_CC_R);

				// set markers
				flags |= VALUES;
				flags |= REFRESH;
			}
		}

	_delay_ms(50);
	}
    return 0;
}

uint16_t get_mA(void)
{
	uint16_t current = adc_read(CH_LOW);
	current = (current*V_REF)/(1024*R_SENSE);
	return current;
}

uint16_t get_vf(void)
{
	uint16_t v_high = adc_read(CH_HIGH);	// get high side
	v_high = (v_high*V_MAX_HIGH)/1024;			// convert to actual voltage

	uint16_t v_low = adc_read(CH_LOW);	// get low side
	v_low = (v_low*V_REF)/1024;					// convert to actual voltage
	return v_high - v_low;							// return differential
}

uint16_t get_vt(void)
{
	uint16_t voltage = adc_read(CH_VLT);	// get raw read
	voltage = (voltage*V_MAX_SET)/1024;			// convert to voltage
	return voltage;
}

void port_init(void)
{
	DDRB	|= (1<<PB2);		// lcd led output
	PORTB	|= (1<<PB2);		// turn it on
}

void adc_init(void)
{
	ADMUX	|= (1<<REFS1);		// Vref = 1.1V
	ADCSRA	|= (1<<ADEN) 		// enable ADC
			//|  (1<<ADIE)		// enable interrupt
			|  (0b110<<ADPS0);	// set prescaler, F_CPU/200kHz = 40 (round next bigger power of 2) => 64=2^6 => 6=0b110
	_delay_ms(1);				// let Vref settle
}

uint16_t adc_read(uint8_t channel)
{
	ADMUX =		(ADMUX & 0b11110000) | channel;		// set channel

	uint16_t adc = 0;
	for(uint8_t i=0; i<AVG_NUM; i++)
	{
		ADMUX |=	(1<<ADSC);						// start single conversion
		while(ADMUX & (1<ADSC)); 					// wait until conversion is done
		adc += ADC;
		_delay_ms(MSR_DLY);
	}
	adc /= AVG_NUM;
	return adc;
}
