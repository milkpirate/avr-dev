
#include <inttypes.h> 
#include <avr/io.h> 
#include <avr/interrupt.h> 
#include <avr/signal.h> 
#include <string.h> 



#define   T0_PRELOAD 152		// 1   Bit
#define   T1_PRELOAD 204		// 0.5 Bit 

#define Tx_M_BIT		(1<<PD1)		// hw-uart TxD pin 
#define RX_M_BIT		(1<<PD2)		// int0 pin, coupled to hw-uart-pin RxD

volatile unsigned char bTxFlag;		// 
#define   TX_M_SEND  		 1			// 
#define   RX_M_RECV  		 4			// 
#define   RX_M_DATA  		 8			// 

volatile unsigned char bTxState;		// current state
#define   TX_C_START		0			// send startbit
#define   TX_C_BITS			1			// send 8 bits
#define   TX_C_STOP			2			// send stopp-bit
#define   TX_C_FINISH		3			// wait 1 bit length (appnote)
#define   TX_C_END			4			// done

volatile unsigned char bTxCount;		// Bit-Counter 0-7

volatile unsigned char bTxByte;		// Byte to send

volatile unsigned char bRxCount;		// Bit-Counter 0-7

volatile unsigned char bRxByte;		// Byte to receive


// --------------------------------------------------- 
//   INT0 Interrupt
// --------------------------------------------------- 
SIGNAL (SIG_INTERRUPT0) 
{
	if(	!(bTxFlag & RX_M_RECV)
	&& 	!(bTxFlag & TX_M_SEND)	)
	{
		GICR	&= ~(1<<INT0);        // Disable this interrupt
 		TCNT0 	 = T1_PRELOAD;       	// Set timer reload-value (to 1.5 bit len). 
		TIFR 	&= ~(1<<TOV0);        // clear Timer Ovfl 
		TIMSK 	|= (1<<TOIE0);        	// enable T/C0 overflow interrupt
		bRxByte  = 0;			
  		bRxCount = 0;                 	// Clear Receive Counter
		bTxState = TX_C_START;
		bTxFlag |= RX_M_RECV;      		// Activate Receive-Mode
  	}
}
// --------------------------------------------------- 
//   TIME Interrupt
// --------------------------------------------------- 
SIGNAL (SIG_OVERFLOW0) 
{       
	TCNT0 = T0_PRELOAD;		
	if (bTxFlag & TX_M_SEND)
	{
		switch (bTxState)
		{
		case	TX_C_START:
			PORTD	&= ~Tx_M_BIT;      //  Start
			bTxState = TX_C_BITS;
			break;
		case	TX_C_BITS:
			if (bTxByte & 0x01)	PORTD |= Tx_M_BIT;    //     clr Data Bit 
			else					PORTD &= ~Tx_M_BIT;      //     Set Data Bit 
			bTxByte >>= 1;									// shift right data
			bTxCount++;		    		// count
			if (bTxCount & 0x08)
				bTxState = TX_C_STOP;
			break;
		case	TX_C_STOP:
			PORTD	|= Tx_M_BIT;      		//     STOP
			bTxState = TX_C_FINISH;
			break;
		case	TX_C_FINISH:
			bTxState = TX_C_END;
			break;
		case	TX_C_END:
		default:
			bTxFlag &= ~TX_M_SEND;        	// all done
			break;
		}
	}
	else
// ==========================================================================
//        receive
// ==========================================================================
	if (bTxFlag & RX_M_RECV)			//	 receive ?
	{
		if (bTxState == TX_C_START)
		{
// Frame check (Start bit must be low) 
   			if(PIND & RX_M_BIT)
			{
				bTxFlag &= ~RX_M_RECV;   	// receiving sequence done
				GIFR &=  ~(1<<INTF0);   	// clear Interrupt Flag
				GICR |= 1<<INT0;   		// enable external interrupt INT0
			}
			else
			{
				bTxState = TX_C_BITS;		// ok, continue next 
			}
		}
		else
		{
			if (bRxCount & 0x08)			// is this the stop-Bit (9th)
			{
// optional Frame check here (Stop bit must be high) 
				bTxFlag &= ~RX_M_RECV;   	// receiving sequence done
				bTxFlag |= RX_M_DATA;		// signal data
			}
			else
			{
				bRxByte >>= 1;	  // Shift right data
				bRxCount++;
				if(PIND & RX_M_BIT)
					bRxByte |=0x80;			
				else	
					bRxByte &= ~0x80;			
			} 		// if (bRxCount & 0x08)
		}			//	if (bTxState == TX_C_START)
	} 				// if (bTxFlag & RX_M_RECV)
}
// --------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------
void _send_one_byte(char bByte)
{
	while (bTxFlag & RX_M_RECV);	
	bTxState 	= TX_C_START;		// state: start
	bTxByte  	= bByte;			// data byte
	bTxCount	= 0;				// count = 0
	TCNT0 	 = T0_PRELOAD;		
	TIFR 	&= ~(1<<TOV0);        // clear Timer Ovfl 
	TIMSK 	|= (1<<TOIE0);        	// enable T/C0 overflow interrupt
	bTxFlag 	|= TX_M_SEND;		// activate transmission
	while (bTxFlag & TX_M_SEND);		// activate transmission
}
// --------------------------------------------------------------------------------
// 
// --------------------------------------------------------------------------------
void _dump_one_byte(char bByte)
{
unsigned char bX;
unsigned char bH[2];
	bH[0] = bByte >> 4;
	bH[1] = bByte & 0x0f;
	for (bX = 0;bX < 2;bX++)
	{ 
		if (bH[bX] > 9)			bH[bX] += 55;
		else						bH[bX] += 48;
		_send_one_byte(bH[bX]);
	}
	_send_one_byte('.');
}
// --------------------------------------------------- 
//  M A I N 
// --------------------------------------------------- 
int main (void) 
{
char	bTxt[24] = "\r\nHello, World\r\n";
unsigned char bIx;
unsigned char bLn;
	DDRD 	&= ~(1<<DDD0);					// Port as Input	RX
	DDRD 	 =  (1<<DDD1);					// Port as Output	TX
	DDRD 	&= ~(1<<DDD2);					// Port as Input	INT0
	
	PORTD 	= 0; 				  	// Clear all
	PORTD 	|= Tx_M_BIT;           	// Clear (Line inactive)

	TCCR0 &= ~(1<<CS00); 			// Timer clock = system clock / 8
	TCCR0 |=  (1<<CS01); 			// Timer clock = system clock / 8
	TCCR0 &= ~(1<<CS02); 			// Timer clock = system clock / 8

	UCSRA = 0;
	UCSRB = 0;

	TIFR 	&= ~(1<<TOV0);       	// clear T/C0 overflow flag
	TIMSK 	|= (1<<TOIE0);     	// enable T/C0 overflow interrupt
	TCNT0 	 = T0_PRELOAD;		
	
// INT0 initialization ====================================
	GIFR 	&=  ~(1<<INTF0);   // clear Interrupt Flag
	GICR 	|= 1<<INT0;   		// enable external interrupt INT0
	
	MCUCR 	&= ~(1<<ISC00);   	// The falling edge of INT0 generates an interrupt request.
	MCUCR 	|=  (1<<ISC01);    // The falling edge of INT0 generates an interrupt request.


// ------------------------------------------------------------	
	sei(); 
// ------------------------------------------------------------	
	bLn = strlen(bTxt);
	for (bIx = 0;bIx < bLn; bIx++)
		_send_one_byte(bTxt[bIx]);	
	
	while (1) 
	{ 
		if 	(bTxFlag & RX_M_DATA)
		{
      		bTxFlag &= ~RX_M_DATA;   	// data acked
			_send_one_byte(bRxByte);	// echo
			GIFR &=  ~(1<<INTF0);   	// clear Interrupt Flag
			GICR |= 1<<INT0;   		// enable external interrupt INT0
		}
	} 
}
