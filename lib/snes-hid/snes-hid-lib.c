#include "snes-hid-lib.h"

void delay_ms(volatile uint16_t ms)
{
	while(ms--) _delay_us(1000);
}

void send_hid_report(uint16_t read_buttons, uint8_t gamepad)
{
    if(gamepad)
    {	// tx_buffer = [0xFD|length|x|y|z|rot|b76543210|bfedcba98]
		//		&		0	 1		2 3 4 5   6         7
        // 					 6		read		0			 lr ud 0  0
        uart_tx_char(0xFD);							// [0] start byte
        uart_tx_char(0x06);							// [1] length

        int8_t tmp = 0;
        uint8_t tmp2 = 0;
		tmp2 = (uint8_t)(read_buttons & 0xF0);		// |udlr0000|
		if(tmp2 & KEY_RT) tmp = 127;				// right (+127)
		if(tmp2 & KEY_LF) tmp = -127;				// left  (-127)
        uart_tx_char(tmp);							// [2] send x

        tmp = 0;
		if(tmp2 & KEY_DW) tmp = 127;				// down (+127) (top to buttom)
		if(tmp2 & KEY_UP) tmp = -127;				// up   (-127)
        uart_tx_char(tmp);							// [3] send y

        uart_tx_char(0x00);							// [4] send z
        uart_tx_char(0x00);							// [5] send rot

		// S=start, s=select, R=right shoulder... |BYsSudlrAXLR|	= 12
        tmp = (uint8_t)(read_buttons >> 4);			// |BYsSudlr|
        tmp &= 0xF0;								// |BYsS0000|
        tmp |= (uint8_t)(read_buttons & 0x0F);		// |BYsSAXLR|
        uart_tx_char(tmp);							// [2] send buttons 0-7
        uart_tx_char(0x00);							// [3] send buttons 8-15
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

void uart_tx_str_P(const char str[])
{
    while(pgm_read_byte(str)) uart_tx_char(pgm_read_byte(str++));
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

uint8_t init_config_ee(uint16_t read_buttons)
{
	gamepad =	eeprom_read_byte(&gamepad_ee);	// read config
	gamepad &= 	0x01;							// if EE not set (=0xFF) => gamepad = 0x01
    if(read_buttons) gamepad ^= 0x01;				// yes => toggle settings
    eeprom_update_byte(&gamepad_ee, gamepad);	// update settings if neccessary
    return gamepad;
}
