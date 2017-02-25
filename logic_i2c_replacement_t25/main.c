/*
 */
#define F_CPU				8000000UL

// attiny25
/*
		 -°------V--------
		~|1 #RST	VCC 8|- VCC
	Pot ~|2 PB3		PB2 7|~	SCL
	LED ~|3 PB4		PB1 6|/
		-|4 GND		PB0 5|-	SDA
		 -----------------
*/

// avr specific includes
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "usi_slave_eeprom.h"

// global variables
const uint8_t PROGMEM rom_data[] = {			//			addr
	0xC0,0x25,0x09,0x81,0x38,0x1B,0x00,0x00,	// saleae	0x00-0x07
	0xC0,0xA9,0x08,0x14,0x00,0x00,0x1B,0x00,	// org		0x00-0x07
	0xC0,0xA9,0x08,0x05,0x00,0x84,0x23,0x00,	// ZX		0x00-0x07
//====================================================================
	0x34,0x4C,0x92,0x47,0x26,0x33,0xAF,0xB1,	//			0x08-0x0F
	0x00,0x00,0x14,0x00,0x00,0x00,0x14,0x00,	//			0x60-0x67
	0x00,0x00,0x00,0x80,0x00,0x00,0x00,0x80,	//			0x68-0x6F
	0xFF	// rest of rom is = 0xFF
};

/*
	I²C Address: 0x50 ([1010|000_] _ = R/#W)

	Memory map:
	ROM: 0x_0 0x_1 0x_2 0x_3 0x_4 0x_5 0x_6 0x_7 0x_8 0x_9 0x_A 0x_B 0x_C 0x_D 0x_E 0x_F
	=====================================================================================
	0x0_ 0xC0 0x25 0x09 0x81 0x38 0x1B 0x00 0x00 0x34 0x4C 0x92 0x47 0x26 0x33 0xAF 0xB1
	0x1_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0x2_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0x3_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0x4_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0x5_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0x6_ 0x00 0x00 0x14 0x00 0x00 0x00 0x14 0x00 0x00 0x00 0x00 0x80 0x00 0x00 0x00 0x80
	0x7_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0x8_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0x9_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0xA_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0xB_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0xC_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0xD_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0xE_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	0xF_ ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----*

	* ---- = 0xFF
*/

uint8_t id_select = 0;

// function definitions
uint8_t get_rom_data(uint8_t addr);
static uint8_t adc_read_id(void);
static void init_adc(void);

int main(void)
{
	usi_twi_slave_init();
	init_adc();


    while(1) id_select = adc_read_id();
    return 0;
}

static void init_adc(void)
{
	ADMUX	|= (1<<ADLAR) | (0b0011<<MUX0);	// Vref=Vcc, left adjust, set channel 3
	ADCSRA	|= (1<<ADEN) 					// enable ADC
			|  (0b110<<ADPS0);				// set prescaler, F_CPU/200kHz = 40
											// (round next bigger power of 2) =>
											// 64=2^6 => 6=0b110
}

static uint8_t adc_read_id(void)
{
	ADCSRA |=	(1<<ADSC);		// start single conversion
	while(ADCSRA & (1<ADSC)); 	// wait until conversion is done
	return ADCH/(85+1);			// remap interval from 0..255 to 0..2
}

uint8_t get_rom_data(uint8_t addr)
{
	if(addr <= 0x07)							addr = addr+0x08*id_select;	//	OK
	else if( (addr >= 0x08) && (addr <= 0x0F) )	addr = addr-0x08 + 0x18;	//	OK
	else if( (addr >= 0x60) && (addr <= 0x6F) )	addr = addr-0x60 + 0x20;	//	OK
	//	else if( addr == 0xFF )						return id_select;
	else										addr = 0x30;				//	OK
	return pgm_read_byte(&rom_data[addr]);
}
