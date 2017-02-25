/*##############################################################################

	Name	: USI TWI Slave driver - I2C/TWI-EEPROM
	Version	: 1.3  - Stable
	autor	: Martin Junghans	jtronics@gmx.de
	page	: www.jtronics.de
	License	: GNU General Public License

	Update	: 09.09.2011 - ATtiny24, ATtiny44, ATtiny88

	Created from Atmel source files for Application Note AVR312:
	Using the USI Module as an I2C slave like an I2C-EEPROM.

//############################################################################*/

#include <avr/io.h>
#include <avr/interrupt.h>
#include "usi_slave_eeprom.h"

//############################################################### device defines

#define DDR_USI             DDRB
#define PORT_USI            PORTB
#define PIN_USI             PINB
#define PORT_USI_SDA        PB0
#define PORT_USI_SCL        PB2
#define PIN_USI_SDA         PINB0
#define PIN_USI_SCL         PINB2
#define USI_START_COND_INT  USISIF
#define USI_START_VECTOR    USI_START_vect
#define USI_OVERFLOW_VECTOR USI_OVF_vect

//############################################## functions implemented as macros

#define SET_USI_TO_SEND_ACK( ) 	{	USIDR = 0; \
									DDR_USI |= (1<<PORT_USI_SDA); \
									USISR	=  (0<<USI_START_COND_INT)|(1<<USIOIF )|(1<<USIPF)|(1<<USIDC)|(0x0E<<USICNT0);	}
									// Prepare ACK
									// Set SDA as output
									// Clear all interrupt flags, except Start Cond
									// Set USI counter to shift 1 bit

#define SET_USI_TO_READ_ACK( ) 	{	USIDR = 0; \
									DDR_USI &= ~(1<<PORT_USI_SDA);\
									USISR	= (0<<USI_START_COND_INT)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0E<<USICNT0);	}
									// Set SDA as input
									// Prepare ACK
									// Clear all interrupt flags, except Start Cond
									// Set USI counter to shift 1 bit

#define SET_USI_TO_TWI_START_CONDITION_MODE( ) {	USICR = (1<<USISIE)|(0<<USIOIE)|(1<<USIWM1)|(0<<USIWM0)|(1<<USICS1)|(0<<USICS0)|(0<<USICLK)|(0<<USITC);\
													USISR = (0<<USI_START_COND_INT)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);	}
													// Enable Start Condition Interrupt, disable Overflow Interrupt
													// Set USI in Two-wire mode, no USI Counter overflow hold
													// Shift Register Clock Source = External, positive edge
													// 4-Bit Counter Source = external, both edges
													// No toggle clock-port pin
													// Clear all interrupt flags, except Start Cond

#define SET_USI_TO_SEND_DATA( ) {	DDR_USI |= (1<<PORT_USI_SDA);\
									USISR	=  (0<<USI_START_COND_INT)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);	}
									// Set SDA as output
									// Clear all interrupt flags, except Start Cond
									// Set USI to shift out 8 bits

#define SET_USI_TO_READ_DATA( ) {	DDR_USI &= ~(1<<PORT_USI_SDA);\
									USISR	=	(0<<USI_START_COND_INT)|(1<<USIOIF)|(1<<USIPF)|(1<<USIDC)|(0x0<<USICNT0);	}
									// Set SDA as input
									// Clear all interrupt flags, except Start Cond
									// Set USI to shift out 8 bits

//##################################################################### typedefs

typedef enum
{
    USI_SLAVE_CHECK_ADDRESS                = 0x00,
    USI_SLAVE_SEND_DATA                    = 0x01,
    USI_SLAVE_REQUEST_REPLY_FROM_SEND_DATA = 0x02,
    USI_SLAVE_CHECK_REPLY_FROM_SEND_DATA   = 0x03,
    USI_SLAVE_REQUEST_DATA                 = 0x04,
    USI_SLAVE_GET_DATA_AND_SEND_ACK        = 0x05
} overflowState_t;

//############################################################## local variables

//volatile uint8_t         	slaveAddress;
volatile overflowState_t 	overflowState;
#define  overflowState_t	*(volatile uint16_t *)(&GPIOR0)

//############################################ initialize USI for TWI slave mode

//void usiTwiSlaveInit(uint8_t ownAddress)
void usi_twi_slave_init(void)
{
  cli();
  // In Two Wire mode (USIWM1, USIWM0 = 1X), the slave USI will pull SCL
  // low when a start condition is detected or a counter overflow (only
  // for USIWM1, USIWM0 = 11).  This inserts a wait state. SCL is released
  // by the ISRs (USI_START_vect and USI_OVERFLOW_vect).
  DDR_USI |= ( 1 << PORT_USI_SCL ) | ( 1 << PORT_USI_SDA );		// Set SCL and SDA as output
  PORT_USI |= ( 1 << PORT_USI_SCL ) | ( 1 << PORT_USI_SDA );	// Set SCL high; Set SDA high
  DDR_USI &= ~( 1 << PORT_USI_SDA );  							// Set SDA as input
  USICR =	( 1 << USISIE ) |										// Enable Start Condition Interrupt
			( 0 << USIOIE ) |										// Disable Overflow Interrupt
			( 1 << USIWM1 ) | ( 0 << USIWM0 ) |						// Set USI in Two-wire mode, no USI Counter overflow hold
			( 1 << USICS1 ) | ( 0 << USICS0 ) | ( 0 << USICLK ) |	// Shift Register Clock Source = external, positive edge 4-Bit Counter Source = external, both edges
			( 0 << USITC );											// No toggle clock-port pin
  USISR = ( 1 << USI_START_COND_INT ) | ( 1 << USIOIF ) | ( 1 << USIPF ) | ( 1 << USIDC );  // clear all interrupt flags and reset overflow counter
  sei();
}

//###################################################### USI Start Condition ISR

ISR( USI_START_VECTOR )
{
    overflowState = USI_SLAVE_CHECK_ADDRESS;			// Set default starting conditions for new TWI package
    DDR_USI &= ~( 1 << PORT_USI_SDA );					// Set SDA as input

    // Wait for SCL to go low to ensure the Start Condition has completed (the
    // Start detector will hold SCL low ) - if a Stop Condition arises then leave
    // The interrupt to prevent waiting forever - don't use USISR to test for Stop
    // Condition as in Application Note AVR312 because the Stop Condition Flag is
    // going to be set from the last TWI sequence

    while (	( PIN_USI & ( 1 << PIN_USI_SCL ) ) &&	!( ( PIN_USI & ( 1 << PIN_USI_SDA ) ) ));// SCL his high and SDA is low

    if ( !( PIN_USI & ( 1 << PIN_USI_SDA ) ) )	// A Stop Condition did not occur
        USICR =
            ( 1 << USISIE ) |								// Keep Start Condition Interrupt enabled to detect RESTART
            ( 1 << USIOIE ) |								// Enable Overflow Interrupt
            ( 1 << USIWM1 ) | ( 1 << USIWM0 ) |			    // Set USI in Two-wire mode, hold SCL low on USI Counter overflow
            ( 1 << USICS1 ) | ( 0 << USICS0 ) | ( 0 << USICLK ) |	// 4-Bit Counter Source = external, both edges; Clock Source = External, positive edge
            ( 0 << USITC );									// No toggle clock-port pin
    else	// A Stop Condition did occur
        USICR =
            ( 1 << USISIE ) |								// Enable Start Condition Interrupt
            ( 0 << USIOIE ) |								// Disable Overflow Interrupt
            ( 1 << USIWM1 ) | ( 0 << USIWM0 ) |			    // Set USI in Two-wire mode, no USI Counter overflow hold
            ( 1 << USICS1 ) | ( 0 << USICS0 ) | ( 0 << USICLK ) |		// 4-Bit Counter Source = external, both edges; Clock Source = external, positive edge
            ( 0 << USITC );									// No toggle clock-port pin
    USISR =
        ( 1 << USI_START_COND_INT ) | ( 1 << USIOIF ) |	// Clear interrupt flags - resetting the Start Condition Flag will release SCL
        ( 1 << USIPF ) |( 1 << USIDC ) |
        ( 0x0 << USICNT0);								// Set USI to sample 8 bits (count 16 external SCL pin toggles)
}

//################################################### ISR( USI_OVERFLOW_VECTOR )

ISR( USI_OVERFLOW_VECTOR )	// Handles all the communication. Only disabled when waiting for a new Start Condition.
{
    switch ( overflowState )
    {
//###### Address mode: check address and send ACK (and next USI_SLAVE_SEND_DATA) if OK, else reset USI
    case USI_SLAVE_CHECK_ADDRESS:
        if (USIDR == 0 || (USIDR & ~1) == SLAVE_ADDR_ATTINY)     // If adress is either 0 or own address
        {
            if (  USIDR & 0x01 ) overflowState = USI_SLAVE_SEND_DATA;		// Master Write Data Mode - Slave transmit
            else
            {
                overflowState = USI_SLAVE_REQUEST_DATA;		// Master Read Data Mode - Slave receive
                buffer_adr=0xFFFF;							// Buffer position undefined
            } // end if
            SET_USI_TO_SEND_ACK();
        }
        else	SET_USI_TO_TWI_START_CONDITION_MODE();
        break;

//###################################### Master Write Data Mode - Slave transmit

    // Check reply and goto USI_SLAVE_SEND_DATA if OK,
    // else reset USI
    case USI_SLAVE_CHECK_REPLY_FROM_SEND_DATA:
        if ( USIDR )
        {
            SET_USI_TO_TWI_START_CONDITION_MODE();	// If NACK, the master does not want more data
            return;
        }

    // From here we just drop straight into USI_SLAVE_SEND_DATA if the master sent an ACK
    case USI_SLAVE_SEND_DATA:

        if (buffer_adr == 0xFFFF) buffer_adr=0;		// No buffer position given, set buffer address to 0
        USIDR = get_rom_data(buffer_adr++);			// Send data byte; Increment buffer address for next byte

        overflowState = USI_SLAVE_REQUEST_REPLY_FROM_SEND_DATA;
        SET_USI_TO_SEND_DATA( );
        break;

    // Set USI to sample reply from master
    // Next USI_SLAVE_CHECK_REPLY_FROM_SEND_DATA
    case USI_SLAVE_REQUEST_REPLY_FROM_SEND_DATA:
        overflowState = USI_SLAVE_CHECK_REPLY_FROM_SEND_DATA;
        SET_USI_TO_READ_ACK( );
        break;

//######################################## Master Read Data Mode - Slave receive

    // Set USI to sample data from master,
    // Next USI_SLAVE_GET_DATA_AND_SEND_ACK
    case USI_SLAVE_REQUEST_DATA:
        overflowState = USI_SLAVE_GET_DATA_AND_SEND_ACK;
        SET_USI_TO_READ_DATA( );
        break;

    // Copy data from USIDR and send ACK
    // Next USI_SLAVE_REQUEST_DATA
    case USI_SLAVE_GET_DATA_AND_SEND_ACK:
        //data=USIDR; 					// Read data received
        if (buffer_adr == 0xFFFF) buffer_adr = USIDR % (buffer_size+1); // First access, read buffer position
        /*
        {
            if(data<=buffer_size)		// Check if address within buffer size
            {
                buffer_adr= data; 		// Set position as received
            }
            else
            {
                buffer_adr=0; 			// Set address to 0
            }
        }
        */
        else	rxbuffer[buffer_adr++]=USIDR;		// Ongoing access, receive data
        /*
        {
			rxbuffer[buffer_adr]=data;				// Write data to buffer
            buffer_adr++; 							// Increment buffer address for next write access
        }
        */
        overflowState = USI_SLAVE_REQUEST_DATA;	// Next USI_SLAVE_REQUEST_DATA
        SET_USI_TO_SEND_ACK( );
        break;


    }// End switch
}// End ISR( USI_OVERFLOW_VECTOR )
