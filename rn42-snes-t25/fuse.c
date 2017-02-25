#include <avr/io.h>

FUSES = {
    .low = 0xE2,
    .high = 0xDF,
    .extended = EFUSE_DEFAULT
};

/*	Fuses:
 MHz	| Type	| LOW  | HIGH
------------------------------
 10.0	| ext.	| 0xFF | 0xDF
  8.0	| int.	| 0xE2 | 0xDF	*/
