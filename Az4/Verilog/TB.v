module TB;
    reg Clk, RstN, Push, Pop;
    reg [3:0] Data_In;

    wire [3:0] Data_Out;
    wire Full, Empty;

    Stack stack (Clk, RstN, Push, Pop, Data_In, Data_Out, Full, Empty);

    always #5
        Clk = ~Clk;

    initial begin
        Clk = 0; RstN = 0; Data_In = 0; Push = 0; Pop = 0;

        #15 RstN = 1;

        #10 Data_In = 4'b0001; Push = 1;
        #10 Data_In = 4'b0010;
        #10 Data_In = 4'b0011;
        #10 Data_In = 4'b0100;
        #10 Data_In = 4'b0101;
        #10 Data_In = 4'b0110;
        #10 Data_In = 4'b0111;
        #10 Data_In = 4'b1000;
        #10 Push = 0;

        #10 Pop = 1; #10 Pop = 0;
        #10 Pop = 1; #10 Pop = 0;
        #10 Pop = 1; #10 Pop = 0;
        #10 Pop = 1; #10 Pop = 0;
        #10 Pop = 1; #10 Pop = 0;
        #10 Pop = 1; #10 Pop = 0;
        #10 Pop = 1; #10 Pop = 0;
        #10 Pop = 1; #10 Pop = 0;

        #50 $finish;
    end

    initial begin
        $monitor("Time: %0t | RstN: %b | Data_In: %b | Push: %b | Pop: %b | Data_Out: %b | Full: %b | Empty: %b",
                 $time, RstN, Data_In, Push, Pop, Data_Out, Full, Empty);
    end

endmodule
