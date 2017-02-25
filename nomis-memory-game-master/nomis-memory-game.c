/**
 * Project: Memory Game
 * Version: 02
 * Creator(s): Lenny McDougle
 * License: MIT License
 * 
 * Original from Christopher Woodall.
 * 
 * Memory Game is a Simon (tm) clone based around an ATTiny85 microprocessor.
 * The reads a "random" string of moves from EEPROM and asks the player to copy.
 * If the player is unable to remember the string and presses a wrong button,
 * then the game is over and the player looses.
 */
 
#define F_CPU 1200000		// 1,2MHz internal osci (= 9,6 MHz / 8)

#include <avr/io.h>
#include <util/delay.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>

#define clear_display()		PORTB &= 0xF0;
#define set_display(state)	PORTB |= led_display[state];

// EEPROM addresses
#define RAND_SAVE_ADDR		0
#define MAX_ADDR			63
#define MIN_ADDR			1

/**
The "random" numbers are generated on the PC and copied to the EEPROM file which is then written to the AVR.
At EEPROM address 0 the current/next start address for the random string is save. The AVR read it out and
interprets it as follows:

eeprom_read_byte(0) = int8_t addr_start = [abcdef | gh]

The upper 6 bits are the EEPROM address to read the rand_val from. rand_val is also 8 bit and we have 4 buttons.
The bits gh represent a number between 0 and 3. We now shift the rand_val by gh. So we shift it by 0..3.
Then we clear the upper 6 bits of rand_val to get the final random number.

0 <= ((rand_val >> gh) & 0b0000001) <= 3

So the Attiny13 has 64 byte of EEPROM 1 is used for saving the next/last start address and the remaining once are
free for random junk. So 63 (=MAX_ADDR) bytes are available. This times 4, because each byte represents 4 random
numbers between 0 and 3, equals 252. So the maximal random sequence without repetition is 252 turns. Details can
be seen in get_rand() function.

Well I guess if you can remember half of it you're already a genius. Why I do it like this? Well the RAM is
with 64bytes so limited it couldn't hold a longer sequence.
*/

/**
 * enum STATE gamestates: IDLE, CPU, PLAYER
 *  
 * \breif Define state names for the finite state machine that runs the game flow.
 *         
 * IDLE: The MCU waits for an input from the user to play the game. In this state
 *       the MCU cascades the LEDS, signifying that it is on and ready to go. While
 *       this is happening the MCU is incrementing the random variable to
 *       continuously change the seed. Exits into the CPU state if a button is
 *       pressed.
 *
 * CPU: The CPU's turn. The CPU (well MCU) generates a random number and,
 *      adds that as a move to the moves[] array. Then the CPU returns the game
 *      to the PLAYER state. Ignores input from player.
 * 
 * PLAYER: The player's turn, in this state the MCU will wait for a string of 
 *         inputs from the player. Once the Player presses a button that is not
 *         in the array moves[], the player looses the game and the game goes to
 *         the LOSE state. Otherwise the game goes to the CPU state and the 
 *         computer adds another move to the moves array.
 */
 
enum STATE {
    IDLE,
    CPU,
    PLAYER
} gamestates;

enum STATE gamestate = IDLE;

/** function defs */
uint16_t	read_adc(void);
uint8_t		get_rand(void);
uint8_t		get_player_move(void);
void		cascade_leds(void);
void		blink_leds(void);
void 		cast_addr(void);

/** global variables */
uint8_t		addr = 0;
uint8_t		led_display[4]={0x03,0x04,0x06,0x01};	// translate the moves into something that we can send to the charlieplexed LEDs

int main (void)	{
	uint8_t		i;
    uint8_t		player_counter = 0;
	uint8_t		player_move;
	uint8_t		addr_start = 0;
    uint8_t		cpu_counter = 0;
	
    DDRB 	= 0x07;				// set up PortB pins 0, 1, and 2 to be outputs.
    PORTB 	= 0x00;				// set pull down resistors and all pins off.
   
	// Setup the ADC
    ADMUX 	= 2; 	// select ADC2
					// REFS0			= 0		Vref = VCC
					// ADLAR			= 0		LSB left
								
	ADCSRA 	= (1 << ADEN) | (1 << ADPS1) | (1 << ADPS0);
					// ADEN				= 1		enable ADC
					// ADCSRA[2:0]		= 011	clock/8 => 125 kHz ADC clock

    while (1) {
        if (gamestate == CPU) {           
            for (i = 0; i <= cpu_counter; i++) {
				addr 	=	addr_start + i;				// set new addr to red from validity check done by get_rand
				cast_addr();
				
                PORTB |= led_display[get_rand()]; 
                _delay_ms(500);
                PORTB &= 0xF0;
                _delay_ms(100);
            }
			
			eeprom_write_byte(RAND_SAVE_ADDR, addr);	// write current addr back to eeprom that to know where to start next power up
            cpu_counter++;
            gamestate = PLAYER;
            _delay_ms(10);
        }
		
		else if (gamestate == PLAYER) {
            player_move = get_player_move();
			
            if (player_move == 4)	{
				clear_display();
			}
			
			else {
                set_display(player_move);               
                _delay_ms(50);
                clear_display();
                _delay_ms(50);
                set_display(player_move);
                _delay_ms(50);
                clear_display();
				
				addr	=	addr_start + player_counter;
				cast_addr();
				
                if (player_move == get_rand()) {
                    if (player_counter == (cpu_counter-1)) {
                        player_counter = 0;
                        _delay_ms(1000);
                        gamestate = CPU;
                    } else {   
                        player_counter++;
                    }
                }
				
				else {
                    player_counter	=	0;
                    cpu_counter		=	0;
                    
                    gamestate = IDLE;
                    blink_leds();
                    _delay_ms(100);
                    blink_leds();
                    _delay_ms(500);

                }
            }
        }
		
		else {	// gamestate == IDLE
            cascade_leds();
            if (read_adc() > 200) {
                gamestate	=	CPU;
				addr_start	=	eeprom_read_byte(RAND_SAVE_ADDR);	// read addr where we stopped last time from epprom
                
				blink_leds();
                _delay_ms(100);
                blink_leds();
                _delay_ms(500);
			}
		}
    }
    return 0;
}

void cascade_leds(void)	{
    static uint8_t i = 0;
    static uint8_t up = 1;
   
    PORTB |= led_display[i];
    _delay_ms(100);
    PORTB &= 0xF0;
    _delay_ms(50);

    if 		(i == 3) up = 0;
    else if (i == 0) up = 1;

    if (up) i++;
    else    i--;
}

void blink_leds(void) {
    uint8_t j;
    uint8_t i;
	
    for( i = 0; i < 100; i++) {
        for (j = 0; j <= 3; j++) {
            set_display(j);
            _delay_us(100);
            clear_display();
            _delay_us(10);
        }
    }
}

uint16_t read_adc(void) {
    ADCSRA |= (1 << ADSC);			// start single conversion
    while(ADCSRA & (1 << ADSC));	// loop until ADSC gets low (=conversion done)
    return ADC;						// return the ADC data
}

uint8_t get_player_move(void) {
    uint16_t raw_move = read_adc();
    uint8_t move;
    static uint8_t prev_move = 4;
	
    if		((raw_move >= 500) & (raw_move <= 520)) move = 0;
    else if	((raw_move >= 600) & (raw_move <= 620))	move = 1;
    else if	((raw_move >= 660) & (raw_move <= 680))	move = 2;
    else if	((raw_move >= 710) & (raw_move <= 730))	move = 3;
    else											move = 4;
        
    if (move == prev_move)	move = 4;	// make the reading edge sensitive
    else        prev_move = move;
	
    _delay_us(1000);					// try to prevent bouncing
    return move;
}

void cast_addr(void)	{
	addr	%=		MAX_ADDR - MIN_ADDR + 1;	// keep 	0		 <= [00ab|cdef] <= MAX_ADDR - MIN_ADDR
	addr	+=		MIN_ADDR;					// keep 	MIN_ADDR <= [00ab|cdef] <= MAX_ADDR
}

uint8_t get_rand(void)	{
	uint8_t	rand_val;											// declair rand_val variable
	uint8_t	addr_work	=	addr;
	
	addr_work	>>=	2;											// [abcf|efgh] => [00ab|cdef]
	rand_val 	=	eeprom_read_byte((uint8_t*)(addr_work));	// get actual random number from eeprom
	addr_work 	=	addr & 0b00000011;				 			// getting 1/2-nibble addr
	addr_work	*=	2;											// double the 1/2-nibble value, cos the shifting need to be done twice as much as 1/2-nibble value
	rand_val 	>>=	addr_work;									// shift to get the correct 1/2-nibble to most right place
	rand_val 	&=	0b00000011;									// clear remaining upper bits ==>	0 <= rand_val <= 3
	return			rand_val;									// return rand_val
}