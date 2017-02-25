#ifndef SPMCSR
#define SPMCSR SPMCR
#endif

void read_fuses(void)
{
    SPMCSR = 1<<BLBSET | 1<<SPMEN;
    uint8_t lo = pgm_read_byte(0);
    SPMCSR = 1<<BLBSET | 1<<SPMEN;
    uint8_t hi = pgm_read_byte(3);
    PRINTF("Fuses: low=%02X high=%02X\n", lo, hi);
}