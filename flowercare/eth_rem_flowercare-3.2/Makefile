# makefile, written by guido socher
#
# Select your chip type:
#
#MCU=atmega168
#DUDECPUTYPE=m168
MCU=atmega328p
DUDECPUTYPE=m328p
#MCU=atmega644
#DUDECPUTYPE=m644
#
# === Edit this and enter the correct device/com-port:
# linux (plug in the avrusb500 and type dmesg to see which device it is):
LOADCMD=avrdude -P com1 -b 57600

# mac (plug in the programer and use ls /dev/tty.usbserial* to get the name):
#LOADCMD=avrdude -P /dev/tty.usbserial-A9006MOb

# windows (check which com-port you get when you plugin the avrusb500):
#LOADCMD=avrdude -P COM4

# All operating systems: if you have set the default_serial paramter 
# in your avrdude.conf file correctly then you can just use this
# and you don't need the above -P option:
#LOADCMD=avrdude
# === end edit this
#
LOADARG=-p $(DUDECPUTYPE) -c stk500v1 -e -U flash:w:
#
#
CC=avr-gcc
OBJCOPY=avr-objcopy
# optimize for size:
CFLAGS=-g -mmcu=$(MCU) -Wall -W -Os -mcall-prologues
#-------------------
.PHONY: all
#
all: main.hex 
	@echo "done"
#
main: main.hex
	@echo "done"
#
size: 
	avr-size *.elf
#-------------------
help: 
	@echo "Usage: make all|load|main|rdfuses|size"
	@echo "or"
	@echo "Usage: make clean"
	@echo " "
	@echo "make fuse (to read the clock from enc28j60, for all new boards)"
#-------------------
main.hex: main.elf 
	$(OBJCOPY) -R .eeprom -O ihex main.elf main.hex 
	avr-size main.elf
	@echo " "
	@echo "Expl.: data=initialized data, bss=uninitialized data, text=code"
	@echo " "

main.elf: main.o
	$(CC) $(CFLAGS) -o main.elf -Wl,-Map,main.map main.o
websrv_help_functions.o: websrv_help_functions.c websrv_help_functions.h ip_config.h 
	$(CC) $(CFLAGS) -Os -c websrv_help_functions.c
enc28j60.o: enc28j60.c timeout.h enc28j60.h
	$(CC) $(CFLAGS) -Os -c enc28j60.c
ip_arp_udp_tcp.o: ip_arp_udp_tcp.c net.h enc28j60.h ip_config.h
	$(CC) $(CFLAGS) -Os -c ip_arp_udp_tcp.c
main.o: main.c ip_arp_udp_tcp.h enc28j60.h timeout.h net.h websrv_help_functions.h ip_config.h onewire.h ds18x20.h analog.h ds18x20_config.h
	$(CC) $(CFLAGS) -Os -c main.c
onewire.o: onewire.c onewire.h 
	$(CC) $(CFLAGS) -Os -c onewire.c
ds18x20.o: ds18x20.c ds18x20.h ds18x20_config.h
	$(CC) $(CFLAGS) -Os -c ds18x20.c
crc8.o: crc8.c crc8.h 
	$(CC) $(CFLAGS) -Os -c crc8.c
analog.o: analog.c analog.h 
	$(CC) $(CFLAGS) -Os -c analog.c
#------------------
load: main.hex
	$(LOADCMD) $(LOADARG)main.hex
#-------------------
# Check this with make rdfuses
rdfuses:
	$(LOADCMD) -p $(DUDECPUTYPE) -c stk500v2 -v -q
#
fuse:
	$(LOADCMD) -p  $(DUDECPUTYPE) -c stk500v2 -u -v -U lfuse:w:0x60:m
fuses:
	$(LOADCMD) -p  $(DUDECPUTYPE) -c stk500v2 -u -v -U lfuse:w:0x60:m
#-------------------
clean:
	rm -f *.o *.map *.elf main.hex
#-------------------
