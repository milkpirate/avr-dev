/*****************************************************************************
*
* Copyright (C) 2003 Atmel Corporation
*
* File              : USI_UART.c
* Compiler          : IAR EWAAVR 2.28a
* Created           : 18.07.2002 by JLL
* Modified          : 02-10-2003 by LTA
*
* Support mail      : avr@atmel.com
*
* Supported devices : ATtiny25
*
* Application Note  : AVR307 - Half duplex UART using the USI Interface
*
* Description       : Functions for USI_UART_receiver and USI_UART_transmitter.
*                     Uses Pin Change Interrupt to detect incomming signals.
*
*
****************************************************************************/

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

#include <stdint.h>
#include "USI_UART_config.h"

//********** USI UART Defines **********//

#define DATA_BITS                 8
#define START_BIT                 1
#define STOP_BIT                  1
#define HALF_FRAME                5

#define USI_COUNTER_MAX_COUNT     16
#define USI_COUNTER_SEED_TRANSMIT (USI_COUNTER_MAX_COUNT - HALF_FRAME)
#define INTERRUPT_STARTUP_DELAY   (0x11 / TIMER_PRESCALER)
#define TIMER0_SEED               (256 - ( (SYSTEM_CLOCK / BAUDRATE) / TIMER_PRESCALER ))

#if ( (( (SYSTEM_CLOCK / BAUDRATE) / TIMER_PRESCALER ) * 3/2) > (256 - INTERRUPT_STARTUP_DELAY) )
    #define INITIAL_TIMER0_SEED       ( 256 - (( (SYSTEM_CLOCK / BAUDRATE) / TIMER_PRESCALER ) * 1/2) )
    #define USI_COUNTER_SEED_RECEIVE  ( USI_COUNTER_MAX_COUNT - (START_BIT + DATA_BITS) )
#else
    #define INITIAL_TIMER0_SEED       ( 256 - (( (SYSTEM_CLOCK / BAUDRATE) / TIMER_PRESCALER ) * 3/2) )
    #define USI_COUNTER_SEED_RECEIVE  (USI_COUNTER_MAX_COUNT - DATA_BITS)
#endif

#define UART_RX_BUFFER_MASK ( UART_RX_BUFFER_SIZE - 1 )
#if ( UART_RX_BUFFER_SIZE & UART_RX_BUFFER_MASK )
    #error RX buffer size is not a power of 2
#endif

#define UART_TX_BUFFER_MASK ( UART_TX_BUFFER_SIZE - 1 )
#if ( UART_TX_BUFFER_SIZE & UART_TX_BUFFER_MASK )
    #error TX buffer size is not a power of 2
#endif

/* General defines */
#define TRUE                      1
#define FALSE                     0

//********** Static Variables **********//

static volatile uint8_t usi_uart_tx_data;   // Tells the compiler to store the byte to be transmitted in registry.
//static uint8_t          uart_rx_buff[UART_RX_BUFFER_SIZE];  // UART buffers. Size is definable in the header file.
//static volatile uint8_t uart_rx_head = 0;
//static volatile uint8_t uart_rx_tail = 0;
static uint8_t          uart_tx_buff[UART_TX_BUFFER_SIZE];
static volatile uint8_t uart_tx_head = 0;
static volatile uint8_t uart_tx_tail = 0;

static volatile union USI_UART_status                           // Status byte holding flags.
{
    uint8_t status;
    struct
    {
        uint8_t ongoing_tx_from_buff:1;
        uint8_t ongoing_tx_pkg:1;
        uint8_t ongoing_rx_pkg:1;
        uint8_t rx_buff_ovf:1;
        uint8_t flag4:1;
        uint8_t flag5:1;
        uint8_t flag6:1;
        uint8_t flag7:1;
    };
} USI_UART_status = {0};

//********** USI_UART functions **********//

// Reverses the order of bits in a byte.
// I.e. MSB is swapped with LSB, etc.
uint8_t reverse_byte( uint8_t val )
{
    uint8_t res;
	asm volatile(
        "ldi %0, 0x80"				"\n\t"
        "reverse_byte_loop_%=:"		"\n\t"
        "rol %1"					"\n\t"
        "ror %0"					"\n\t"
        "brcc reverse_byte_loop_%="	"\n\t"
        : "=&a" (res), "=r" (val)
    );
    return res;
}

// GTCCR
// Initialise USI for UART transmission.
void usi_uart_init_tx( void )
{
    cli();
    TCNT0  = 0x00;

	GTCCR |= (1<<PSR0);										  // Reset prescaler
    TCCR0B = (0<<CS02)|(0<<CS01)|(1<<CS00);         		  // start Timer0.
    TIFR   = (1<<TOV0);                                       // Clear Timer0 OVF interrupt flag.
    TIMSK |= (1<<TOIE0);                                      // Enable Timer0 OVF interrupt.

    USICR  = (0<<USISIE)|(1<<USIOIE)|                         // Enable USI Counter OVF interrupt.
             (0<<USIWM1)|(1<<USIWM0)|                         // Select Three Wire mode.
             (0<<USICS1)|(1<<USICS0)|(0<<USICLK)|             // Select Timer0 OVER as USI Clock source.
             (0<<USITC);

    USIDR  = 0xFF;                                            // Make sure MSB is '1' before enabling USI_DO.
    USISR  = 0xF0 |                                           // Clear all USI interrupt flags.
             0x0F;                                            // Preload the USI counter to generate interrupt at first USI clock.
    DDRB  |= (1<<PB1);                                        // Configure USI_DO as output.

    USI_UART_status.ongoing_tx_from_buff = TRUE;
    sei();
}

/*
// Initialise USI for UART reception.
// Note that this function only enables pinchange interrupt on the USI Data Input pin.
// The USI is configured to read data within the pinchange interrupt.
void usi_uart_init_rx( void )
{
    PORTB |=   (1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0);         // Enable pull up on USI DO, DI and SCK pins. (And PB3 because of pin change interrupt)
    DDRB  &= ~((1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0));        // Set USI DI, DO and SCK pins as inputs.
    USICR  =  0;                                            // Disable USI.
    GIFR   =  (1<<PCIF);                                    // Clear pin change interrupt flag.
    GIMSK |=  (1<<PCIE);                                    // Enable pin change interrupt for PB3:0.
}
*/

// Puts data in the transmission buffer, after reverseing the bits in the byte.
// Initiates the transmission rutines if not already started.
void usi_uart_tx_byte( uint8_t data )
{
    uint8_t tmphead;

    tmphead = ( uart_tx_head + 1 ) & UART_TX_BUFFER_MASK;        // Calculate buffer index.
    while ( tmphead == uart_tx_tail );                           // Wait for free space in buffer.
    uart_tx_buff[tmphead] = reverse_byte(data);                    // Reverse the order of the bits in the data byte and store data in buffer.
    uart_tx_head = tmphead;                                      // Store new index.

    if ( !USI_UART_status.ongoing_tx_from_buff )    // Start transmission from buffer (if not already started).
    {
        //while ( USI_UART_status.ongoing_rx_pkg ); // Wait for USI to finsh reading incoming data.
        usi_uart_init_tx();
    }
}

/*
// Returns a byte from the receive buffer. Waits if buffer is empty.
uint8_t usi_uart_rx_byte( void )
{
    uint8_t tmptail;

    while ( uart_rx_head == uart_rx_tail );                 // Wait for incomming data
    tmptail = ( uart_rx_tail + 1 ) & UART_RX_BUFFER_MASK;  // Calculate buffer index
    uart_rx_tail = tmptail;                                // Store new index
    return Bit_Reverse(uart_rx_buff[tmptail]);              // Reverse the order of the bits in the data byte before it returns data from the buffer.
}

// Check if there is data in the receive buffer.
uint8_t usi_uart_data_in_rx_buff( void )
{
    return ( uart_rx_head != uart_rx_tail );                // Return 0 (FALSE) if the receive buffer is empty.
}
*/

// Transmits a whole (\0 terminated) string
void usi_uart_tx_str(char str[])
{
	while(*str) usi_uart_tx_byte(*str++);
}

// Transmits a whole (\0 terminated) progmem string
void usi_uart_tx_str_P(const char str[])
{
    while(pgm_read_byte(str)) usi_uart_tx_byte(pgm_read_byte(str++));
}

// ********** Interrupt Handlers ********** //

/*
// The pin change interrupt is used to detect USI_UART reseption.
// It is here the USI is configured to sample the UART signal.
ISR(PCINT0_vect)
{
    if (!( PINB & (1<<PB0) ))                                     // If the USI DI pin is low, then it is likely that it
    {                                                             //  was this pin that generated the pin change interrupt.
        TCNT0  = INTERRUPT_STARTUP_DELAY + INITIAL_TIMER0_SEED;   // Plant TIMER0 seed to match baudrate (incl interrupt start up time.).
        GTCCR |= (1<<PSR0);
        TCCR0B = (0<<CS02)|(0<<CS01)|(1<<CS00);         		  // Reset the prescaler and start Timer0.
        TIFR   = (1<<TOV0);                                       // Clear Timer0 OVF interrupt flag.
        TIMSK |= (1<<TOIE0);                                      // Enable Timer0 OVF interrupt.

        USICR  = (0<<USISIE)|(1<<USIOIE)|                         // Enable USI Counter OVF interrupt.
                 (0<<USIWM1)|(1<<USIWM0)|                         // Select Three Wire mode.
                 (0<<USICS1)|(1<<USICS0)|(0<<USICLK)|             // Select Timer0 OVER as USI Clock source.
                 (0<<USITC);
                                                                  // Note that enabling the USI will also disable the pin change interrupt.
        USISR  = 0xF0 |                                           // Clear all USI interrupt flags.
                 USI_COUNTER_SEED_RECEIVE;                        // Preload the USI counter to generate interrupt.

        GIMSK &=  ~(1<<PCIE);                                    // Disable pin change interrupt for PB3:0.

        USI_UART_status.ongoing_rx_pkg = TRUE;
    }
}
*/

// The USI Counter Overflow interrupt is used for moving data between memmory and the USI data register.
// The interrupt is used for both transmission and reception.
ISR(USI_OVF_vect)
{
    uint8_t tmptail;
    //uint8_t tmphead;

    /*
    // Check if we are running in Transmit mode.
    if( USI_UART_status.ongoing_tx_from_buff )
    {
    */
        // If ongoing transmission, then send second half of transmit data.
        if( USI_UART_status.ongoing_tx_pkg )
        {
            USI_UART_status.ongoing_tx_pkg = FALSE;    // Clear on-going package transmission flag.

            USISR = 0xF0 | (USI_COUNTER_SEED_TRANSMIT);                 // Load USI Counter seed and clear all USI flags.
            USIDR = (usi_uart_tx_data << 3) | 0x07;                      // Reload the USIDR with the rest of the data and a stop-bit.
        }
        // Else start sending more data or leave transmit mode.
        else
        {
            // If there is data in the transmit buffer, then send first half of data.
            if ( uart_tx_head != uart_tx_tail )
            {
                USI_UART_status.ongoing_tx_pkg = TRUE; // Set on-going package transmission flag.

                tmptail = ( uart_tx_tail + 1 ) & UART_TX_BUFFER_MASK;    // Calculate buffer index.
                uart_tx_tail = tmptail;                                  // Store new index.
                usi_uart_tx_data = uart_tx_buff[tmptail];                  // Read out the data that is to be sent. Note that the data must be bit reversed before sent.
                                                                        // The bit reversing is moved to the application section to save time within the interrupt.
                USISR  = 0xF0 | (USI_COUNTER_SEED_TRANSMIT);            // Load USI Counter seed and clear all USI flags.
                USIDR  = (usi_uart_tx_data >> 2) | 0x80;                 // Copy (initial high state,) start-bit and 6 LSB of original data (6 MSB
                                                                        //  of bit of bit reversed data).
            }

            // done transmitting
            else
            {
                USI_UART_status.ongoing_tx_from_buff = FALSE;

                TCCR0B = (0<<CS02)|(0<<CS01)|(0<<CS00);                 // Stop Timer0.
                PORTB |=   (1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0);         // Enable pull up on USI DO, DI and SCK pins. (And PB3 because of pin change interrupt)
                DDRB  &= ~((1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0));        // Set USI DI, DO and SCK pins as inputs.
                USICR  =  0;                                            // Disable USI.
                GIFR   =  (1<<PCIF);                                    // Clear pin change interrupt flag.
                GIMSK |=  (1<<PCIE);                                    // Enable pin change interrupt for PB3:0.
            }
        }
    //}

	/*
    // Else running in receive mode.
    else
    {
        USI_UART_status.ongoing_rx_pkg = FALSE;

        tmphead     = ( uart_rx_head + 1 ) & UART_RX_BUFFER_MASK;        // Calculate buffer index.

        if ( tmphead == uart_rx_tail )                                   // If buffer is full trash data and set buffer full flag.
        {
            USI_UART_status.rx_buff_ovf = TRUE;           // Store status to take actions elsewhere in the application code
        }
        else                                                            // If there is space in the buffer then store the data.
        {
            uart_rx_head = tmphead;                                      // Store new index.
            uart_rx_buff[tmphead] = USIDR;                                // Store received data in buffer. Note that the data must be bit reversed before used.
        }                                                               // The bit reversing is moved to the application section to save time within the interrupt.

        TCCR0B = (0<<CS02)|(0<<CS01)|(0<<CS00);                 // Stop Timer0.
        PORTB |=   (1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0);         // Enable pull up on USI DO, DI and SCK pins. (And PB3 because of pin change interrupt)
        DDRB  &= ~((1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0));        // Set USI DI, DO and SCK pins as inputs.
        USICR  =  0;                                            // Disable USI.
        GIFR   =  (1<<PCIF);                                    // Clear pin change interrupt flag.
        GIMSK |=  (1<<PCIE);                                    // Enable pin change interrupt for PB3:0.
    }
    */
}

// Timer0 Overflow interrupt is used to trigger the sampling of signals on the USI ports.
ISR(TIM0_OVF_vect)
{
    TCNT0 += TIMER0_SEED;                   // Reload the timer,
                                            // current count is added for timing correction.
}
