//=====================================================
//		my own library
//=====================================================
#ifndef FLAG_REGISTER_H_INCLUDED
#define FLAG_REGISTER_H_INCLUDED

//=====================================================
//		defines
//=====================================================
#define	MAP_ACCURENCY		int16_t
#define enable_interrupt()	sei()
#define disable_interrupt()	cli()

//=====================================================
//		flag byte
//=====================================================


//=====================================================
//		function defines
//=====================================================
#define swap_nibbles(x)	(asm volatile("swap %0" : "=r" (x) : "0" (x)))
#define swap_bytes(x)	__builtin_bswap16(x)

//=====================================================
//		function prototypes
//=====================================================

/** Re-maps a number from one range to another. That is, a value
 *  of fromLow would get mapped to toLow, a value of fromHigh to
 *  toHigh, values in-between to values in-between, etc.
 *
 * paramters:
 *	x		- input values
 *	in_min	- input range minimum
 *	in_max	- input range maximum
 *	out_min	- output range minimum
 *	out_max	- output range maximum
 *
 * return:
 *	proportionally mapped values
 *
 */
MAP_ACCURENCY map(MAP_ACCURENCY x, MAP_ACCURENCY in_min, MAP_ACCURENCY in_max, MAP_ACCURENCY out_min, MAP_ACCURENCY out_max);

/** Reverses the bit order in byte. MSB -> LSB and vice versa.
 *
 * parameter:
 * 	x	- one byte
 *
 * return:
 *	bit order reversed byte
 *
 */
uint8_t reverse_byte(uint8_t x);

#endif // FLAG_REGISTER_H_INCLUDED

