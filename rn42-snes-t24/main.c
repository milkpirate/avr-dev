/*
SNES-Bluetooth Controller

It utilizes a RN-42 bluetooth module with HID firmware >= v6.10 to
turn a standard SNES controller into a wireless bluetooth gamepad
or keyboard.

Copyright (C) 2016  Paul Schroeder

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// basic defines
#define F_CPU		11520000UL
#define BAUD		(F_CPU / 100)
#define VAL_OSC		((F_CPU + BAUD/2) / BAUD)	//round to closest int

// common includes

// avr specific
#include <avr/io.h>
#include <avr/eeprom.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <util/delay.h>

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

// other defines
#define DBNC_DELAY		375	// [us]
#define RN42_CMD_DLY	50	// [ms]
#define _DEBUG			0
#define _DEBUG_PIN		CTRL_DAT

// global vars
#define outframe	(*(volatile uint16_t *)(&GPIOR1))

// S=start, s=select, R=right shoulder   |BYsSudlrAXLR| = 12
//#define SCANCODE_START	(0x04)	// t13 - "abcdefghijkl"
//#define SCANCODE_START	(0x10)	// t25 - "mnopqrstuvwx"
#define SCANCODE_START 	(0x1C)	// t24 - "yz0123456789"

// backup
// const char buttons[] PROGMEM = {0x2D, 0x2E, 0x2B, 0x28, 0x52, 0x51, 0x50, 0x4F, 0x2F, 0x30, 0x31, 0x38}
//								   -      =    tab  enter  aup  adown aleft arigh   [     ]     \     /

// function definitions
static void delay_ms(volatile uint16_t ms);
static void send_hid_report(uint16_t read_btns, uint8_t config);
static void uart_tx_char(char c);
static void uart_tx_str_P(const char *str);
static void init_ports(void);
static void init_uart(void);
static void init_rn42(uint8_t config);
static uint16_t check_buttons(void);
static uint8_t init_ee_config(uint16_t read_buttons);

int main(void)
{
	OSCCAL = 201;
	/*	 OSCCAL	|	F_CPU (MHz)
		-----------------------
		 201	|	11.52
		 31		|	 5.76		*/

    init_ports();
    init_uart();

    uint16_t read_btns_old = 0xFFFF;
    uint16_t read_btns = check_buttons();
	uint8_t gamepad = init_ee_config(read_btns);	// read config from EEPROM

    init_rn42(gamepad);								// init rn42 correspndingly

    while(1)
    {
        read_btns = check_buttons();											// get button status
		if (read_btns_old != read_btns) send_hid_report(read_btns, gamepad);	// did they change?
		read_btns_old = read_btns;
	}
}

void send_hid_report(uint16_t read_buttons, uint8_t gamepad)
{
    if(gamepad != 0)
    {	// tx_buffer = [0xFD|length|x|y|z|rot|b76543210|bfedcba98]
		//		&		0	 1		2 3 4 5   6         7
        // 					 6		read		0			 lr ud 0  0
        uart_tx_char(0xFD);							// [0] start byte
        uart_tx_char(0x06);							// [1] length

        int8_t tmp = 0;										// |udlrAXLR|
		if((uint8_t)read_buttons & 0b00010000) tmp = 127;	// right (+127)
		if((uint8_t)read_buttons & 0b00100000) tmp = -127;	// left  (-127)
        uart_tx_char(tmp);									// [2] send x

        tmp = 0;
		if((uint8_t)read_buttons & 0b01000000) tmp = 127;	// down (+127) (top to buttom)
		if((uint8_t)read_buttons & 0b10000000) tmp = -127;	// up   (-127)
        uart_tx_char(tmp);									// [3] send y

        uart_tx_char(0x00);							// [4] send z
        uart_tx_char(0x00);							// [5] send rot

		// S=start, s=select, R=right shoulder... |BYsSudlrAXLR|	= 12
        tmp = (uint8_t)(read_buttons >> 4);			// |BYsSudlr|
        tmp &= 0xF0;								// |BYsS0000|
        tmp |= (uint8_t)(read_buttons & 0x0F);		// |BYsSAXLR|
        uart_tx_char(tmp);							// [6] send buttons 0-7
        uart_tx_char(0x00);							// [7] send buttons 8-15
    }
    else // keyboard
    {	// tx_buffer = [0xFD|length|desriptor=1|modifier=0x00|S1|S2|...|S6]
        //		&		0	 1		2			3			  4  5	... 9
        static char keys[6] = {0x00,0x00,0x00,0x00,0x00,0x00};

		// remove un-pressed buttons
		for(uint8_t i=0; i<sizeof(keys); i++)
		{
			if(keys[i] != 0x00)
			{
				uint16_t mask = keys[i] - SCANCODE_START;
				mask = (1<<mask);
				if(read_buttons & mask)	read_buttons &= ~mask;
				else					keys[i] = 0x00;
			}
		}

		// add newly pressed onces
		for(uint8_t i=0; i<12; i++)
		{
			if(read_buttons & (1<<i))
			{
				for(uint8_t j=0; j<sizeof(keys); j++)
				{
					if(keys[j] == 0x00)
					{
						keys[j] = SCANCODE_START + i;
						break;
					}
				}
			}
		}

		// send keys
		uart_tx_char(0xFD);			// [0] start byte
        uart_tx_char(0x09);			// [1] length=9
		uart_tx_char(0x01);			// [2] descriptor
		uart_tx_char(0x00);			// [3] modifier
		uart_tx_char(0x00);			// [4] padding

		for(uint8_t i=0; i<6; i++)	uart_tx_char(keys[i]);	// [4-10] send rest of report
    }
}

uint16_t check_buttons(void)
{
	uint16_t read_buttons = 0;
	uint16_t old_buttons = 0xFFFF;
	uint8_t  counter = 0;

	while(counter != 0xff)
	{
		counter <<= 1;

		read_buttons = 0;
		CTRL_PORT |=  CTRL_LAT;	// high - latch in
		CTRL_PORT &= ~CTRL_LAT;	// low
		uint8_t i = 11;
		do{
			read_buttons <<= 1;
			if ((CTRL_PIN & CTRL_DAT) == 0) read_buttons |= 1;	// inverse logic
			CTRL_PORT &= ~CTRL_CLK;								// low	- clock line
			CTRL_PORT |=  CTRL_CLK;								// high
		} while (i--);

		if(read_buttons == old_buttons) counter |= 0x01;
		old_buttons = read_buttons;
		_delay_us(DBNC_DELAY);
	}
	return read_buttons;
}

void init_rn42(uint8_t gamepad)
{
	delay_ms(RN42_CMD_DLY*15);			// wait for RN-42 to get ready
    uart_tx_str_P(PSTR("$$$"));			// enter command mode
	delay_ms(RN42_CMD_DLY*4);

    uart_tx_str_P(PSTR("+\r"));			// enable echo
    delay_ms(RN42_CMD_DLY);

	uart_tx_str_P(PSTR("SU,11\r"));		// set baud rate to 115200
    delay_ms(RN42_CMD_DLY);

	uart_tx_str_P(PSTR("S=,5500\r"));	// remap disconnect key (0x00) to 'U' (0x55)
    delay_ms(RN42_CMD_DLY);

	uart_tx_str_P(PSTR("SN,SNES-BT-"));	// set device name
    if (gamepad != 0)	uart_tx_str_P(PSTR("Gamepad-t24\r"));
    else				uart_tx_str_P(PSTR("Keyboard-t24\r"));
    delay_ms(RN42_CMD_DLY);

    uart_tx_str_P(PSTR("SP,1234\r"));	// set pin to 1234
    delay_ms(RN42_CMD_DLY);

	uart_tx_str_P(PSTR("SY,0010\r"));	// set TX pwr to max
    delay_ms(RN42_CMD_DLY);

	uart_tx_str_P(PSTR("SO,->\r"));		// change connect string
    delay_ms(RN42_CMD_DLY);

    uart_tx_str_P(PSTR("SM,0\r"));		// slave mode
    delay_ms(RN42_CMD_DLY*2);

    uart_tx_str_P(PSTR("S~,6\r"));		// HID profile
    delay_ms(RN42_CMD_DLY*12);

	if (gamepad != 0)	uart_tx_str_P(PSTR("SH,0210\r"));	// gamepad
    else				uart_tx_str_P(PSTR("SH,0200\r"));	// keyboard
    delay_ms(RN42_CMD_DLY);

    uart_tx_str_P(PSTR("R,1\r"));		// reboot module
    delay_ms(RN42_CMD_DLY*10);
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
    OCR0A  = VAL_OSC;			// preset 1st overflow value

    TCCR0B	=  (1<<CS00);

	TIMSK0 &= ~(1<<OCIE0A);		// turn compare match interrupt off
    TIFR0	=  (1<<OCF0A);		// set compare match flag (to be on the safe side)

    UART_TX_PORT |= UART_TX;	// turn pullup on
    UART_TX_DDR  |= UART_TX;	// set as output

    outframe = 0;
    SREG = sreg;
}

uint8_t gamepad_ee EEMEM = 0;
uint8_t init_ee_config(uint16_t read_buttons)
{
	uint8_t gamepad = eeprom_read_byte(&gamepad_ee);	// read config
	gamepad &= 0x01;									// if EE not set (=0xFF) => gamepad = 0x01
    if(read_buttons != 0)
	{
		gamepad ^= 0x01;								// yes => toggle settings
    	eeprom_write_byte(&gamepad_ee, gamepad);		// update settings if neccessary
	}
    return gamepad;
}

void uart_tx_char(char c)
{
    do	// wait until last outframe is sent
    {
        sei();
        __asm volatile ("nop");
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

void uart_tx_str_P(const char str[])
{
    while(pgm_read_byte(str)) uart_tx_char(pgm_read_byte(str++));
}

void delay_ms(volatile uint16_t ms)
{
	while(ms--) _delay_us(1000);
}

ISR(TIM0_COMPA_vect)	// uart interrupt
{
    uint8_t	 sreg	= SREG;
    uint16_t data	= outframe;	// copy outframe

    OCR0A		   += VAL_OSC;	// set next overflow target

    if(data & 1)	UART_TX_PORT |=  UART_TX;	// write bit to port
    else			UART_TX_PORT &= ~UART_TX;

    if(data == 1)   TIMSK0 &= ~(1<<OCIE0A);		// if we're done with transmission
    											// disable compm. interrput

    outframe = data >> 1;		// shift data and write it back to outframe
    SREG = sreg;
}

