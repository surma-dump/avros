PROG=/dev/ttyUSB0
NAME=avros
FREQ=16000000
BAUDRATE=115200
MCU=atmega8515
PART=m8515
CFLAGS=-O2
CFILES=$(NAME).c
all:
	avr-gcc $(CFLAGS)  -I/usr/avr/include -L/usr/avr/lib -mmcu=$(MCU) \
		-DBAUD=$(BAUDRATE)UL -DF_CPU=$(FREQ)L -Wall $(CFILES) -o $(NAME).elf
	avr-objcopy -O ihex $(NAME).elf $(NAME).hex

run:
	#git tag -f burned
	avrdude -P $(PROG) -p $(PART) -c stk500v2 -U flash:w:$(NAME).hex
fuses:
	avrdude -P $(PROG) -p $(PART) -c stk500v2 -U hfuse:w:0x`cat fuses | cut -c1-2`:m
	avrdude -P $(PROG) -p $(PART) -c stk500v2 -U lfuse:w:0x`cat fuses | cut -c3-4`:m
clean:
	-@rm *.hex *.elf *.S
.PHONY: fuses
