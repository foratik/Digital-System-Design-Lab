module single_bit_comparator (
    input wire A,
    input wire B,
    input wire A_gt_B_in,
    input wire A_lt_B_in,
    output wire A_gt_B,
    output wire A_lt_B,
    output wire A_eq_B
);

assign A_gt_B = (A & ~B) | (A_gt_B_in & ~(A ^ B));
assign A_lt_B = (~A & B) | (A_lt_B_in & ~(A ^ B));
assign A_eq_B = ~(A_gt_B | A_lt_B);

endmodule

module four_bit_comparator (
    input wire [0:3] A,
    input wire [0:3] B,
    output wire A_gt_B,
    output wire A_lt_B,
    output wire A_eq_B
);

wire [2:0] A_gt_B_internal, A_lt_B_internal, A_eq_B_internal;

single_bit_comparator comp0 (
    .A(A[3]),
    .B(B[3]),
    .A_gt_B_in(1'b0),
    .A_lt_B_in(1'b0),
    .A_gt_B(A_gt_B_internal[2]),
    .A_lt_B(A_lt_B_internal[2]),
    .A_eq_B(A_eq_B_internal[2])
);

single_bit_comparator comp1 (
    .A(A[2]),
    .B(B[2]),
    .A_gt_B_in(A_gt_B_internal[2]),
    .A_lt_B_in(A_lt_B_internal[2]),
    .A_gt_B(A_gt_B_internal[1]),
    .A_lt_B(A_lt_B_internal[1]),
    .A_eq_B(A_eq_B_internal[1])
);

single_bit_comparator comp2 (
    .A(A[1]),
    .B(B[1]),
    .A_gt_B_in(A_gt_B_internal[1]),
    .A_lt_B_in(A_lt_B_internal[1]),
    .A_gt_B(A_gt_B_internal[0]),
    .A_lt_B(A_lt_B_internal[0]),
    .A_eq_B(A_eq_B_internal[0])
);

single_bit_comparator comp3 (
    .A(A[0]),
    .B(B[0]),
    .A_gt_B_in(A_gt_B_internal[0]),
    .A_lt_B_in(A_lt_B_internal[0]),
    .A_gt_B(A_gt_B),
    .A_lt_B(A_lt_B),
    .A_eq_B(A_eq_B)
);

endmodule

module four_bit_comparator_tb;

reg [3:0] A, B;
wire A_gt_B, A_lt_B, A_eq_B;

four_bit_comparator uut (
    .A(A),
    .B(B),
    .A_gt_B(A_gt_B),
    .A_lt_B(A_lt_B),
    .A_eq_B(A_eq_B)
);

initial begin
    $monitor("A=%b B=%b --> A_gt_B=%b | A_lt_B=%b | A_eq_B=%b",
     A, B, A_gt_B, A_lt_B, A_eq_B);
    
    A = 4'b0000; B = 4'b0000;
    #10;
    
    A = 4'b1001; B = 4'b0110;
    #10;
    
    A = 4'b0010; B = 4'b1010;
    #10;
    
    A = 4'b1111; B = 4'b1111;
    #10;
    
    A = 4'b0111; B = 4'b1000;
    #10;
    
    $finish;
end

endmodule
