`timescale 1ns/100ps

`include "booth_multiplier.v"

module booth_multiplier_tb;

    reg clk = 0;
    reg signed [7:0] A, B;
    reg start = 0;
    wire signed [15:0] result;
    wire ready;

    booth_multiplier multiplier(
        .operand1(A),
        .operand2(B),
        .start(start),
        .clk(clk),
        .ready(ready),
        .result(result)
    );

    initial begin
        $dumpfile("tb_mult.vcd");
        $dumpvars(0, booth_multiplier_tb);

        // -------------------------------------------------------------

        // $display("test 1: ");
        // A = 10;
        // B = 10;
        // start = 1; #1 start = 0;

        // -------------------------------------------------------------

        // $display("test 2: ");
        // A = -7;
        // B = 30;
        // start = 1; #1 start = 0;

        // -------------------------------------------------------------

        $display("test 3: ");
        A = -12;
        B = -13;
        start = 1; #1 start = 0;

        // -------------------------------------------------------------

        #10
        $display("time = %5d, A = %0d, B = %0d, output = %0d, ready = %0d,",
                     $time, A, B, result, ready);
        $finish;
    end

    always begin
        #0.5 clk <= ~clk;
    end

endmodule