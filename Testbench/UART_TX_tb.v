module  UART_TX_tb();
    parameter N = 8;
    reg [N-1:0]P_INPUT;
    reg V_INPUT;
    reg CLK;
    reg RST;
    reg P_EN;
    reg P_BIT;
    wire TX_OUTPUT;
    wire BUSY;
    //
    UART_TX #(.N(N)) dut(.P_INPUT(P_INPUT),.V_INPUT(V_INPUT),.CLK(CLK),.RST(RST),.P_EN(P_EN),.P_BIT(P_BIT),.TX_OUTPUT(TX_OUTPUT),.BUSY(BUSY));
    //
    initial begin
        CLK=0;
        forever #1 CLK=~CLK;
    end

    initial begin
        P_INPUT=8'b0;
        V_INPUT=0;
        RST=1;  //not active
        P_EN=0;
        P_BIT=0;
        @(negedge CLK); //idle
        RST=0;
        @(negedge CLK); //idle
        RST=1; //not active
        @(negedge CLK);
        
        //start operation
        P_INPUT=8'b1001_0110;
        V_INPUT=0;                //still in idle

        P_EN=1;                          
        P_BIT=0;                 //even parity
        V_INPUT=1;               //move to start
        @(negedge CLK);
        V_INPUT=0;
        @(negedge CLK);          //transition to data state
        P_INPUT=8'b1001_0110;
        repeat(11)@(negedge CLK); //reach stop

        //////////////////////////////////////////////////////////////////////

        V_INPUT=1;
        P_INPUT=8'b1111_0000;
        P_EN=1;                 
        P_BIT=1;                //odd parity
        @(negedge CLK);         //start
        V_INPUT=0;
        @(negedge CLK);         //data
        repeat(11)@(negedge CLK); //reach stop

        /////////////////////////////////////////////////////////////////////

        V_INPUT=1;
        P_INPUT=8'b0000_1111;
        P_EN=0;                 //skip parity
        @(negedge CLK);          //start
        V_INPUT=0;             
        repeat(10)@(negedge CLK);   //reach stop

        /////////////////////////////////////////////////////////////////////

        //sending two frames after each other (Back to Back)
        P_INPUT = 8'b1010_1010;
        P_EN    = 1'b0;
        V_INPUT = 1'b1;

        @(negedge CLK);
        V_INPUT = 1'b0;
         
        @(negedge BUSY);
        @(negedge CLK);

        P_INPUT = 8'b0101_0101;
        V_INPUT = 1'b1;
        @(negedge CLK);
        V_INPUT = 1'b0;

        ///////////////////////////////////////////////////////
        // sudden reset
        P_INPUT = 8'b1100_1100;
        V_INPUT = 1'b1;
        @(negedge CLK);
        V_INPUT = 1'b0;
        repeat(4) @(negedge CLK); 

        RST = 0; 
        @(negedge CLK);
        RST = 1;
        repeat(3) @(negedge CLK);
        $finish;
    end

    initial begin
        $monitor("CLK=%b | RST=%b | P_INPUT=%b | V_INPUT=%b | P_EN=%b | P_BIT=%b | TX_OUTPUT=%b | BUSY=%b ",CLK,RST,P_INPUT,V_INPUT,P_EN,P_BIT,TX_OUTPUT,BUSY);
    end

endmodule