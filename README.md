# ⚡ UART-TX-Verilog-Implementation — Digital IC Design & Verification 🚀

![Verilog](https://img.shields.io/badge/Language-Verilog%20%7C%20SystemVerilog-green.svg)
![EDA Tools](https://img.shields.io/badge/EDA-QuestaSim%20%7C%20QuestaLint%20%7C%20Intel%20Quartus-blue.svg)
![FPGA Target](https://img.shields.io/badge/Target-Intel%20Cyclone%20IV-orange.svg)

---

## 📌 Overview

This repository contains a parameterized, cycle-accurate Verilog / SystemVerilog HDL implementation and verification environment for a **Universal Asynchronous Receiver-Transmitter (UART) Transmitter (TX)** subsystem.

The design serializes parallel input data, generates optional even/odd parity, and outputs standard UART frames (1 Start bit, 5–9 Data bits, Optional Parity, and 1–2 Stop bits) with configurable baud rate generators and status flags for seamless integration into embedded SoC bus protocols.

---

## 🏗️ Architecture & Features

The UART TX subsystem is structured around a modular controller-datapath architecture:

* ⚙️ **Main Controller FSM (`Main_controller_FSM.v`):** Manages state sequencing (`IDLE`, `START`, `DATA`, `PARITY`, `STOP`) and control signals.
* 🔄 **Serializer (`Serializer.v`):** Parallel-to-serial shift register converting N-bit parallel input data into a serial bitstream (LSB first).
* 🧮 **Parity Bit Calculator (`paritybit_calc.v`):** Generates configurable even or odd parity bits.
* 🔀 **Multiplexer (`mux.v`):** 4-to-1 multiplexer routing the start bit, serial data, parity bit, or stop bit to the output tx pin.
* 🔝 **Top-Level Wrapper (`UART_TX.v` / `uart_tx_top.v`):** Interconnects the controller FSM, serializer, parity calculator, and multiplexer.
* 🚩 **Status Indicators:** Provides real-time `busy` line status and single-cycle `done` pulse flags for handshaking.
* 🔄 **Reset Configuration:** Supports flexible synchronous and asynchronous reset modes.

---

## ⚙️ Parameters

| Parameter | Default | Allowed Values | Description |
| :--- | :---: | :---: | :--- |
| `N` | `8` | Positive Integer | Data width of the parallel input data bus (`P_INPUT`) |

---

## 🗂️ FSM State & Output Signals Reference

| State | State Code (`cs`) | `mux_sel` | Line Output (`TX_OUTPUT`) | `BUSY` | `load` | `ser_en` | Description |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **IDLE** | `3'b000` | `2'b11` | `stop_bit` (`1'b1`) | `0` | `1` (if `V_INPUT=1`) / `0` | `0` | Waiting state. Asserts `load=1` on valid input to capture data into shift register. |
| **START** | `3'b001` | `2'b00` | `start_bit` (`1'b0`) | `1` | `0` | `0` | Transmits low start bit framing signal. |
| **DATA** | `3'b010` | `2'b01` | `serial_bit` (`shift_reg[0]`) | `1` | `0` | `1` | Enables serializer (`ser_en=1`) to shift data payload LSB-first. |
| **PARITY** | `3'b011` | `2'b10` | `parity_bit` | `1` | `0` | `0` | Transmits calculated parity bit (`P_BIT=0`: Even, `P_BIT=1`: Odd). |
| **STOP** | `3'b100` | `2'b11` | `stop_bit` (`1'b1`) | `1` | `1` (if `V_INPUT=1`) / `0` | `0` | Asserts high stop bit. Pre-loads next data byte directly if `V_INPUT=1`. |
---

## 📁 Repository Structure

```text
UART-TX-Verilog-Implementation/
│
├── 📦 Code/
│   ├── 🛠️ RTL/
│   │   ├── 📄 UART_TX.v              # Top-level wrapper interconnecting sub-modules
│   │   ├── 📄 Main_controller_FSM.v  # Frame state machine & control unit
│   │   ├── 📄 Serializer.v           # Parallel-to-serial shift register
│   │   ├── 📄 paritybit_calc.v       # Configurable parity generation logic
│   │   ├── 📄 mux.v                   # Output multiplexer logic
│   │
│   ├── 📜 Script/
│   │   └── 📄 run_TX.do              # QuestaSim/ModelSim automation script
│   │
│   ├── 🧪 Testbench/
│   │   └── 📄 UART_TX_tb.v           # Comprehensive testbench environment
│   │
│   └── 🗺️ Constraints/
│       ├── 📄 UART_TX.sdc             # Synopsys Design Constraints
│       └── 📄 Constraints_UART_TX.qsf    # Quartus project settings & pin assignments
│
├── 📚 Attached Docs/
│   ├── 🖼️ Waveform.png               # Simulation output waveforms
│   ├── 📄 RTL_Schematics.png         # Synthesized RTL logic schematics
│   ├── 📄 FSM_Transition_Diagram.png # State transition graphs & state tables
│   ├── 📄 QuestaLint_Report.png      # Static code analysis & linting results
│   ├── 📄 Timing_Report.png         # Setup/Hold, Fmax, and path delay reports
│   └── 📄 Debug.log file                  # Placement and I/O pin indexing log
│
├── 📕 Project_documentation_Report.pdf
├── 📄 LICENSE
├── 🙈 .gitignore
└── 📄 README.md
