module Stack (
    input Clk, RstN, Push, Pop, input [3:0] Data_In,
    output reg [3:0] Data_Out, output reg Full, Empty);

    parameter DEPTH = 8;
    parameter WIDTH = 4;

    reg [WIDTH-1:0] stack [0:DEPTH-1];
    reg [3:0] sp;

    always @(posedge Clk or negedge RstN) begin
        if (!RstN) begin
            sp <= 0;
            Full <= 0;
            Empty <= 1;
        end else begin
            if (Push && !Full) begin
                stack[sp] <= Data_In;
                sp <= sp + 1;
            end
            if (Pop && !Empty) begin
                sp <= sp - 1;
                Data_Out <= stack[sp - 1];
            end
        end

        Full <= (sp == DEPTH);
        Empty <= (sp == 0);
    end

endmodule
