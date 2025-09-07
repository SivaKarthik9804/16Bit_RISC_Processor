# 16Bit_RISC_Processor

---

# 16-Bit RISC Processor – Verilog on Xilinx Vivado

A streamlined and synthesizable **16-bit RISC processor** implemented in Verilog, ready for simulation, synthesis, and deployment on Xilinx FPGAs using Vivado.

---

## Project Overview

* **Goal**: Implement a basic 16-bit RISC architecture with a simple instruction set, registers, ALU, and control logic.
* **Components**:

  * `16_Bit_RISC_processor.v`: Core RTL implementation of the RISC CPU.
  * `16_Bit_RISC_processor_tb.v`: Testbench for functional verification.
  * `16 Bit RISC Processor WF.png`: Simulation waveform illustrating execution of sample instructions.

---

## Repository Structure

```
16Bit_RISC_Processor/
├── 16_Bit_RISC_processor.v       # RTL implementation of the processor
├── 16_Bit_RISC_processor_tb.v    # Testbench for simulations
├── 16 Bit RISC Processor WF.png  # Snapshot of simulation waveform
└── README.md                     # Project documentation
```

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/SivaKarthik9804/16Bit_RISC_Processor.git
cd 16Bit_RISC_Processor
```

### 2. Simulate the Processor

Using Xilinx Vivado:

```bash
iverilog -o risc_tb 16_Bit_RISC_processor.v 16_Bit_RISC_processor_tb.v
vvp risc_tb
```

Visualize results with GTKWave or compare against the provided waveform image to confirm correct instruction execution.

### 3. Synthesize with Vivado

To deploy on FPGA:

1. Open Vivado and create a new RTL project.
2. Add `16_Bit_RISC_processor.v` as the design source.
3. Define the target FPGA board (e.g., Basys-3, Artix-7).
4. Map necessary I/O pins (e.g., clock, reset, input controls, display LEDs).
5. Run through **Synthesis → Implementation → Bitstream Generation**.
6. Program the FPGA board and run test routines.

---

## Architecture Highlights

* **Core FSM**: Manages instruction fetch, decode, execute, memory access, and write-back cycles.
* **Instruction Set**: Basic opcodes for arithmetic, control flow, and memory operations.
* **Register File & ALU**: Supports essential operations like addition, subtraction, branching, and load/store.
* **Modular Design**: Easily extensible—add more instructions, address modes, or pipeline enhancements.

---

## Applications & Expansion Ideas

**Use Cases**:

* Academic demo for CPU design, instruction execution, and FSM-based control.
* FPGA-based learning tool for computer architecture fundamentals.

**Future Directions**:

* **Pipeline Implementation**: Add fetch-decode-execute pipeline stages for increased throughput.
* **Expanded ISA**: Integrate branch-and-link, immediate values, and conditional execution.
* **Cache or Memory Module**: Incorporate instruction/data cache or scratchpad RAM.
* **Debug Interface**: Add UART or display-driven debug interface to monitor registers.
* **ASIC Flow**: Target SkyWater PDK using OpenLane to explore ASIC feasibility.

---

## Author

**Siva Karthik**
Electronics & Communication Engineering Student | VLSI & FPGA Enthusiast
GitHub: [SivaKarthik9804](https://github.com/SivaKarthik9804)

---
