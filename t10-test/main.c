#include <util/delay.h>
#include <avr/io.h>

static inline void setup() {
  // configure PB2 pin
  PUEB &= ~_BV(PUEB2);   // disable Pull-Up
  DDRB |= _BV(DDB2);     // enable Output mode
  PORTB &= ~_BV(PORTB2); // set output to Low
}

int main() {

  setup();

  while (1) {

    PORTB &= ~_BV(PORTB2);
    _delay_ms(500);

    PORTB |= _BV(PORTB2);
    _delay_ms(500);
  }

  return 0;
}
