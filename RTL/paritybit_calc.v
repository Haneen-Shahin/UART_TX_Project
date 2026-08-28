module paritybit_calc#(
    parameter N = 8
)(
    input P_BIT,
    input [N-1:0] P_INPUT,
    output reg parity_bit
);
always @(*) begin
    case (P_BIT)
        1'b0: parity_bit = ^ P_INPUT;  //even
        1'b1: parity_bit = ~^ P_INPUT; //odd
        default :  parity_bit = 0;
    endcase
end
endmodule