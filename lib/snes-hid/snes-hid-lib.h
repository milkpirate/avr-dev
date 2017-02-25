#ifndef _SNES_HID_LIB_H_
#define _SNES_HID_LIB_H_

/* common includes */
#include <stdint.h>

/* avr specific */
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

/*
	Self made milliseconds delay.
	Parameter: ms
*/
void delay_ms(volatile uint16_t ms);

/*
	Build and send HID report.
	Parameter:	read_btns	- read buttons
				gamepad		- configuration (keyboard / gamepad)
*/
void send_hid_report(uint16_t read_btns, uint8_t gamepad);

/*
	Send a string which is stored in PROGMEM via UART.
	Parameter:	const char *str	-	String to be sent
*/
void uart_tx_str_P(const char *str);

/*
	Function to get the button states (debounce included)
	Return:	Bitwise masking of pressed buttons
*/
uint16_t check_buttons(void);

/*
	Read configuration from EEPROM / initialize it if
	neccessary. Switch configuration depending on button
	presses and overwrite old settings.
	Parameter:	read_buttons	-	Buttons pressed
									(neccessary to
									determine if
									configuration needs
									to be switched)
	Return:		gamepad			-	Actual configuration
*/
uint8_t init_config_ee(uint16_t read_buttons);
#endif
