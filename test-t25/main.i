# 1 "main.c"
# 1 "<command-line>"
# 1 "main.c"




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
# 6 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\sleep.h" 1 3
# 7 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\wdt.h" 1 3
# 8 "main.c" 2
# 1 "c:\\avr8-gnu-toolchain\\avr\\include\\avr\\interrupt.h" 1 3
# 9 "main.c" 2

typedef union {
  struct {
    uint8_t b0:1, b1:1, b2:1, b3:1, b4:1, b5:1, b6:1, b7:1;
  };
  uint8_t byte;
} bits_t;

struct bits {
  uint8_t b0:1, b1:1, b2:1, b3:1, b4:1, b5:1, b6:1, b7:1;
} __attribute__((__packed__));
# 33 "main.c"
int main(void)
{
 (*(volatile uint8_t *)((uint16_t) &((*(volatile uint8_t *)((0x11) + 0x20))))) |= (1<<4);

 (*(volatile bits_t *)((uint16_t) &((*(volatile uint8_t *)((0x11) + 0x20))))).b3 = 1;


 (*(volatile struct bits *)((uint16_t) &((*(volatile uint8_t *)((0x11) + 0x20))))).b5 = 1;


 (*((volatile uint8_t *)((void*)(&(*(volatile uint8_t *)((0x12) + 0x20)))))) = 5;
 (*((volatile uint8_t *)((void*)(&(*(volatile uint8_t *)((0x12) + 0x20)))))) |= (1<<5);

 (((volatile struct bits*)&(*(volatile struct bits *)((uint16_t) &((*(volatile uint8_t *)((0x11) + 0x20))))))->b4) = 1;

    while(1)
    {
  (*(volatile uint8_t *)((uint16_t) &((*(volatile uint8_t *)((0x11) + 0x20))))) = ~(*(volatile uint8_t *)((uint16_t) &((*(volatile uint8_t *)((0x11) + 0x20)))));
  (*(volatile uint8_t *)((0x18) + 0x20)) = (*(volatile uint8_t *)((uint16_t) &((*(volatile uint8_t *)((0x11) + 0x20)))));
    }
}
