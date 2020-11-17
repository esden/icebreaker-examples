Simple example testing all the LED, Buttons and PMOD IO on the iCEBreaker FPGA board.

# iCEBreaker standard
On iCEBreaker-standard This example consists of three parts.

## Part 1

Binary counter displayed on the cluster of 5 LED found on the default PMOD of
the full iCEBreaker board. The LSB is the center red LED and the higher
significant bits are formed by the four green LEDs surrounding.

## Part 2

The count of depressed buttons on the main board and the default PMOD are displayed in binary on the two LEDs mounted on the main board.

## Part 3
The remaining PMOD 1A and 1B are combined into a 16bit shiftregister and a 1 bit is continously shifted through the outputs.


# iCEBreaker-bitsy
On iCEBreaker-bitsy variants this example shifts a bit through all the GPIO. When you press the User button the green led will light up.

# How to build

To build this example you need to provide which BOARD you want to target.

For example iCEBreaker-bitsy with the Pmod breakout board:
```
make BOARD=bitsy1-pmod prog
```

This will synthesize the bitstream using the bitsy verilog file, the correct pcf and launch dfu-util to upload the bitstream to the board.
