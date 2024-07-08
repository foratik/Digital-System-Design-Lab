module serial_comparator (
    input wire clk,
    input wire reset,
    input wire A,
    input wire B,
    output wire A_gt_B,
    output wire A_lt_B,
    output wire A_eq_B
);

reg A_gt_B_reg, A_lt_B_reg, A_eq_B_reg;

assign A_gt_B = (A & ~B) | (A_gt_B_reg & ~(A ^ B));
assign A_lt_B = (~A & B) | (A_lt_B_reg & ~(A ^ B));
assign A_eq_B = ~(A_gt_B | A_lt_B);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        A_gt_B_reg <= 0;
        A_lt_B_reg <= 0;
        A_eq_B_reg <= 1;
    end else begin
        A_gt_B_reg <= A_gt_B;
        A_lt_B_reg <= A_lt_B;
        A_eq_B_reg <= A_eq_B;
    end
    
end

endmodule


module serial_comparator_tb();

    reg clk;
    reg reset;
    reg A, B;
    wire A_gt_B, A_lt_B, A_eq_B;

    serial_comparator dut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .A_eq_B(A_eq_B)
    );

    always #5 clk = ~clk;

    initial 
    $monitor("Time=%2t, A=%b, B=%b --> A_gt_B=%b | A_lt_B=%b | A_eq_B=%b | reset=%b",
                 $time, A, B, A_gt_B, A_lt_B, A_eq_B, reset);


    initial begin

        $dumpfile("sim_results.vcd");
        $dumpvars(0, serial_comparator_tb);

        clk = 0;
        reset = 1;

        A = 1'b0; B = 1'b0;
        #10 reset = 0;

        #20 A = 1'b1; B = 1'b0;
        
        #20 A = 1'b0; B = 1'b1;
        
        #20 A = 1'b1; B = 1'b1;

        #10 $finish;
        
    end

endmodule
