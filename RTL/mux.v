module mux(
    input start_bit,
    input serial_bit,
    input parity_bit,
    input stop_bit,
    input [1:0]mux_sel,
    output TX_OUTPUT
);
assign TX_OUTPUT  = (mux_sel==2'b00)? start_bit:
                    (mux_sel==2'b01)? serial_bit:
                    (mux_sel==2'b10)? parity_bit:  stop_bit;
endmodule