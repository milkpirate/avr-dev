/* vim: set sw=8 ts=8 si : */
/*********************************************
* Author: Guido Socher
* Copyright: GPL V2
**********************************************/
#include <avr/io.h>
#include "timeout.h"


// initialize the capacitor on the aref pin:
void adc_ref_pin_init(void) 
{
	// AVcc ref
	ADMUX=(1<<REFS0);
        ADCSRA=(1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
}

// return analog value of a given channel. Works without interrupt 
uint8_t convertanalog8(unsigned char channel) 
{
	unsigned char adlow,adhigh;
	uint8_t result;
        /* enable analog to digital conversion in single run mode
        *  without noise canceler function. See datasheet of atmega88 page 250
        * We set ADPS2=1 ADPS0=1 ADPS1=1 to have a clock division factor of 128.
        * This is needed to stay in the recommended range of 50-200kHz 
	* Clock freq=8 or 12MHz
        * ADEN: Analog Digital Converter Enable
        * ADIE: ADC Interrupt Enable  (0=no interrupt)
        * ADIF: ADC Interrupt Flag
        * ADCSR: ADC Control and Status Register
        * ADPS2..ADPS0: ADC Prescaler Select Bits
	* REFS: Reference Selection Bits (page 203)
        */

	// int-ref with external capacitor at AREF pin: 
	// 1.10V int ref=REFS1=1,REFS0=1
	// write only the lower 3 bit for channel selection
	//
	// AVcc ref
	ADMUX=(1<<REFS0)|(channel & 0x0f);
	// or internal:
	// For the use the intenal 1.1V ref:
	//ADMUX=(1<<REFS1)|(1<<REFS0)|(channel & 0x0f);
	// 
        ADCSRA=(1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
	// switch off digital input line:
	if (channel <6){// 6 and 7 have no digital input
		DIDR0=(1<<channel)& 0x1f;
	}

	//  start conversion 
	ADCSRA|= (1<<ADSC);
	while(bit_is_set(ADCSRA,ADSC)); // wait for result 
	adlow=ADCL; // read low first
	adhigh=ADCH; 
	// use only 8 bit resolution:
	result=(adhigh<<6)|(adlow >>2);
	return(result);
}

