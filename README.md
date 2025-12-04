# ECE-128---Lab-10-

## Project Description

This project implements a complete digital system using Verilog on the Basys-3 FPGA board.
The system integrates:

- ROM (8×4) – Stores two 4-bit operands
- Control Unit (FSM) – Reads operands, sequences operations, asserts done
- Combinational Multiplier (4×4 → 8) – Computes an 8-bit product
- RAM (8×8) – Stores the product
- Basys-3 I/O – Switches for reset and start, LEDs for output

### Operands stored in ROM:
- A = 12 (0xC)
- B = 6 (0x6)

### Expected product:
12 × 6 = 72 = 0x48 = 0100 1000₂

The final result is displayed on the lower 8 LEDs, and a done signal is displayed on LED8.


## Instructions for Simulation

1. Open the project in Vivado.
2. Set whole_system_tb.v as the simulation top.
3. Run behavioral simulation.
4. Verify:
  - A = 0xC
  - B = 0x6
  - product = 0x48
  - RAM writes 0x48 into address 0
  - done = 1 in the DONE state
5. Check that led[7:0] = 0x48 and led[8] = 1 in the waveform.

Simulation confirms correct control sequencing and memory behavior.


## Instructions for FPGA Implementation (Basys-3)

1. Add the provided Basys-3 XDC constraints file.
2. Synthesize, implement, and generate the bitstream.
3. Program the Basys-3 board.
4. Use the switches as follows:
  - sw1 → reset
  - sw0 → start
5. Testing procedure:
  - Flip sw1 up → down to reset (LED8 turns OFF).
  - Pulse sw0 up → down to start the multiply operation.
  - After a brief moment:
      - LED8 turns ON (done flag)
      - led[7:0] = 0100 1000 (LED6 and LED3 ON)
6. This corresponds to the expected product 0x48 (72).
