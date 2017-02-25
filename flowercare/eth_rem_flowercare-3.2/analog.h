/* vim: set sw=8 ts=8 si : */
/*************************************************************************
 Title	:   C include file for analog conversion
 Target:    atmega88/168/328
 Copyright: GPL V2
***************************************************************************/
#ifndef ANALOG_H
#define ANALOG_H

// return analog value of a given channel.
extern void adc_ref_pin_init(void);
extern uint8_t convertanalog8(unsigned char channel);

#endif /* ANALOG_H */
