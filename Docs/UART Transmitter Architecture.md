The UART Transmitter (UART_TX) is a modular digital IP core implemented in Verilog HDL. It accepts parallel input data (P_INPUT) and converts it into a standard asynchronous serial stream (TX_OUTPUT) with configurable parity generation and real-time status indication (BUSY).  

Architecture & Submodules

Main Controller (Main_controller_FSM): Implements a 5-state FSM (IDLE, START, DATA, PARITY, STOP) to sequence serial framing operations and control flags (load, ser_en, mux_sel, BUSY).  


Serializer (Serializer): Contains an N-bit shift register that loads parallel input data on load and shifts out data LSB-first on ser_en, generating a ser_done pulse upon sending N bits.  


Parity Calculator (paritybit_calc): Generates an even parity bit (P_BIT=0) via XOR logic or an odd parity bit (P_BIT=1) via XNOR logic over the payload.  


Output Multiplexer (mux): Dynamically routes start_bit (1'b0), serial_bit, parity_bit, or stop_bit (1'b1) to the TX_OUTPUT line based on mux_sel.  


System Interconnect

                     +-----------------------------------+
                     |              UART_TX              |
                     |                                   |
                     |  +-----------------------------+  |
  P_INPUT[N-1:0] ----+->|         Serializer          |  |
        load --------+->|  (Shift Reg & Counter)      |  |
      ser_en --------+->|                             |  |
                     |  +--------------+--------------+  |
                     |                 | serial_bit      |
                     |                 v                 |
  P_INPUT[N-1:0] ----+->+--------------+--------------+  |
       P_BIT --------+->|      paritybit_calc         |  |
                     |  +--------------+--------------+  |
                     |                 | parity_bit      |
                     |                 v                 |
                     |  +--------------+--------------+  |
  start_bit (0) -----+->|                             |  |
   stop_bit (1) -----+->|             mux             |->+--- TX_OUTPUT
     mux_sel --------+->|                             |  |
                     |  +-----------------------------+  |
                     |                                   |
     V_INPUT --------+->+-----------------------------+  |
        P_EN --------+->|     Main_controller_FSM     |  |
    ser_done --------+->|                             |->+--- BUSY
                     |  +-----------------------------+  |
                     +-----------------------------------+
