# fpga_rtl_ip_library (In progress)
This repository contains a curated collection of fundamental, reusable RTL design blocks implemented in Verilog/SystemVerilog, targeting industry-standard digital design practices. The modules included here are commonly used in FPGA and ASIC designs and are intended to demonstrate clean coding style, parameterization, synthesizability, and design-for-reuse.

Included Modules
1. Parameterized Counter with Enable (Configurable-width counter with synchronous enable and reset support)
2. Fixed-Priority Arbiter (N Inputs) (Deterministic arbitration logic with parameterized request width)
3. Round-Robin Arbiter (Fair arbitration scheme ensuring no starvation across multiple requesters)
4. Clock Divider with Glitch-Free Enable (Safe clock division logic with clean enable control and no spurious pulses)
5. Programmable Delay Line (Shift-Register Based, Parameterized delay insertion using shift registers for timing alignment)
6. Gray-Code Counter with Encoder/Decoder (Gray-code generation and conversion for metastability-safe counters)
7. Single-Clock FIFO (Synchronous FIFO with full/empty flags and configurable depth and width)
8. Dual-Clock FIFO (CDC-Aware Design, Asynchronous FIFO implementing proper clock-domain crossing techniques, including Gray-coded pointers and synchronizers)

