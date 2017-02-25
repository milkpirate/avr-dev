# makefile, written by guido socher
MCU=atmega168
DUDECPUTYPE=m168
#
#MCU=atmega328p
#DUDECPUTYPE=m328
#
LOADCMD=avrdude
LOADARG=-p $(DUDECPUTYPE) -c stk500v2 -e -U flash:w:
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
	@echo "For new hardware with clock from enc38j60 (all new boards): make fuse"
#-------------------
main.hex: main.elf 
	$(OBJCOPY) -R .eeprom -O ihex main.elf main.hex 
	avr-size main.elf
	@echo " "
	@echo "Expl.: data=initialized data, bss=uninitialized data, text=code"
	@echo " "

main.elf: main.o ip_arp_udp_tcp.o enc28j60.o websrv_help_functions.o crc8.o onewire.o ds18x20.o analog.o
	$(CC) $(CFLAGS) -o main.elf -Wl,-Map,main.map main.o ip_arp_udp_tcp.o enc28j60.o websrv_help_functions.o crc8.o onewire.o ds18x20.o analog.o
websrv_help_functions.o: websrv_help_functions.c websrv_help_functions.h ip_config.h 
	$(CC) $(CFLAGS) -Os -c websrv_help_functions.c
enc28j60.o: enc28j60.c timeout.h enc28j60.h
	$(CC) $(CFLAGS) -Os -c enc28j60.c
ip_arp_udp_tcp.o: ip_arp_udp_tcp.c net.h enc28j60.h ip_config.h
	$(CC) $(CFLAGS) -Os -c ip_arp_udp_tcp.c
main.o: main.c ip_arp_udp_tcp.h enc28j60.h timeout.h net.h websrv_help_functions.h ip_config.h onewire.h ds18x20.h analog.h
	$(CC) $(CFLAGS) -Os -c main.c
onewire.o: onewire.c onewire.h 
	$(CC) $(CFLAGS) -Os -c onewire.c
ds18x20.o: ds18x20.c ds18x20.h 
	$(CC) $(CFLAGS) -Os -c ds18x20.c
crc8.o: crc8.c crc8.h 
	$(CC) $(CFLAGS) -Os -c crc8.c
analog.o: analog.c analog.h 
	$(CC) $(CFLAGS) -Os -c analog.c
#------------------
#pre: main.hex
#	cp main.hex main_pre168.hex
#
load: main.hex
	$(LOADCMD) $(LOADARG)main.hex
#
#-------------------
# Check this with make rdfuses
rdfuses:
	avrdude -p $(DUDECPUTYPE) -c stk500v2 -v -q
#
fuse:
	@echo "warning: run this command only if you have an external clock on xtal1"
	@echo "The is the last chance to stop. Press crtl-C to abort"
	@sleep 2
	avrdude -p  $(DUDECPUTYPE) -c stk500v2 -u -v -U lfuse:w:0x60:m
#-------------------
clean:
	rm -f *.o *.map *.elf main.hex
#-------------------
