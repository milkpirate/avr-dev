#include <avr/io.h>

FUSES = {
    .low = 0xE2,
    .high = 0xDF,
    .extended = EFUSE_DEFAULT
};
