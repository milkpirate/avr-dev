# WinAVR cross-compiler toolchain is used here
CC = avr-gcc
OBJCOPY = avr-objcopy
DUDE = avrdude

# If you are not using ATtiny85 and the USBtiny programmer, 
# update the lines below to match your configuration
CFLAGS = -Wall -Os -Iusbdrv -mmcu=attiny25 -DF_CPU=16500000
OBJFLAGS = -j .text -j .data -O ihex
DUDEFLAGS = -p attiny25 -c usbasp
DUDEFUSES = -U lfuse:w:0x82:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m

# Object files for the firmware (usbdrv/oddebug.o not strictly needed I think)
OBJECTS = main.o 
#usbdrv/usbdrv.o usbdrv/oddebug.o usbdrv/usbdrvasm.o

# By default, build the firmware and command-line client, but do not flash
all: main.hex

# With this, you can flash the firmware by just typing "make flash" on command-line
flash: main.hex
	$(DUDE) $(DUDEFLAGS) $(DUDEFUSES) -U flash:w:$<

eeprom: main.eep
	$(DUDE) $(DUDEFLAGS) -U eeprom:w:$<

# Housekeeping if you want it
clean:
	$(RM) *.o *.hex *.elf 
	#usbdrv/*.o

# From .elf file to .hex
%.hex: %.elf
	$(OBJCOPY) $(OBJFLAGS) $< $@

# Main.elf requires additional objects to the firmware, not just main.o
main.elf: 	$(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@
	#

# Without this dependance, .o files will not be recompiled if you change 
# the config! I spent a few hours debugging because of this...
#$(OBJECTS): usbdrv/usbconfig.h

# From C source to .o object file
%.o: %.c	
	$(CC) $(CFLAGS) -c $< -o $@

# From assembler source to .o object file
%.o: %.S
	$(CC) $(CFLAGS) -x assembler-with-cpp -c $< -o $@
