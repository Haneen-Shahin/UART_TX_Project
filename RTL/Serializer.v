module Serializer#(
    parameter N = 8
)(
    input [N-1:0] P_INPUT,
    input CLK,RST,
    input ser_en,load,
    output serial_data_o,
    output reg ser_done
);
reg [N-1:0]shift_reg;
reg [$clog2(N):0]counter;
//
assign serial_data_o = shift_reg[0];  //transmit LSB first
//
always@(posedge CLK or negedge RST)begin
    if(!RST)begin
        shift_reg <= 0;
        counter <= 0;
        ser_done<=0;
    end
    else begin
        if(load)begin
            shift_reg <= P_INPUT;
            counter <= 0;
            ser_done <= 0;
        end
        else if(ser_en)begin
            if(counter < N-1)begin
                shift_reg <= shift_reg >> 1;
                counter <= counter + 1;
                ser_done<=0;
        end
            else if(counter == N-1) begin
                shift_reg <= shift_reg >> 1;
                counter <= counter + 1;
                ser_done <=1; 
            end
            else begin
                ser_done <= 0;
            end
        end
        else begin
            counter <= 0;
            ser_done <= 0;
        end
    end
end
endmodule