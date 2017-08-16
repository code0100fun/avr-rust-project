COMPILED:=target/arduino/release/PROJECT_NAME.elf
HEX:=PROJECT_NAME.hex
SERIAL_PORT:=/dev/cu.usbmodem1411

all: ${HEX}

.PHONY: ${COMPILED}
${COMPILED}:
	cargo build --release --target=./arduino.json

# Convert binary to an Intel HEX file for upload
${HEX}: ${COMPILED}
	avr-objcopy -O ihex -R .eeprom $< $@

# Download the HEX to the board
.PHONY: program
program:
	avrdude -p atmega328p -c arduino -P ${SERIAL_PORT} -U flash:w:${HEX}:i

.PHONY: connect-terminal
connect-terminal:
	picocom ${SERIAL_PORT}
