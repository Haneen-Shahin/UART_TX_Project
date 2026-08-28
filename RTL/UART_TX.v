module UART_TX #(
    parameter N = 8
    )(
    input [N-1:0]P_INPUT,
    input V_INPUT,
    input CLK,
    input RST,
    input P_EN,
    input P_BIT,
    output TX_OUTPUT,
    output BUSY
);
    wire ser_done;
    wire load;
    wire ser_en;
    wire [1:0] mux_sel;
    wire serial_bit;
    wire parity_bit;
    wire start_bit;
    wire stop_bit;
    assign  start_bit = 1'b0;
    assign  stop_bit = 1'b1;
    //////////////////////////////////////////////////instantiation/////////////////////////////////////////////////////////////////////

    Main_controller_FSM #(.N(N)) fsm(.V_INPUT(V_INPUT),.P_EN(P_EN),.CLK(CLK),.RST(RST),.ser_done(ser_done),
                            .BUSY(BUSY),.load(load),.ser_en(ser_en),.mux_sel(mux_sel));

    Serializer #(.N(N)) ser(.P_INPUT(P_INPUT),.CLK(CLK),.RST(RST),.ser_en(ser_en),.load(load),
                    .serial_data_o(serial_bit),.ser_done(ser_done));

    paritybit_calc #(.N(N)) pc(.P_INPUT(P_INPUT),.P_BIT(P_BIT),.parity_bit(parity_bit));
                
    mux mux_inst(.start_bit(start_bit),.serial_bit(serial_bit),.parity_bit(parity_bit),.stop_bit(stop_bit),.mux_sel(mux_sel),.TX_OUTPUT(TX_OUTPUT));

endmodule