# 1 "lcd\\lcd_routines.c"
# 1 "<command-line>"
# 1 "lcd\\lcd_routines.c"






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
# 434 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotn84.h" 1 3
# 38 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotn84.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotnx4.h" 1 3
# 39 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\iotn84.h" 2 3
# 435 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\io.h" 2 3
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
# 8 "lcd\\lcd_routines.c" 2
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
# 9 "lcd\\lcd_routines.c" 2
# 1 "lcd\\lcd_routines.h" 1
# 60 "lcd\\lcd_routines.h"
void lcd_init( void );



void lcd_clear( void );



void lcd_home( void );



void lcd_setcursor( uint8_t spalte, uint8_t zeile );



void lcd_data( uint8_t data );



void lcd_string( const char *data );



void lcd_string_P(const char str[]);





void lcd_generatechar( uint8_t code, const uint8_t *data );





void lcd_generatechar_P( uint8_t code, const uint8_t data[]);



void lcd_command( uint8_t data );
# 10 "lcd\\lcd_routines.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 1 3
# 43 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay_basic.h" 1 3
# 40 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay_basic.h" 3
static inline void _delay_loop_1(uint8_t __count) __attribute__((always_inline));
static inline void _delay_loop_2(uint16_t __count) __attribute__((always_inline));
# 80 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay_basic.h" 3
void
_delay_loop_1(uint8_t __count)
{
 __asm__ volatile (
  "1: dec %0" "\n\t"
  "brne 1b"
  : "=r" (__count)
  : "0" (__count)
 );
}
# 102 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay_basic.h" 3
void
_delay_loop_2(uint16_t __count)
{
 __asm__ volatile (
  "1: sbiw %0,1" "\n\t"
  "brne 1b"
  : "=w" (__count)
  : "0" (__count)
 );
}
# 44 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 2 3
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 1 3
# 127 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern double cos(double __x) __attribute__((__const__));





extern double sin(double __x) __attribute__((__const__));





extern double tan(double __x) __attribute__((__const__));






extern double fabs(double __x) __attribute__((__const__));






extern double fmod(double __x, double __y) __attribute__((__const__));
# 168 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern double modf(double __x, double *__iptr);



extern float modff (float __x, float *__iptr);




extern double sqrt(double __x) __attribute__((__const__));





extern double cbrt(double __x) __attribute__((__const__));
# 194 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern double hypot (double __x, double __y) __attribute__((__const__));







extern double square(double __x) __attribute__((__const__));






extern double floor(double __x) __attribute__((__const__));






extern double ceil(double __x) __attribute__((__const__));
# 234 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern double frexp(double __x, int *__pexp);







extern double ldexp(double __x, int __exp) __attribute__((__const__));





extern double exp(double __x) __attribute__((__const__));





extern double cosh(double __x) __attribute__((__const__));





extern double sinh(double __x) __attribute__((__const__));





extern double tanh(double __x) __attribute__((__const__));







extern double acos(double __x) __attribute__((__const__));







extern double asin(double __x) __attribute__((__const__));






extern double atan(double __x) __attribute__((__const__));
# 298 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern double atan2(double __y, double __x) __attribute__((__const__));





extern double log(double __x) __attribute__((__const__));





extern double log10(double __x) __attribute__((__const__));





extern double pow(double __x, double __y) __attribute__((__const__));






extern int isnan(double __x) __attribute__((__const__));
# 333 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern int isinf(double __x) __attribute__((__const__));






__attribute__((__const__)) static inline int isfinite (double __x)
{
    unsigned char __exp;
    __asm__ (
 "mov	%0, %C1		\n\t"
 "lsl	%0		\n\t"
 "mov	%0, %D1		\n\t"
 "rol	%0		"
 : "=r" (__exp)
 : "r" (__x) );
    return __exp != 0xff;
}






__attribute__((__const__)) static inline double copysign (double __x, double __y)
{
    __asm__ (
 "bst	%D2, 7	\n\t"
 "bld	%D0, 7	"
 : "=r" (__x)
 : "0" (__x), "r" (__y) );
    return __x;
}
# 376 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern int signbit (double __x) __attribute__((__const__));






extern double fdim (double __x, double __y) __attribute__((__const__));
# 392 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern double fma (double __x, double __y, double __z) __attribute__((__const__));







extern double fmax (double __x, double __y) __attribute__((__const__));







extern double fmin (double __x, double __y) __attribute__((__const__));






extern double trunc (double __x) __attribute__((__const__));
# 426 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern double round (double __x) __attribute__((__const__));
# 439 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern long lround (double __x) __attribute__((__const__));
# 453 "c:\\avr8-gnu-toolchain\\avr\\include\\math.h" 3
extern long lrint (double __x) __attribute__((__const__));
# 45 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 2 3
# 84 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
static inline void _delay_us(double __us) __attribute__((always_inline));
static inline void _delay_ms(double __ms) __attribute__((always_inline));
# 141 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
void
_delay_ms(double __ms)
{
 double __tmp ;



 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(unsigned long);
 __tmp = ((3686400) / 1e3) * __ms;
# 160 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
  __ticks_dc = (uint32_t)(ceil(fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 186 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
}
# 223 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
void
_delay_us(double __us)
{
 double __tmp ;



 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(unsigned long);
 __tmp = ((3686400) / 1e6) * __us;
# 242 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
  __ticks_dc = (uint32_t)(ceil(fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 268 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
}
# 11 "lcd\\lcd_routines.c" 2



static void lcd_enable( void )
{
    (*(volatile uint8_t *)((0x18) + 0x20)) |= (1<<1);
    _delay_us( 20 );
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1<<1);
}



static void lcd_out( uint8_t data )
{
    data &= 0xF0;

    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~(0xF0>>(4-2));
    (*(volatile uint8_t *)((0x1B) + 0x20)) |= (data>>(4-2));
    lcd_enable();
}



void lcd_init( void )
{

    uint8_t pins = (0x0F << 2);
    (*(volatile uint8_t *)((0x1A) + 0x20)) |= pins;
    (*(volatile uint8_t *)((0x1B) + 0x20)) &= ~pins;

    pins = (1<<0) |
   (1<<1);
 (*(volatile uint8_t *)((0x17) + 0x20)) |= pins;
 (*(volatile uint8_t *)((0x18) + 0x20)) &= ~pins;





    _delay_ms( 15 );


    lcd_out( 0x30 );
    _delay_ms( 5 );

    lcd_enable();
    _delay_ms( 1 );

    lcd_enable();
    _delay_ms( 1 );


    lcd_out( 0x20 |
             0x00 );
    _delay_ms( 5 );


    lcd_command( 0x20 |
                 0x00 |
                 0x08 |
                 0x00 );


    lcd_command( 0x08 |
                 0x04 |
                 0x00 |
                 0x00);


    lcd_command( 0x04 |
                 0x02 |
                 0x00 );

    lcd_clear();
}



void lcd_data( uint8_t data )
{
    (*(volatile uint8_t *)((0x18) + 0x20)) |= (1<<0);

    lcd_out( data );
    lcd_out( data<<4 );

    _delay_us( 46 );
}



void lcd_command( uint8_t data )
{
    (*(volatile uint8_t *)((0x18) + 0x20)) &= ~(1<<0);

    lcd_out( data );
    lcd_out( data<<4 );

    _delay_us( 42 );
}



void lcd_clear( void )
{
    lcd_command( 0x01 );
    _delay_ms( 2 );
}



void lcd_home( void )
{
    lcd_command( 0x02 );
    _delay_ms( 2 );
}




void lcd_setcursor( uint8_t x, uint8_t y )
{
    lcd_command(0x80 +y*0x40 +x);
}




void lcd_string( const char *data )
{
    while( *data != '\0' ) lcd_data( *data++ );
}




void lcd_string_P(const char str[])
{
    while((__extension__({ uint16_t __addr16 = (uint16_t)((uint16_t)(str)); uint8_t __result; __asm__ __volatile__ ( "lpm %0, Z" "\n\t" : "=r" (__result) : "z" (__addr16) ); __result; }))) lcd_data((__extension__({ uint16_t __addr16 = (uint16_t)((uint16_t)(str++)); uint8_t __result; __asm__ __volatile__ ( "lpm %0, Z" "\n\t" : "=r" (__result) : "z" (__addr16) ); __result; })));
}




void lcd_generatechar( uint8_t code, const uint8_t *data )
{

    lcd_command( 0x40 | (code<<3) );

    for ( uint8_t i=0; i<8; i++ ) lcd_data( data[i] );
}




void lcd_generatechar_P( uint8_t code, const uint8_t data[])
{

    lcd_command( 0x40 | (code<<3) );

    for ( uint8_t i=0; i<8; i++ ) lcd_data((__extension__({ uint16_t __addr16 = (uint16_t)((uint16_t)(data++)); uint8_t __result; __asm__ __volatile__ ( "lpm %0, Z" "\n\t" : "=r" (__result) : "z" (__addr16) ); __result; })));
}
