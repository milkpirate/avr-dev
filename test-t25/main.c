// device
// attiny25

// includes
#include <avr/io.h>
#include <avr/sleep.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>

typedef union {
  struct {
    uint8_t b0:1, b1:1, b2:1, b3:1, b4:1, b5:1, b6:1, b7:1;
  };
  uint8_t byte;
} bits_t;

struct bits {
  uint8_t b0:1, b1:1, b2:1, b3:1, b4:1, b5:1, b6:1, b7:1;
} __attribute__((__packed__));

// http://www.avrfreaks.net/forum/solved-how-bind-writeable-bitfield-io-register

//*(volatile uint16_t *)0x422581A4
#define flag			(*(volatile uint8_t		*)_SFR_MEM_ADDR(GPIOR0))
#define flag_bits_t		(*(volatile bits_t		*)_SFR_MEM_ADDR(GPIOR0))
#define flag_bits		(*(volatile struct bits	*)_SFR_MEM_ADDR(GPIOR0))
#define flags 			(*((volatile uint8_t	*)((void*)(&GPIOR1))))

#define flags_bit2  (((volatile struct bits*)&flag_bits)->b2)
#define flags_bit3  (((volatile struct bits*)&flag_bits)->b3)
#define flags_bit4  (((volatile struct bits*)&flag_bits)->b4)

int main(void)
{
	flag |= (1<<4);

	flag_bits_t.b3 = 1;
	//flag_bits_t += 5;

	flag_bits.b5 = 1;
	//flag_bits += 5;

	flags = 5;
	flags |= (1<<5);

	flags_bit4 = 1;

    while(1)
    {
		flag = ~flag;
		PORTB = flag;
    }
}
