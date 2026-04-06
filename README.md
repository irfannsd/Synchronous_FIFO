# Synchronous FIFO in Verilog

## Overview

This repository contains a **parameterizable Synchronous FIFO (First-In-First-Out) buffer implemented in Verilog HDL**, along with a **self-checking testbench** used for functional verification. The design supports configurable FIFO depth and data width, pointer-based full/empty detection, and simultaneous read/write operations.

The project is intended for **digital design practice, RTL development learning, and FPGA/ASIC simulation experiments**.

---

## Features

* Parameterized **FIFO depth**
* Parameterized **data width**
* Pointer-based **full and empty detection**
* **Circular buffer architecture**
* Supports **simultaneous read and write**
* **Self-checking testbench**
* Generates **VCD waveform** for simulation analysis

---

## FIFO Architecture

The FIFO is implemented using a **circular memory buffer** with separate **read and write pointers**.

Main components:

* Memory array
* Write pointer
* Read pointer
* Full detection logic
* Empty detection logic

### Empty Condition

The FIFO is empty when both pointers are equal.

### Full Condition

The FIFO is full when the write pointer wraps around and meets the read pointer while their most significant bits differ.

---

## Parameters

| Parameter | Description                    |
| --------- | ------------------------------ |
| DEPTH     | Number of entries in the FIFO  |
| WIDTH     | Bit-width of each data element |

Example configuration:

```
parameter DEPTH = 8;
parameter WIDTH = 8;
```

---

## Module Ports

| Signal   | Direction | Description     |
| -------- | --------- | --------------- |
| clk      | Input     | System clock    |
| rst      | Input     | Reset signal    |
| wr_en    | Input     | Write enable    |
| rd_en    | Input     | Read enable     |
| data_in  | Input     | Data input      |
| data_out | Output    | Data output     |
| full     | Output    | FIFO full flag  |
| empty    | Output    | FIFO empty flag |

---

## Testbench

A **Verilog testbench** is provided to validate FIFO functionality.
The testbench includes a **reference memory model** to verify the correctness of read operations.

### Test Cases Implemented

1. Basic write operations
2. Basic read operations
3. Filling the FIFO to capacity
4. Overflow attempt when FIFO is full
5. Reading until FIFO becomes empty
6. Underflow attempt when FIFO is empty
7. Simultaneous read and write operation

The testbench prints **verification messages** and reports errors if mismatches occur.

---

## Simulation

### Compile

```
iverilog -o fifo_tb tb_Sync_FIFO.v
```

### Run Simulation

```
vvp fifo_tb
```

### View Waveform

```
gtkwave fifo.vcd
```

---

## Repository Structure

```
.
├── Synchronous_FIFO.v
├── tb_Sync_FIFO.v
└── README.md
```

---

## Applications

FIFO buffers are widely used in digital systems such as:

* CPU pipelines
* Network routers
* DMA controllers
* Streaming data systems
* FPGA and ASIC data buffering

---

## Author
IRFAN KHAN

This project was developed as part of **Verilog RTL design practice** to understand FIFO architecture, pointer-based buffering, and hardware verification using testbenches.
