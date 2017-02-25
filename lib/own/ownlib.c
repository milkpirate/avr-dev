//=====================================================
//		includes
//=====================================================
#include <stdint.h>
#include <own/ownlib.h>
#include <avr/interrupt.h>

//=====================================================
//		map intervals to each other
//=====================================================
MAP_ACCURENCY map(MAP_ACCURENCY x, MAP_ACCURENCY in_min, MAP_ACCURENCY in_max, MAP_ACCURENCY out_min, MAP_ACCURENCY out_max)
{
	return ( (x - in_min) * (out_max - out_min) ) / (in_max - in_min) + out_min;
}

//=====================================================
//		reverse bits in byte (MSB->LSB)
//=====================================================
uint8_t reverse_byte(uint8_t x)
{
	/*
    x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
    x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
    x = ((x >> 4) & 0x0f) | ((x << 4) & 0xf0);
    return x;
    */
    uint8_t res;
	asm volatile(
        "ldi %0, 0x80"				"\n\t"
        "reverse_byte_loop_%=:"		"\n\t"
        "rol %1"					"\n\t"
        "ror %0"					"\n\t"
        "brcc reverse_byte_loop_%="	"\n\t"
        : "=&a" (res), "=r" (x)
    );
    return res;
}
