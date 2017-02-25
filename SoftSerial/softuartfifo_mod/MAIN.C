/************************************************************************/
/*                                                                      */
/*                      Test Software UART                              */
/*                                                                      */
/*              Author: P. Dannegger                                    */
/*                                                                      */
/************************************************************************/
//			Target: ATtiny44

#define	F_CPU	8e6
#define	BAUD	57600

#include <util\delay.h>
#include <avr\pgmspace.h>
#include <avr\io.h>
#include <avr\interrupt.h>

//	Easier type writing:
typedef unsigned char  u8;
typedef   signed char  s8;
typedef unsigned short u16;
typedef   signed short s16;
typedef unsigned long  u32;
typedef   signed long  s32;

// volatile access (reject unwanted removing access):
#define vu8(x)  (*(volatile u8*)&(x))
#define vs8(x)  (*(volatile s8*)&(x))
#define vu16(x) (*(volatile u16*)&(x))
#define vs16(x) (*(volatile s16*)&(x))
#define vu32(x) (*(volatile u32*)&(x))
#define vs32(x) (*(volatile s32*)&(x))

#define	OPTR18 __asm__ volatile (""::);		// it helps, but why ?
						// remove useless R18/R19
// always inline function x:
#define AIL(x)   static x __attribute__ ((always_inline)); static x
// never inline function x:
#define NIL(x)   x __attribute__ ((noinline)); x

// 	Access bits like variables:
struct bits {
  u8 b0:1;
  u8 b1:1;
  u8 b2:1;
  u8 b3:1;
  u8 b4:1;
  u8 b5:1;
  u8 b6:1;
  u8 b7:1;
} __attribute__((__packed__));

#include "suart.h"

#define	STXD		SBIT( PORTA, PA6 )	// = OC1A
#define	STXD_DDR	SBIT( DDRA,  PA6 )

#define STX_SIZE	2

void suart_init( void );
void uputchar( u8 c );			// send byte
void uputs_( u8 *s );			// send string from SRAM
u8 kbhit( void );			// check incoming data
u8 ugetchar( void );			// get byte

#define BIT_TIME	(u16)(F_CPU * 1.0 / BAUD + 0.5)

#define	TX_HIGH		(1<<COM1A1^1<<COM1A0)
#define	TX_LOW		(TX_HIGH^1<<COM1A0)
#define	TX_OUT		TCCR1A		// use compare output mode

#define ROLLOVER( x, max )	x = ++x >= max ? 0 : x
					// count up and wrap around

static u8 stx_buff[STX_SIZE];
static u8 stx_in;
static u8 stx_out;
static u8 stx_data;
static u8 stx_state;

static u8 srx_buff[SRX_SIZE];
static u8 srx_in;
static u8 srx_out;
static u8 srx_data;
static u8 srx_state;

void init( void )
{
  DDRA = 0;
  DDRB = 0;
  PORTA = 0xFF;
  PORTB = 0xFF;
  suart_init();
}

#define BIT_TIME	(u16)(XTAL * 1.0 / BAUD + 0.5)

#define	TX_HIGH		(1<<COM1A1^1<<COM1A0)
#define	TX_LOW		(TX_HIGH^1<<COM1A0)
#define	TX_OUT		TCCR1A		// use compare output mode

#define ROLLOVER( x, max )	x = ++x >= max ? 0 : x
					// count up and wrap around

static u8 stx_buff[STX_SIZE];
static u8 stx_in;
static u8 stx_out;
static u8 stx_data;
static u8 stx_state;

void suart_init( void )
{
  OCR1A = BIT_TIME - 1;
  TCCR1A = TX_HIGH;			// set OC1A high, T1 mode 4
  TCCR1B = 1<<ICNC1^1<<WGM12^1<<CS10;	// noise canceler, 1-0 transition,
					// CLK/1, T1 mode 4 (CTC)
  TCCR1C = 1<<FOC1A;
  stx_state = 0;
  stx_in = 0;
  stx_out = 0;
  srx_in = 0;
  srx_out = 0;
  STXD_DDR = 1;				// output enable
  TIFR1 = 1<<ICF1;			// clear pending interrupt
  TIMSK1 = 1<<ICIE1^1<<OCIE1A;		// enable tx and wait for start
}


void uputchar( u8 c )			// transmit byte
{
  u8 i = stx_in;

  ROLLOVER( i, STX_SIZE );
  stx_buff[stx_in] = ~c;		// complement for stop bit after data
  while( i == vu8(stx_out));		// until at least one byte free
					// stx_out modified by interrupt !
  stx_in = i;
}

void uputs_( u8 *s )			// transmit string from SRAM
{
  while( *s )
    uputchar( *s++ );
}

/******************************	Interrupts *******************************/

ISR( TIM1_CAPT_vect )				// start detection
{
  s16 i = ICR1 - BIT_TIME / 2;			// scan at 0.5 bit time

  OPTR18					// avoid disoptimization
  if( i < 0 )
    i += BIT_TIME;				// wrap around
  OCR1B = i;
  srx_state = 10;
  TIFR1 = 1<<OCF1B;				// clear pending interrupt
  if( SRXD_PIN == 0 )				// still low
    TIMSK1 = 1<<OCIE1A^1<<OCIE1B;		// wait for first bit
}

ISR( TIM1_COMPA_vect )				// transmit data bits
{
  if( stx_state ){
    stx_state--;
    TX_OUT = TX_HIGH;
    if( stx_data & 1 )				// lsb first
      TX_OUT = TX_LOW;
    stx_data >>= 1;
    return;
  }
  if( stx_in != stx_out ){			// next byte to sent
    stx_data = stx_buff[stx_out];
    ROLLOVER( stx_out, STX_SIZE );
    stx_state = 9;				// 8 data bits + stop
    TX_OUT = TX_LOW;				// start bit
  }
}

int main( void )
{
  init();
  sei();
  uputs( "Hallo Peter\n\r" );
  for(;;){
    _delay_ms( 5000 );
    while( kbhit() )
      uputchar( ugetchar());
  }
}
