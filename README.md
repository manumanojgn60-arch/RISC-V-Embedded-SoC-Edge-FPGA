
---

# Project 2
## RISC-V Embedded SoC + MAC Accelerator

### `README.md`

```markdown
# Design and FPGA Implementation of a RISC-V Based Embedded SoC for Edge Applications

## Overview

This project implements a RISC-V based Embedded System-on-Chip designed for edge-processing applications.

The system integrates a simplified RV32I processor with memory, peripherals, PWM control, and a hardware MAC accelerator.

The hardware accelerator performs:

    Result = A × B + C

This demonstrates the integration of a custom hardware accelerator with a processor-based SoC.

## Main Features

- RV32I RISC-V processor
- ROM
- RAM
- GPIO
- UART
- Timer
- PWM
- Hardware MAC accelerator
- Memory-mapped peripheral architecture

## MAC Accelerator

The MAC accelerator performs:

```text
Result = A × B + C
Verification

Simulation was performed using Icarus Verilog.

GTKWave was used for waveform analysis.

The complete SoC simulation verifies:

Register operations
GPIO
MAC accelerator
UART
Timer
PWM
Tools
Verilog HDL
Icarus Verilog
GTKWave
Xilinx Vivado
Git/GitHub
Applications
Edge computing
Embedded AI acceleration
DSP acceleration