# 1 "USI_UART.c"
# 1 "<command-line>"
# 1 "USI_UART.c"
# 22 "USI_UART.c"
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
# 23 "USI_UART.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\pgmspace.h" 1 3
# 87 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\pgmspace.h" 3
# 1 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stddef.h" 1 3 4
# 212 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stddef.h" 3 4
typedef unsigned int size_t;
# 88 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\pgmspace.h" 2 3
# 1137 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\pgmspace.h" 3
extern const void * memchr_P(const void *, int __val, size_t __len) __attribute__((__const__));
extern int memcmp_P(const void *, const void *, size_t) __attribute__((__pure__));
extern void *memccpy_P(void *, const void *, int __val, size_t);
extern void *memcpy_P(void *, const void *, size_t);
extern void *memmem_P(const void *, size_t, const void *, size_t) __attribute__((__pure__));
extern const void * memrchr_P(const void *, int __val, size_t __len) __attribute__((__const__));
extern char *strcat_P(char *, const char *);
extern const char * strchr_P(const char *, int __val) __attribute__((__const__));
extern const char * strchrnul_P(const char *, int __val) __attribute__((__const__));
extern int strcmp_P(const char *, const char *) __attribute__((__pure__));
extern char *strcpy_P(char *, const char *);
extern int strcasecmp_P(const char *, const char *) __attribute__((__pure__));
extern char *strcasestr_P(const char *, const char *) __attribute__((__pure__));
extern size_t strcspn_P(const char *__s, const char * __reject) __attribute__((__pure__));
extern size_t strlcat_P (char *, const char *, size_t );
extern size_t strlcpy_P (char *, const char *, size_t );
extern size_t __strlen_P(const char *) __attribute__((__const__));
extern size_t strnlen_P(const char *, size_t) __attribute__((__const__));
extern int strncmp_P(const char *, const char *, size_t) __attribute__((__pure__));
extern int strncasecmp_P(const char *, const char *, size_t) __attribute__((__pure__));
extern char *strncat_P(char *, const char *, size_t);
extern char *strncpy_P(char *, const char *, size_t);
extern char *strpbrk_P(const char *__s, const char * __accept) __attribute__((__pure__));
extern const char * strrchr_P(const char *, int __val) __attribute__((__const__));
extern char *strsep_P(char **__sp, const char * __delim);
extern size_t strspn_P(const char *__s, const char * __accept) __attribute__((__pure__));
extern char *strstr_P(const char *, const char *) __attribute__((__pure__));
extern char *strtok_P(char *__s, const char * __delim);
extern char *strtok_rP(char *__s, const char * __delim, char **__last);

extern size_t strlen_PF (uint_farptr_t src) __attribute__((__const__));
extern size_t strnlen_PF (uint_farptr_t src, size_t len) __attribute__((__const__));
extern void *memcpy_PF (void *dest, uint_farptr_t src, size_t len);
extern char *strcpy_PF (char *dest, uint_farptr_t src);
extern char *strncpy_PF (char *dest, uint_farptr_t src, size_t len);
extern char *strcat_PF (char *dest, uint_farptr_t src);
extern size_t strlcat_PF (char *dst, uint_farptr_t src, size_t siz);
extern char *strncat_PF (char *dest, uint_farptr_t src, size_t len);
extern int strcmp_PF (const char *s1, uint_farptr_t s2) __attribute__((__pure__));
extern int strncmp_PF (const char *s1, uint_farptr_t s2, size_t n) __attribute__((__pure__));
extern int strcasecmp_PF (const char *s1, uint_farptr_t s2) __attribute__((__pure__));
extern int strncasecmp_PF (const char *s1, uint_farptr_t s2, size_t n) __attribute__((__pure__));
extern char *strstr_PF (const char *s1, uint_farptr_t s2);
extern size_t strlcpy_PF (char *dst, uint_farptr_t src, size_t siz);
extern int memcmp_PF(const void *, uint_farptr_t, size_t) __attribute__((__pure__));


__attribute__((__always_inline__)) static inline size_t strlen_P(const char * s);
static inline size_t strlen_P(const char *s) {
  return __builtin_constant_p(__builtin_strlen(s))
     ? __builtin_strlen(s) : __strlen_P(s);
}
# 24 "USI_UART.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\interrupt.h" 1 3
# 25 "USI_UART.c" 2


# 1 "USI_UART_config.h" 1
# 46 "USI_UART_config.h"
uint8_t reverse_byte( uint8_t );
void usi_uart_init_rx( void );
void usi_uart_init_tx( void );
void usi_uart_tx_byte( uint8_t );


void usi_uart_tx_str(char str[]);
void usi_uart_tx_str_P(const char str[]);
# 28 "USI_UART.c" 2
# 65 "USI_UART.c"
static volatile uint8_t usi_uart_tx_data;



static uint8_t uart_tx_buff[16];
static volatile uint8_t uart_tx_head = 0;
static volatile uint8_t uart_tx_tail = 0;

static volatile union USI_UART_status
{
    uint8_t status;
    struct
    {
        uint8_t ongoing_tx_from_buff:1;
        uint8_t ongoing_tx_pkg:1;
        uint8_t ongoing_rx_pkg:1;
        uint8_t rx_buff_ovf:1;
        uint8_t flag4:1;
        uint8_t flag5:1;
        uint8_t flag6:1;
        uint8_t flag7:1;
    };
} USI_UART_status = {0};





uint8_t reverse_byte( uint8_t val )
{
    uint8_t res;
 asm volatile(
        "ldi %0, 0x80" "\n\t"
        "reverse_byte_loop_%=:" "\n\t"
        "rol %1" "\n\t"
        "ror %0" "\n\t"
        "brcc reverse_byte_loop_%=" "\n\t"
        : "=&a" (res), "=r" (val)
    );
    return res;
}



void usi_uart_init_tx( void )
{
    __asm__ __volatile__ ("cli" ::: "memory");
    (*(volatile uint8_t *)((0x32) + 0x20)) = 0x00;

 (*(volatile uint8_t *)((0x2C) + 0x20)) |= (1<<0);
    (*(volatile uint8_t *)((0x33) + 0x20)) = (0<<2)|(0<<1)|(1<<0);
    (*(volatile uint8_t *)((0x38) + 0x20)) = (1<<1);
    (*(volatile uint8_t *)((0x39) + 0x20)) |= (1<<1);

    (*(volatile uint8_t *)((0x0D) + 0x20)) = (0<<7)|(1<<6)|
             (0<<5)|(1<<4)|
             (0<<3)|(1<<2)|(0<<1)|
             (0<<0);

    (*(volatile uint8_t *)((0x0F) + 0x20)) = 0xFF;
    (*(volatile uint8_t *)((0x0E) + 0x20)) = 0xF0 |
             0x0F;
    (*(volatile uint8_t *)((0x17) + 0x20)) |= (1<<1);

    USI_UART_status.ongoing_tx_from_buff = 1;
    __asm__ __volatile__ ("sei" ::: "memory");
}
# 149 "USI_UART.c"
void usi_uart_tx_byte( uint8_t data )
{
    uint8_t tmphead;

    tmphead = ( uart_tx_head + 1 ) & ( 16 - 1 );
    while ( tmphead == uart_tx_tail );
    uart_tx_buff[tmphead] = reverse_byte(data);
    uart_tx_head = tmphead;

    if ( !USI_UART_status.ongoing_tx_from_buff )
    {

        usi_uart_init_tx();
    }
}
# 185 "USI_UART.c"
void usi_uart_tx_str(char str[])
{
 while(*str) usi_uart_tx_byte(*str++);
}


void usi_uart_tx_str_P(const char str[])
{
    while((__extension__({ uint16_t __addr16 = (uint16_t)((uint16_t)(str)); uint8_t __result; __asm__ __volatile__ ( "lpm %0, Z" "\n\t" : "=r" (__result) : "z" (__addr16) ); __result; }))) usi_uart_tx_byte((__extension__({ uint16_t __addr16 = (uint16_t)((uint16_t)(str++)); uint8_t __result; __asm__ __volatile__ ( "lpm %0, Z" "\n\t" : "=r" (__result) : "z" (__addr16) ); __result; })));
}
# 228 "USI_UART.c"
void __vector_14 (void) __attribute__ ((signal,used, externally_visible)) ; void __vector_14 (void)
{
    uint8_t tmptail;
# 239 "USI_UART.c"
        if( USI_UART_status.ongoing_tx_pkg )
        {
            USI_UART_status.ongoing_tx_pkg = 0;

            (*(volatile uint8_t *)((0x0E) + 0x20)) = 0xF0 | ((16 - 5));
            (*(volatile uint8_t *)((0x0F) + 0x20)) = (usi_uart_tx_data << 3) | 0x07;
        }

        else
        {

            if ( uart_tx_head != uart_tx_tail )
            {
                USI_UART_status.ongoing_tx_pkg = 1;

                tmptail = ( uart_tx_tail + 1 ) & ( 16 - 1 );
                uart_tx_tail = tmptail;
                usi_uart_tx_data = uart_tx_buff[tmptail];

                (*(volatile uint8_t *)((0x0E) + 0x20)) = 0xF0 | ((16 - 5));
                (*(volatile uint8_t *)((0x0F) + 0x20)) = (usi_uart_tx_data >> 2) | 0x80;

            }


            else
            {
                USI_UART_status.ongoing_tx_from_buff = 0;

                (*(volatile uint8_t *)((0x33) + 0x20)) = (0<<2)|(0<<1)|(0<<0);
                (*(volatile uint8_t *)((0x18) + 0x20)) |= (1<<3)|(1<<2)|(1<<1)|(1<<0);
                (*(volatile uint8_t *)((0x17) + 0x20)) &= ~((1<<3)|(1<<2)|(1<<1)|(1<<0));
                (*(volatile uint8_t *)((0x0D) + 0x20)) = 0;
                (*(volatile uint8_t *)((0x3A) + 0x20)) = (1<<5);
                (*(volatile uint8_t *)((0x3B) + 0x20)) |= (1<<5);
            }
        }
# 304 "USI_UART.c"
}


void __vector_5 (void) __attribute__ ((signal,used, externally_visible)) ; void __vector_5 (void)
{
    (*(volatile uint8_t *)((0x32) + 0x20)) += (256 - ( (11059200 / 115200) / 1 ));

}
