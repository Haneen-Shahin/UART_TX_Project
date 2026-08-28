module Main_controller_FSM #(
    //input size
    parameter N = 8
)( 
    //inputs
    input V_INPUT,
    input P_EN,
    input CLK,RST,
    input ser_done,
    //outputs
    output reg load,
    output reg ser_en,
    output reg [1:0]mux_sel,
    output reg BUSY

);
 //states
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter PARITY = 3'b011;
    parameter STOP = 3'b100;
//state signals
reg [2:0] cs,ns;

//state memory
always@(posedge CLK or negedge RST)begin
    if(!RST)begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

//next_state_logic
always@(*)begin
    case(cs)
    3'b000:begin //IDLE
        if(V_INPUT == 1)begin
            ns = START;
        end
        else begin
            ns = IDLE;
        end
    end
    3'b001:begin //START
            ns = DATA;
    end
    3'b010:begin //DATA
        if(ser_done)begin
            if(P_EN)begin
               ns = PARITY;
            end
            else begin
               ns = STOP;
            end
        end
        else begin
            ns = DATA;
        end
    end
    3'b011:begin //PARITY
        ns = STOP;
    end
    3'b100:begin //STOP
        if(V_INPUT == 1)begin
            ns = START;
        end
        else begin
            ns = IDLE;
        end
    end
    default : ns = IDLE;
    endcase
end
//output logic
always@(*)begin
    BUSY =1;
    load=0;
    ser_en=0;
    mux_sel=2'b11;
    case(cs)
        3'b000: begin //IDLE
            BUSY = 0;
            mux_sel =2'b11;
            if(V_INPUT)
             load = 1;
        end
        3'b001:begin //START
            mux_sel =2'b00;
        end
        3'b010:begin //DATA
            ser_en=1;
            mux_sel =2'b01;
        end
        3'b011:begin //PARITY
            mux_sel =2'b10;
        end
        3'b100:begin //STOP
            mux_sel =2'b11;
            if(V_INPUT)
             load = 1;
        end
        default: begin
            BUSY =0;
            load=0;
            ser_en=0;
            mux_sel=2'b11;
        end
    endcase
end

endmodule
