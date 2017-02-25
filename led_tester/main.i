# 1 "main.c"
# 1 "<command-line>"
# 1 "main.c"
# 10 "main.c"
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
# 11 "main.c" 2
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
# 12 "main.c" 2
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
 __tmp = ((8000000UL) / 1e3) * __ms;
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
 __tmp = ((8000000UL) / 1e6) * __us;
# 242 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
  __ticks_dc = (uint32_t)(ceil(fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 268 "c:\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h" 3
}
# 13 "main.c" 2

# 1 "lcd/lcd_routines.h" 1
# 60 "lcd/lcd_routines.h"
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
# 15 "main.c" 2


# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 1 3
# 45 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
# 1 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdarg.h" 1 3 4
# 40 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 98 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdarg.h" 3 4
typedef __gnuc_va_list va_list;
# 46 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 2 3



# 1 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stddef.h" 1 3 4
# 50 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 2 3
# 242 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
struct __file {
 char *buf;
 unsigned char unget;
 uint8_t flags;
# 261 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
 int size;
 int len;
 int (*put)(char, struct __file *);
 int (*get)(struct __file *);
 void *udata;
};
# 405 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern struct __file *__iob[];
# 417 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern struct __file *fdevopen(int (*__put)(char, struct __file*), int (*__get)(struct __file*));
# 434 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int fclose(struct __file *__stream);
# 608 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int vfprintf(struct __file *__stream, const char *__fmt, va_list __ap);





extern int vfprintf_P(struct __file *__stream, const char *__fmt, va_list __ap);






extern int fputc(int __c, struct __file *__stream);




extern int putc(int __c, struct __file *__stream);


extern int putchar(int __c);
# 649 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int printf(const char *__fmt, ...);





extern int printf_P(const char *__fmt, ...);







extern int vprintf(const char *__fmt, va_list __ap);





extern int sprintf(char *__s, const char *__fmt, ...);





extern int sprintf_P(char *__s, const char *__fmt, ...);
# 685 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int snprintf(char *__s, size_t __n, const char *__fmt, ...);





extern int snprintf_P(char *__s, size_t __n, const char *__fmt, ...);





extern int vsprintf(char *__s, const char *__fmt, va_list ap);





extern int vsprintf_P(char *__s, const char *__fmt, va_list ap);
# 713 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int vsnprintf(char *__s, size_t __n, const char *__fmt, va_list ap);





extern int vsnprintf_P(char *__s, size_t __n, const char *__fmt, va_list ap);




extern int fprintf(struct __file *__stream, const char *__fmt, ...);





extern int fprintf_P(struct __file *__stream, const char *__fmt, ...);






extern int fputs(const char *__str, struct __file *__stream);




extern int fputs_P(const char *__str, struct __file *__stream);





extern int puts(const char *__str);




extern int puts_P(const char *__str);
# 762 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern size_t fwrite(const void *__ptr, size_t __size, size_t __nmemb,
         struct __file *__stream);







extern int fgetc(struct __file *__stream);




extern int getc(struct __file *__stream);


extern int getchar(void);
# 810 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int ungetc(int __c, struct __file *__stream);
# 822 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern char *fgets(char *__str, int __size, struct __file *__stream);






extern char *gets(char *__str);
# 840 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern size_t fread(void *__ptr, size_t __size, size_t __nmemb,
        struct __file *__stream);




extern void clearerr(struct __file *__stream);
# 857 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int feof(struct __file *__stream);
# 868 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
extern int ferror(struct __file *__stream);






extern int vfscanf(struct __file *__stream, const char *__fmt, va_list __ap);




extern int vfscanf_P(struct __file *__stream, const char *__fmt, va_list __ap);







extern int fscanf(struct __file *__stream, const char *__fmt, ...);




extern int fscanf_P(struct __file *__stream, const char *__fmt, ...);






extern int scanf(const char *__fmt, ...);




extern int scanf_P(const char *__fmt, ...);







extern int vscanf(const char *__fmt, va_list __ap);







extern int sscanf(const char *__buf, const char *__fmt, ...);




extern int sscanf_P(const char *__buf, const char *__fmt, ...);
# 938 "c:\\avr8-gnu-toolchain\\avr\\include\\stdio.h" 3
static __inline__ int fflush(struct __file *stream __attribute__((unused)))
{
 return 0;
}
# 18 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdfix.h" 1 3 4
# 36 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdfix.h" 3 4
# 1 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdfix-gcc.h" 1 3 4
# 37 "c:\\avr8-gnu-toolchain\\lib\\gcc\\avr\\4.8.1\\include\\stdfix.h" 2 3 4




typedef signed char int_hr_t;
typedef unsigned char uint_uhr_t;

typedef short int int_r_t;
typedef short unsigned int uint_ur_t;

typedef short int int_hk_t;
typedef short unsigned int uint_uhk_t;

typedef long int int_lr_t;
typedef long unsigned int uint_ulr_t;

typedef long int int_k_t;
typedef long unsigned int uint_uk_t;

typedef long long int int_llr_t;
typedef long long unsigned int uint_ullr_t;

typedef long long int int_lk_t;
typedef long long unsigned int uint_ulk_t;

typedef long long int int_llk_t;
typedef long long unsigned int uint_ullk_t;
# 19 "main.c" 2
# 42 "main.c"
char buffer[6];
const uint8_t __attribute__((__progmem__)) symbol_R[8] = {0x00, 0x0E, 0x11, 0x11, 0x11, 0x0A, 0x1B, 0x00};
const uint8_t __attribute__((__progmem__)) symbol_KR[8] = {0x14, 0x18, 0x14, 0x06, 0x09, 0x09, 0x06, 0x0F};
const uint8_t __attribute__((__progmem__)) symbol__f[8] = {0x00, 0x00, 0x04, 0x0A, 0x08, 0x08, 0x1E, 0x08};
const uint8_t __attribute__((__progmem__)) symbol__t[8] = {0x00, 0x00, 0x08, 0x08, 0x1C, 0x08, 0x08, 0x06};
const uint8_t __attribute__((__progmem__)) symbol__d[8] = {0x00, 0x00, 0x02, 0x02, 0x0E, 0x12, 0x12, 0x0D};





uint8_t flags = (1<<1);


void port_init(void);
void adc_init(void);
uint16_t get_vt(void);
uint16_t get_mA(void);
uint16_t get_vf(void);
uint16_t adc_read(uint8_t channel);

int main(void)
{
 port_init();
 lcd_init();
 adc_init();

 lcd_generatechar_P(1, symbol_R);
 lcd_generatechar_P(2, symbol_KR);
 lcd_generatechar_P(3, symbol__f);
 lcd_generatechar_P(4, symbol__t);
 lcd_generatechar_P(5, symbol__d);

 uint16_t current_d = 0;
 uint16_t voltage_t = 0;
 uint16_t voltage_f = 0;
 uint16_t current_d_old = 0;
 uint16_t voltage_f_old = 0;
 uint16_t voltage_t_old = 0;

    while(1)
 {
  current_d = get_mA();
  voltage_f = get_vf();
  voltage_t = get_vt();

  if ((current_d == 0) && (flags & (1<<1)))
  {
   flags &= ~((1<<2) | (1<<1));

   lcd_setcursor(0,0);
   lcd_string("   LED Tester   ");
   lcd_setcursor(0,1);
   lcd_string("(attache an LED)");
  }
  else if (current_d > 0)
  {
   if( (current_d != current_d_old) ||
    (voltage_f != voltage_f_old) ||
    (voltage_t != voltage_t_old) )
   {

    current_d_old = current_d;
    voltage_f_old = voltage_f;
    voltage_t_old = voltage_t;


    uint16_t resistor_t = (voltage_t-voltage_f)/current_d;
    if (resistor_t > 9999)
    {
     resistor_t /= 1000;
     flags |= (1<<0);
    }
    else flags &= ~(1<<0);


    lcd_clear();


    lcd_data('I'); lcd_data(5);
    sprintf(buffer, "%2d", current_d);
    lcd_string(buffer);

    lcd_string("mA V");

    lcd_data(3);
    voltage_f /= 100;
    lcd_data('0'+(voltage_f/10)); lcd_data('.'); lcd_data('0'+(voltage_f%10));


    lcd_setcursor(0,1);
    lcd_data('V'); lcd_data(4);
    sprintf(buffer, "%2d", voltage_t/10);
    lcd_string(buffer); lcd_data('.'); lcd_data('0'+(voltage_t%10));


    lcd_string(" R"); lcd_data(4);
    sprintf(buffer, "%4d", resistor_t);
    lcd_string(buffer);
    if(flags & (1<<0)) lcd_data(2);
    else lcd_data(1);


    flags |= (1<<2);
    flags |= (1<<1);
   }
  }

 _delay_ms(50);
 }
    return 0;
}

uint16_t get_mA(void)
{
 uint16_t current = adc_read(6);
 current = (current*1100)/(1024*10);
 return current;
}

uint16_t get_vf(void)
{
 uint16_t v_high = adc_read(7);
 v_high = (v_high*(1100*(1+3)))/1024;

 uint16_t v_low = adc_read(6);
 v_low = (v_low*1100)/1024;
 return v_high - v_low;
}

uint16_t get_vt(void)
{
 uint16_t voltage = adc_read(1);
 voltage = (voltage*150)/1024;
 return voltage;
}

void port_init(void)
{
 (*(volatile uint8_t *)((0x17) + 0x20)) |= (1<<2);
 (*(volatile uint8_t *)((0x18) + 0x20)) |= (1<<2);
}

void adc_init(void)
{
 (*(volatile uint8_t *)((0x07) + 0x20)) |= (1<<7);
 (*(volatile uint8_t *)((0x06) + 0x20)) |= (1<<7)

   | (0b110<<0);
 _delay_ms(1);
}

uint16_t adc_read(uint8_t channel)
{
 (*(volatile uint8_t *)((0x07) + 0x20)) = ((*(volatile uint8_t *)((0x07) + 0x20)) & 0b11110000) | channel;

 uint16_t adc = 0;
 for(uint8_t i=0; i<16; i++)
 {
  (*(volatile uint8_t *)((0x07) + 0x20)) |= (1<<6);
  while((*(volatile uint8_t *)((0x07) + 0x20)) & (1<6));
  adc += (*(volatile uint16_t *)((0x04) + 0x20));
  _delay_ms(1);
 }
 adc /= 16;
 return adc;
}
