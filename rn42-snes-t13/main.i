# 1 "main.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "main.c"
# 32 "main.c"
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 1 3
# 99 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\sfr_defs.h" 1 3
# 126 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\sfr_defs.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\inttypes.h" 1 3
# 37 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\inttypes.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stdint.h" 1 3 4
# 9 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stdint.h" 3 4
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\stdint.h" 1 3 4
# 125 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\stdint.h" 3 4

# 125 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 10 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stdint.h" 2 3 4
# 38 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\inttypes.h" 2 3
# 77 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\inttypes.h" 3
typedef int32_t int_farptr_t;



typedef uint32_t uint_farptr_t;
# 127 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\sfr_defs.h" 2 3
# 100 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 2 3
# 384 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\iotn13.h" 1 3
# 377 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\iotn13.h" 3
       
# 378 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\iotn13.h" 3

       
       
       
       
       
       
       
       
       
# 385 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 2 3
# 585 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\portpins.h" 1 3
# 586 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 2 3

# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\common.h" 1 3
# 588 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 2 3

# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\version.h" 1 3
# 590 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 2 3






# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\fuse.h" 1 3
# 248 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
} __fuse_t;
# 597 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 2 3


# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\lock.h" 1 3
# 600 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\io.h" 2 3
# 33 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\eeprom.h" 1 3
# 50 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\eeprom.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stddef.h" 1 3 4
# 149 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stddef.h" 3 4
typedef int ptrdiff_t;
# 216 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stddef.h" 3 4
typedef unsigned int size_t;
# 328 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stddef.h" 3 4
typedef int wchar_t;
# 51 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\eeprom.h" 2 3
# 137 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\eeprom.h" 3
uint8_t eeprom_read_byte (const uint8_t *__p) __attribute__((__pure__));




uint16_t eeprom_read_word (const uint16_t *__p) __attribute__((__pure__));




uint32_t eeprom_read_dword (const uint32_t *__p) __attribute__((__pure__));




float eeprom_read_float (const float *__p) __attribute__((__pure__));





void eeprom_read_block (void *__dst, const void *__src, size_t __n);





void eeprom_write_byte (uint8_t *__p, uint8_t __value);




void eeprom_write_word (uint16_t *__p, uint16_t __value);




void eeprom_write_dword (uint32_t *__p, uint32_t __value);




void eeprom_write_float (float *__p, float __value);





void eeprom_write_block (const void *__src, void *__dst, size_t __n);





void eeprom_update_byte (uint8_t *__p, uint8_t __value);




void eeprom_update_word (uint16_t *__p, uint16_t __value);




void eeprom_update_dword (uint32_t *__p, uint32_t __value);




void eeprom_update_float (float *__p, float __value);





void eeprom_update_block (const void *__src, void *__dst, size_t __n);
# 34 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 1 3
# 89 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\lib\\gcc\\avr\\6.1.0\\include\\stddef.h" 1 3 4
# 90 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 2 3
# 1085 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern const void * memchr_P(const void *, int __val, size_t __len) __attribute__((__const__));
# 1099 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int memcmp_P(const void *, const void *, size_t) __attribute__((__pure__));






extern void *memccpy_P(void *, const void *, int __val, size_t);
# 1115 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern void *memcpy_P(void *, const void *, size_t);






extern void *memmem_P(const void *, size_t, const void *, size_t) __attribute__((__pure__));
# 1134 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern const void * memrchr_P(const void *, int __val, size_t __len) __attribute__((__const__));
# 1144 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strcat_P(char *, const char *);
# 1160 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern const char * strchr_P(const char *, int __val) __attribute__((__const__));
# 1172 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern const char * strchrnul_P(const char *, int __val) __attribute__((__const__));
# 1185 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strcmp_P(const char *, const char *) __attribute__((__pure__));
# 1195 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strcpy_P(char *, const char *);
# 1212 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strcasecmp_P(const char *, const char *) __attribute__((__pure__));






extern char *strcasestr_P(const char *, const char *) __attribute__((__pure__));
# 1232 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strcspn_P(const char *__s, const char * __reject) __attribute__((__pure__));
# 1248 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strlcat_P (char *, const char *, size_t );
# 1261 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strlcpy_P (char *, const char *, size_t );
# 1273 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strnlen_P(const char *, size_t) __attribute__((__const__));
# 1284 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strncmp_P(const char *, const char *, size_t) __attribute__((__pure__));
# 1303 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strncasecmp_P(const char *, const char *, size_t) __attribute__((__pure__));
# 1314 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strncat_P(char *, const char *, size_t);
# 1328 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strncpy_P(char *, const char *, size_t);
# 1343 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strpbrk_P(const char *__s, const char * __accept) __attribute__((__pure__));
# 1354 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern const char * strrchr_P(const char *, int __val) __attribute__((__const__));
# 1374 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strsep_P(char **__sp, const char * __delim);
# 1387 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strspn_P(const char *__s, const char * __accept) __attribute__((__pure__));
# 1401 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strstr_P(const char *, const char *) __attribute__((__pure__));
# 1423 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strtok_P(char *__s, const char * __delim);
# 1443 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strtok_rP(char *__s, const char * __delim, char **__last);
# 1456 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strlen_PF(uint_farptr_t src) __attribute__((__const__));
# 1472 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strnlen_PF(uint_farptr_t src, size_t len) __attribute__((__const__));
# 1487 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern void *memcpy_PF(void *dest, uint_farptr_t src, size_t len);
# 1502 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strcpy_PF(char *dest, uint_farptr_t src);
# 1522 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strncpy_PF(char *dest, uint_farptr_t src, size_t len);
# 1538 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strcat_PF(char *dest, uint_farptr_t src);
# 1559 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strlcat_PF(char *dst, uint_farptr_t src, size_t siz);
# 1576 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strncat_PF(char *dest, uint_farptr_t src, size_t len);
# 1592 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strcmp_PF(const char *s1, uint_farptr_t s2) __attribute__((__pure__));
# 1609 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strncmp_PF(const char *s1, uint_farptr_t s2, size_t n) __attribute__((__pure__));
# 1625 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strcasecmp_PF(const char *s1, uint_farptr_t s2) __attribute__((__pure__));
# 1643 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int strncasecmp_PF(const char *s1, uint_farptr_t s2, size_t n) __attribute__((__pure__));
# 1659 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern char *strstr_PF(const char *s1, uint_farptr_t s2);
# 1671 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t strlcpy_PF(char *dst, uint_farptr_t src, size_t siz);
# 1687 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern int memcmp_PF(const void *, uint_farptr_t, size_t) __attribute__((__pure__));
# 1706 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\pgmspace.h" 3
extern size_t __strlen_P(const char *) __attribute__((__const__));
__attribute__((__always_inline__)) static __inline__ size_t strlen_P(const char * s);
static __inline__ size_t strlen_P(const char *s) {
  return __builtin_constant_p(__builtin_strlen(s))
     ? __builtin_strlen(s) : __strlen_P(s);
}
# 35 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\avr\\interrupt.h" 1 3
# 36 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 1 3
# 45 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay_basic.h" 1 3
# 40 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay_basic.h" 3
static __inline__ void _delay_loop_1(uint8_t __count) __attribute__((__always_inline__));
static __inline__ void _delay_loop_2(uint16_t __count) __attribute__((__always_inline__));
# 80 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay_basic.h" 3
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
# 102 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay_basic.h" 3
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
# 46 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 2 3
# 1 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 1 3
# 127 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern double cos(double __x) __attribute__((__const__));





extern double sin(double __x) __attribute__((__const__));





extern double tan(double __x) __attribute__((__const__));






extern double fabs(double __x) __attribute__((__const__));






extern double fmod(double __x, double __y) __attribute__((__const__));
# 168 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern double modf(double __x, double *__iptr);


extern float modff (float __x, float *__iptr);




extern double sqrt(double __x) __attribute__((__const__));


extern float sqrtf (float) __attribute__((__const__));




extern double cbrt(double __x) __attribute__((__const__));
# 195 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern double hypot (double __x, double __y) __attribute__((__const__));







extern double square(double __x) __attribute__((__const__));






extern double floor(double __x) __attribute__((__const__));






extern double ceil(double __x) __attribute__((__const__));
# 235 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern double frexp(double __x, int *__pexp);







extern double ldexp(double __x, int __exp) __attribute__((__const__));





extern double exp(double __x) __attribute__((__const__));





extern double cosh(double __x) __attribute__((__const__));





extern double sinh(double __x) __attribute__((__const__));





extern double tanh(double __x) __attribute__((__const__));







extern double acos(double __x) __attribute__((__const__));







extern double asin(double __x) __attribute__((__const__));






extern double atan(double __x) __attribute__((__const__));
# 299 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern double atan2(double __y, double __x) __attribute__((__const__));





extern double log(double __x) __attribute__((__const__));





extern double log10(double __x) __attribute__((__const__));





extern double pow(double __x, double __y) __attribute__((__const__));






extern int isnan(double __x) __attribute__((__const__));
# 334 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
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
# 377 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern int signbit (double __x) __attribute__((__const__));






extern double fdim (double __x, double __y) __attribute__((__const__));
# 393 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern double fma (double __x, double __y, double __z) __attribute__((__const__));







extern double fmax (double __x, double __y) __attribute__((__const__));







extern double fmin (double __x, double __y) __attribute__((__const__));






extern double trunc (double __x) __attribute__((__const__));
# 427 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern double round (double __x) __attribute__((__const__));
# 440 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern long lround (double __x) __attribute__((__const__));
# 454 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\math.h" 3
extern long lrint (double __x) __attribute__((__const__));
# 47 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 2 3
# 86 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
static __inline__ void _delay_us(double __us) __attribute__((__always_inline__));
static __inline__ void _delay_ms(double __ms) __attribute__((__always_inline__));
# 165 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
void
_delay_ms(double __ms)
{
 double __tmp ;



 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(unsigned long);
 __tmp = ((
# 174 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h"
          9600000UL
# 174 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
               ) / 1e3) * __ms;
# 184 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
  __ticks_dc = (uint32_t)(ceil(fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 210 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
}
# 254 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
void
_delay_us(double __us)
{
 double __tmp ;



 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(unsigned long);
 __tmp = ((
# 263 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h"
          9600000UL
# 263 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
               ) / 1e6) * __us;
# 273 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
  __ticks_dc = (uint32_t)(ceil(fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 299 "c:\\avr8-gnu-toolchain\\avr-gcc-6.1.0\\avr\\include\\util\\delay.h" 3
}
# 37 "main.c" 2
# 71 "main.c"

# 71 "main.c"
volatile uint16_t outframe;






static void delay_ms(volatile uint16_t ms);
static void send_hid_report(uint16_t read_btns, uint8_t config);
static void uart_tx_char(char c);
static void uart_tx_str_P(const char *str);
static void init_ports(void);
static void init_uart(void);
static void init_rn42(uint8_t config);
static uint8_t init_ee_config(uint16_t read_buttons);
static uint16_t check_buttons(void);

int main(void)
{
 init_uart();
    init_ports();

    uint16_t read_btns_old = 0xFFFF;
    uint16_t read_btns = check_buttons();
    uint8_t gamepad = init_ee_config(read_btns);

    init_rn42(gamepad);

    while(1)
    {
        read_btns = check_buttons();
  if (read_btns_old != read_btns) send_hid_report(read_btns, gamepad);
  read_btns_old = read_btns;
 }
}

void send_hid_report(uint16_t read_buttons, uint8_t gamepad)
{
    if(gamepad != 0)
    {


        uart_tx_char(0xFD);
        uart_tx_char(0x06);

        int8_t tmp = 0;
  if((uint8_t)read_buttons & 0b00010000) tmp = 126;
  if((uint8_t)read_buttons & 0b00100000) tmp = -127;
        uart_tx_char(tmp);

        tmp = 0;
  if((uint8_t)read_buttons & 0b01000000) tmp = 127;
  if((uint8_t)read_buttons & 0b10000000) tmp = -127;
        uart_tx_char(tmp);

        uart_tx_char(0x00);
        uart_tx_char(0x00);


        tmp = (uint8_t)(read_buttons >> 4);
        tmp &= 0xF0;
        tmp |= (uint8_t)(read_buttons & 0x0F);
        uart_tx_char(tmp);
        uart_tx_char(0x00);
    }
    else
    {

        static char keys[6] = {0x00,0x00,0x00,0x00,0x00,0x00};


  for(uint8_t i=0; i<sizeof(keys); i++)
  {
   if(keys[i] != 0x00)
   {
    uint16_t mask = keys[i] - (0x04);
    mask = (1<<mask);
    if(read_buttons & mask) read_buttons &= ~mask;
    else keys[i] = 0x00;
   }
  }


  for(uint8_t i=0; i<12; i++)
  {
   if(read_buttons & (1<<i))
   {
    for(uint8_t j=0; j<sizeof(keys); j++)
    {
     if(keys[j] == 0x00)
     {
      keys[j] = (0x04) + i;
      break;
     }
    }
   }
  }


  uart_tx_char(0xFD);
        uart_tx_char(0x09);
  uart_tx_char(0x01);
  uart_tx_char(0x00);
  uart_tx_char(0x00);

  for(uint8_t i=0; i<6; i++) uart_tx_char(keys[i]);
    }
}

uint16_t check_buttons(void)
{
 uint16_t read_buttons = 0;
 uint16_t old_buttons = 0xFFFF;
 uint8_t counter = 0;

 while(counter != 0xff)
 {
  counter <<= 1;

  read_buttons = 0;
  
# 191 "main.c" 3
 (*(volatile uint8_t *)((0x18) + 0x20)) 
# 191 "main.c"
           |= (1<<0);
  
# 192 "main.c" 3
 (*(volatile uint8_t *)((0x18) + 0x20)) 
# 192 "main.c"
           &= ~(1<<0);
  uint8_t i = 11;
  do{
   read_buttons <<= 1;
   if ((
# 196 "main.c" 3
       (*(volatile uint8_t *)((0x16) + 0x20)) 
# 196 "main.c"
                & (1<<1)) == 0) read_buttons |= 1;
   
# 197 "main.c" 3
  (*(volatile uint8_t *)((0x18) + 0x20)) 
# 197 "main.c"
            &= ~(1<<2);
   
# 198 "main.c" 3
  (*(volatile uint8_t *)((0x18) + 0x20)) 
# 198 "main.c"
            |= (1<<2);
  } while (i--);

  if(read_buttons == old_buttons) counter |= 0x01;
  old_buttons = read_buttons;
  _delay_us(375);
 }
 return read_buttons;
}

void init_rn42(uint8_t gamepad)
{
 delay_ms(50*15);
    uart_tx_str_P(
# 211 "main.c" 3
                 (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 211 "main.c"
                 "$$$"
# 211 "main.c" 3
                 ); &__c[0];}))
# 211 "main.c"
                            );
 delay_ms(50*4);

    uart_tx_str_P(
# 214 "main.c" 3
                 (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 214 "main.c"
                 "+\r"
# 214 "main.c" 3
                 ); &__c[0];}))
# 214 "main.c"
                            );
    delay_ms(50);

    uart_tx_str_P(
# 217 "main.c" 3
                 (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 217 "main.c"
                 "S=,5500\r"
# 217 "main.c" 3
                 ); &__c[0];}))
# 217 "main.c"
                                  );
    delay_ms(50);

 uart_tx_str_P(
# 220 "main.c" 3
              (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 220 "main.c"
              "SN,SNES-BT-"
# 220 "main.c" 3
              ); &__c[0];}))
# 220 "main.c"
                                 );
 if (gamepad != 0) uart_tx_str_P(
# 221 "main.c" 3
                                (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 221 "main.c"
                                "Gamepad-t13\r"
# 221 "main.c" 3
                                ); &__c[0];}))
# 221 "main.c"
                                                     );
 else uart_tx_str_P(
# 222 "main.c" 3
                      (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 222 "main.c"
                      "Keyboard-t13\r"
# 222 "main.c" 3
                      ); &__c[0];}))
# 222 "main.c"
                                            );
    delay_ms(50);
# 239 "main.c"
 if (gamepad != 0) uart_tx_str_P(
# 239 "main.c" 3
                                (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 239 "main.c"
                                "SH,0210\r"
# 239 "main.c" 3
                                ); &__c[0];}))
# 239 "main.c"
                                                 );
    else uart_tx_str_P(
# 240 "main.c" 3
                         (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 240 "main.c"
                         "SH,0200\r"
# 240 "main.c" 3
                         ); &__c[0];}))
# 240 "main.c"
                                          );
    delay_ms(50);

    uart_tx_str_P(
# 243 "main.c" 3
                 (__extension__({static const char __c[] __attribute__((__progmem__)) = (
# 243 "main.c"
                 "R,1\r"
# 243 "main.c" 3
                 ); &__c[0];}))
# 243 "main.c"
                              );
    delay_ms(50*10);
}

void init_ports(void)
{

    
# 250 "main.c" 3
   (*(volatile uint8_t *)((0x17) + 0x20)) 
# 250 "main.c"
             |= (1<<2) | (1<<0);
    
# 251 "main.c" 3
   (*(volatile uint8_t *)((0x18) + 0x20)) 
# 251 "main.c"
             |= (1<<2);
    
# 252 "main.c" 3
   (*(volatile uint8_t *)((0x18) + 0x20)) 
# 252 "main.c"
             &= ~(1<<0);

    
# 254 "main.c" 3
   (*(volatile uint8_t *)((0x17) + 0x20)) 
# 254 "main.c"
             &= ~(1<<1);
    
# 255 "main.c" 3
   (*(volatile uint8_t *)((0x18) + 0x20)) 
# 255 "main.c"
             |= (1<<1);
}

void init_uart(void)
{
 uint8_t sreg = 
# 260 "main.c" 3
               (*(volatile uint8_t *)((0x3F) + 0x20))
# 260 "main.c"
                   ;
 
# 261 "main.c" 3
__asm__ __volatile__ ("cli" ::: "memory")
# 261 "main.c"
     ;
 
# 262 "main.c" 3
(*(volatile uint8_t *)((0x36) + 0x20)) 
# 262 "main.c"
      = ((9600000UL + 115200/2) / 115200);
 
# 263 "main.c" 3
(*(volatile uint8_t *)((0x33) + 0x20)) 
# 263 "main.c"
       = (1<<
# 263 "main.c" 3
             0
# 263 "main.c"
                 );

 
# 265 "main.c" 3
(*(volatile uint8_t *)((0x39) + 0x20)) 
# 265 "main.c"
       &= ~(1<<
# 265 "main.c" 3
               2
# 265 "main.c"
                     );
 
# 266 "main.c" 3
(*(volatile uint8_t *)((0x38) + 0x20)) 
# 266 "main.c"
        = (1<<
# 266 "main.c" 3
               2
# 266 "main.c"
                    );

 
# 268 "main.c" 3
(*(volatile uint8_t *)((0x18) + 0x20)) 
# 268 "main.c"
             |= (1<<3);
 
# 269 "main.c" 3
(*(volatile uint8_t *)((0x17) + 0x20)) 
# 269 "main.c"
             |= (1<<3);

 outframe = 0;
 
# 272 "main.c" 3
(*(volatile uint8_t *)((0x3F) + 0x20)) 
# 272 "main.c"
     = sreg;
}

uint8_t gamepad_ee 
# 275 "main.c" 3
                  __attribute__((section(".eeprom"))) 
# 275 "main.c"
                        = 0;
uint8_t init_ee_config(uint16_t read_buttons)
{
 uint8_t gamepad = eeprom_read_byte(&gamepad_ee);
 gamepad &= 0x01;
    if(read_buttons != 0)
 {
  gamepad ^= 0x01;
     eeprom_write_byte(&gamepad_ee, gamepad);
 }
    return gamepad;
}

void uart_tx_char(char c)
{
 do
 {
  
# 292 "main.c" 3
 __asm__ __volatile__ ("sei" ::: "memory")
# 292 "main.c"
      ;
  __asm volatile ("nop");
  
# 294 "main.c" 3
 __asm__ __volatile__ ("cli" ::: "memory")
# 294 "main.c"
      ;
 }
 while (outframe);



 outframe = (3<<9) | (c<<1);

 
# 302 "main.c" 3
(*(volatile uint8_t *)((0x39) + 0x20)) 
# 302 "main.c"
       |= (1<<
# 302 "main.c" 3
              2
# 302 "main.c"
                    );
 
# 303 "main.c" 3
(*(volatile uint8_t *)((0x38) + 0x20)) 
# 303 "main.c"
        = (1<<
# 303 "main.c" 3
              2
# 303 "main.c"
                   );

 
# 305 "main.c" 3
__asm__ __volatile__ ("sei" ::: "memory")
# 305 "main.c"
     ;

}
# 316 "main.c"
void uart_tx_str_P(const char str[])
{
    while(
# 318 "main.c" 3
         (__extension__({ uint16_t __addr16 = (uint16_t)((uint16_t)(
# 318 "main.c"
         str
# 318 "main.c" 3
         )); uint8_t __result; __asm__ __volatile__ ( "lpm %0, Z" "\n\t" : "=r" (__result) : "z" (__addr16) ); __result; }))
# 318 "main.c"
                           ) uart_tx_char(
# 318 "main.c" 3
                                          (__extension__({ uint16_t __addr16 = (uint16_t)((uint16_t)(
# 318 "main.c"
                                          str++
# 318 "main.c" 3
                                          )); uint8_t __result; __asm__ __volatile__ ( "lpm %0, Z" "\n\t" : "=r" (__result) : "z" (__addr16) ); __result; }))
# 318 "main.c"
                                                              );
}

void delay_ms(volatile uint16_t ms)
{
 while(ms--) _delay_us(1000);
}


# 326 "main.c" 3
void __vector_6 (void) __attribute__ ((signal,used, externally_visible)) ; void __vector_6 (void)

# 327 "main.c"
{
 uint8_t sreg = 
# 328 "main.c" 3
                (*(volatile uint8_t *)((0x3F) + 0x20))
# 328 "main.c"
                    ;
 uint16_t data = outframe;

 
# 331 "main.c" 3
(*(volatile uint8_t *)((0x36) + 0x20)) 
# 331 "main.c"
          += ((9600000UL + 115200/2) / 115200);

 if(data & 1) 
# 333 "main.c" 3
             (*(volatile uint8_t *)((0x18) + 0x20)) 
# 333 "main.c"
                          |= (1<<3);
 else 
# 334 "main.c" 3
       (*(volatile uint8_t *)((0x18) + 0x20)) 
# 334 "main.c"
                    &= ~(1<<3);


 if(data == 1) 
# 337 "main.c" 3
              (*(volatile uint8_t *)((0x39) + 0x20)) 
# 337 "main.c"
                     &= ~(1<<
# 337 "main.c" 3
                             2
# 337 "main.c"
                                   );

 outframe = data >> 1;
 
# 340 "main.c" 3
(*(volatile uint8_t *)((0x3F) + 0x20)) 
# 340 "main.c"
     = sreg;
}
