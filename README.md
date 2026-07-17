# VKA5
# RISC-V 64-bit SoC

A work-in-progress implementation of a Linux-capable 64-bit RISC-V System-on-Chip developed from scratch in SystemVerilog.

The long-term objective of this project is to build a complete dual-core RISC-V SoC featuring a custom in-order processor, cache hierarchy, memory subsystem, and peripheral infrastructure capable of booting a Linux operating system.

This repository is currently under active development. Components will be added incrementally as they are designed, verified, and integrated.

## Planned Features

- RV64 5-stage in-order pipeline
- Dual-core architecture
- RV64IM instruction set support
- Private L1 instruction and data caches per core
- Shared L2 cache
- AXI-based system interconnect
- Machine, Supervisor, and User privilege modes
- Sv39 virtual memory
- Linux boot support
- OpenSBI integration
- Device Tree support
- Differential testing against Spike
- FPGA validation

## Development Status

The project is being developed in phases, beginning with a single-core RV64 processor and gradually evolving into a complete Linux-capable multicore SoC.

Current focus:

- Processor microarchitecture planning
- Pipeline implementation
- Verification infrastructure

## Repository Structure

The repository structure is a work in progress and will be updated once the project reaches a stable state.
