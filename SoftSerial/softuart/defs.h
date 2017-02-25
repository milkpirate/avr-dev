/* defs.h : definitions header file */

/*** user settings for UART3 ***/
#define BAUD		9600    // UART3 baud rate
#define STOP_BITS	1		// nbr of stop bits
#define TX3_PIN		PORTD.4 // UART3 TX pin
#define RX3_PIN		PIND.0  // UART3 RX pin (external INT0)     
#define RX_BUFFER_SIZE3 10  // size of UART3 RX buffer
/*** end of user settings ***/

// data types
#define byte 	unsigned char  
#define word	unsigned int
// watchdog reset ("borrow" this from Introl)
#define wdogtrig();		#asm("wdr") 
// logix
#define TRUE	1
#define FALSE	0  
// TX & RX levels
#define HIGH	1
#define LOW		0
// quartz frequency
#define CLK		4000000 	
// UART3 specific
#define	D	8	           	// frequency divider => (CLK / 8) = 4MHz/8 = 500.000 Hz
#define	N 	(CLK/(D*BAUD)) 	// nbr associated by Timer0 to 1 bit length 
#define START_BIT_LENGTH	((N + N/2) - (80/D)) // adjusted start bit length    
#define DATA_BIT_LENGTH		(N - (56/D))         // adjusted data bit length 
#define UART3_STOP			(8 + STOP_BITS)		 // total nbr. of bits
// bit positions in the Status Register of UART3
#define	TX_BUSY 	6 		// busy sending data (internal - read only)
#define	RX_BUSY		7 		// busy receiving data (internal - read only)   

