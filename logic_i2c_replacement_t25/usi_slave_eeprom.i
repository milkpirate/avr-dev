# 1 "usi_slave_eeprom.c"
# 1 "<command-line>"
# 1 "usi_slave_eeprom.c"
# 16 "usi_slave_eeprom.c"
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 1 3
# 99 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\sfr_defs.h" 1 3
# 126 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\sfr_defs.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\inttypes.h" 1 3
# 37 "c:\\avr8-gnu-toolchain\\avr\\include\\inttypes.h" 3
# 1 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdint.h" 1 3 4
# 9 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdint.h" 3 4
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\stdint.h" 1 3 4
# 121 "c:\\avr8-gnu-toolchain\\avr\\include\\stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 142 "c:\\avr8-gnu-toolchain\\avr\\include\\stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 159 "c:\\avr8-gnu-toolchain\\avr\\include\\stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 213 "c:\\avr8-gnu-toolchain\\avr\\include\\stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 273 "c:\\avr8-gnu-toolchain\\avr\\include\\stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 10 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdint.h" 2 3 4
# 38 "c:\\avr8-gnu-toolchain\\avr\\include\\inttypes.h" 2 3
# 77 "c:\\avr8-gnu-toolchain\\avr\\include\\inttypes.h" 3
typedef int32_t int_farptr_t;



typedef uint32_t uint_farptr_t;
# 127 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\sfr_defs.h" 2 3
# 100 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3
# 416 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotn25.h" 1 3
# 38 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotn25.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotnx5.h" 1 3
# 39 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotn25.h" 2 3
# 417 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3
# 610 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\portpins.h" 1 3
# 611 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3

# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\common.h" 1 3
# 613 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3

# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\version.h" 1 3
# 615 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3






# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\fuse.h" 1 3
# 239 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
    unsigned char extended;
} __fuse_t;
# 622 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3


# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\lock.h" 1 3
# 625 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3
# 17 "usi_slave_eeprom.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\interrupt.h" 1 3
# 18 "usi_slave_eeprom.c" 2
# 1 "usi_slave_eeprom.h" 1
# 59 "usi_slave_eeprom.h"
# 1 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdbool.h" 1 3 4
# 60 "usi_slave_eeprom.h" 2




void usi_twi_slave_init(void);






volatile uint8_t rxbuffer[4];
volatile uint16_t buffer_adr;
# 19 "usi_slave_eeprom.c" 2
# 74 "usi_slave_eeprom.c"
typedef enum
{
    USI_SLAVE_CHECK_ADDRESS = 0x00,
    USI_SLAVE_SEND_DATA = 0x01,
    USI_SLAVE_REQUEST_REPLY_FROM_SEND_DATA = 0x02,
    USI_SLAVE_CHECK_REPLY_FROM_SEND_DATA = 0x03,
    USI_SLAVE_REQUEST_DATA = 0x04,
    USI_SLAVE_GET_DATA_AND_SEND_ACK = 0x05
} overflowState_t;




volatile overflowState_t overflowState;





void usi_twi_slave_init(void)
{
  __asm__ __volatile__ ("cli" ::: "memory");




  (*(volatile uint8_t *)((0x17) + 0x20)) |= ( 1 << 2 ) | ( 1 << 0 );
  (*(volatile uint8_t *)((0x18) + 0x20)) |= ( 1 << 2 ) | ( 1 << 0 );
  (*(volatile uint8_t *)((0x17) + 0x20)) &= ~( 1 << 0 );
  (*(volatile uint8_t *)((0x0D) + 0x20)) = ( 1 << 7 ) |
   ( 0 << 6 ) |
   ( 1 << 5 ) | ( 0 << 4 ) |
   ( 1 << 3 ) | ( 0 << 2 ) | ( 0 << 1 ) |
   ( 0 << 0 );
  (*(volatile uint8_t *)((0x0E) + 0x20)) = ( 1 << 7 ) | ( 1 << 6 ) | ( 1 << 5 ) | ( 1 << 4 );
  __asm__ __volatile__ ("sei" ::: "memory");
}



void __vector_13 (void) __attribute__ ((signal,used, externally_visible)) ; void __vector_13 (void)
{
    overflowState = USI_SLAVE_CHECK_ADDRESS;
    (*(volatile uint8_t *)((0x17) + 0x20)) &= ~( 1 << 0 );







    while ( ( (*(volatile uint8_t *)((0x16) + 0x20)) & ( 1 << 2 ) ) && !( ( (*(volatile uint8_t *)((0x16) + 0x20)) & ( 1 << 0 ) ) ));

    if ( !( (*(volatile uint8_t *)((0x16) + 0x20)) & ( 1 << 0 ) ) )
        (*(volatile uint8_t *)((0x0D) + 0x20)) =
            ( 1 << 7 ) |
            ( 1 << 6 ) |
            ( 1 << 5 ) | ( 1 << 4 ) |
            ( 1 << 3 ) | ( 0 << 2 ) | ( 0 << 1 ) |
            ( 0 << 0 );
    else
        (*(volatile uint8_t *)((0x0D) + 0x20)) =
            ( 1 << 7 ) |
            ( 0 << 6 ) |
            ( 1 << 5 ) | ( 0 << 4 ) |
            ( 1 << 3 ) | ( 0 << 2 ) | ( 0 << 1 ) |
            ( 0 << 0 );
    (*(volatile uint8_t *)((0x0E) + 0x20)) =
        ( 1 << 7 ) | ( 1 << 6 ) |
        ( 1 << 5 ) |( 1 << 4 ) |
        ( 0x0 << 0);
}



void __vector_14 (void) __attribute__ ((signal,used, externally_visible)) ; void __vector_14 (void)
{
    switch ( overflowState )
    {

    case USI_SLAVE_CHECK_ADDRESS:
        if ((*(volatile uint8_t *)((0x0F) + 0x20)) == 0 || ((*(volatile uint8_t *)((0x0F) + 0x20)) & ~1) == 0b10100000)
        {
            if ( (*(volatile uint8_t *)((0x0F) + 0x20)) & 0x01 ) overflowState = USI_SLAVE_SEND_DATA;
            else
            {
                overflowState = USI_SLAVE_REQUEST_DATA;
                buffer_adr=0xFFFF;
            }
            { (*(volatile uint8_t *)((0x0F) + 0x20)) = 0; (*(volatile uint8_t *)((0x17) + 0x20)) |= (1<<0); (*(volatile uint8_t *)((0x0E) + 0x20)) = (0<<7)|(1<<6 )|(1<<5)|(1<<4)|(0x0E<<0); };
        }
        else { (*(volatile uint8_t *)((0x0D) + 0x20)) = (1<<7)|(0<<6)|(1<<5)|(0<<4)|(1<<3)|(0<<2)|(0<<1)|(0<<0); (*(volatile uint8_t *)((0x0E) + 0x20)) = (0<<7)|(1<<6)|(1<<5)|(1<<4)|(0x0<<0); };
        break;





    case USI_SLAVE_CHECK_REPLY_FROM_SEND_DATA:
        if ( (*(volatile uint8_t *)((0x0F) + 0x20)) )
        {
            { (*(volatile uint8_t *)((0x0D) + 0x20)) = (1<<7)|(0<<6)|(1<<5)|(0<<4)|(1<<3)|(0<<2)|(0<<1)|(0<<0); (*(volatile uint8_t *)((0x0E) + 0x20)) = (0<<7)|(1<<6)|(1<<5)|(1<<4)|(0x0<<0); };
            return;
        }


    case USI_SLAVE_SEND_DATA:

        if (buffer_adr == 0xFFFF) buffer_adr=0;
        (*(volatile uint8_t *)((0x0F) + 0x20)) = get_rom_data(buffer_adr++);

        overflowState = USI_SLAVE_REQUEST_REPLY_FROM_SEND_DATA;
        { (*(volatile uint8_t *)((0x17) + 0x20)) |= (1<<0); (*(volatile uint8_t *)((0x0E) + 0x20)) = (0<<7)|(1<<6)|(1<<5)|(1<<4)|(0x0<<0); };
        break;



    case USI_SLAVE_REQUEST_REPLY_FROM_SEND_DATA:
        overflowState = USI_SLAVE_CHECK_REPLY_FROM_SEND_DATA;
        { (*(volatile uint8_t *)((0x0F) + 0x20)) = 0; (*(volatile uint8_t *)((0x17) + 0x20)) &= ~(1<<0); (*(volatile uint8_t *)((0x0E) + 0x20)) = (0<<7)|(1<<6)|(1<<5)|(1<<4)|(0x0E<<0); };
        break;





    case USI_SLAVE_REQUEST_DATA:
        overflowState = USI_SLAVE_GET_DATA_AND_SEND_ACK;
        { (*(volatile uint8_t *)((0x17) + 0x20)) &= ~(1<<0); (*(volatile uint8_t *)((0x0E) + 0x20)) = (0<<7)|(1<<6)|(1<<5)|(1<<4)|(0x0<<0); };
        break;



    case USI_SLAVE_GET_DATA_AND_SEND_ACK:

        if (buffer_adr == 0xFFFF) buffer_adr = (*(volatile uint8_t *)((0x0F) + 0x20)) % (255 +1);
# 222 "usi_slave_eeprom.c"
        else rxbuffer[buffer_adr++]=(*(volatile uint8_t *)((0x0F) + 0x20));






        overflowState = USI_SLAVE_REQUEST_DATA;
        { (*(volatile uint8_t *)((0x0F) + 0x20)) = 0; (*(volatile uint8_t *)((0x17) + 0x20)) |= (1<<0); (*(volatile uint8_t *)((0x0E) + 0x20)) = (0<<7)|(1<<6 )|(1<<5)|(1<<4)|(0x0E<<0); };
        break;


    }
}
