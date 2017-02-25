/*
 */
#define MCU	attiny13

#include <avr/io.h>
#include <stdfix.h>
#include <stdio.h>

int main(void) {
  volatile _Accum fx1, fx2 = 2.33K, fx3 = 0.66K;
  volatile float fl1, flt2 = 2.33, fl3 = 0.66;

  fx1 = fx2 + fx3;
  fl1 = fl2 + fl3;

  fx1 = fx2 – fx3;
  fl1 = fl2 - fl3;

  fx1 = fx2 * fx3;
  fl1 = fl2 * fl3;

  fx3 = fx2 / fx3;
  fl3 = fl2 / fl3;

  //fl1 = (float)fx3;
}
