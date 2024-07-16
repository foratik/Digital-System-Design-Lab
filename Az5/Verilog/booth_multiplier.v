module booth_multiplier
(
    input [7:0] operand1,
    input [7:0] operand2,
    input start,
    input clk,
    output ready,
    output reg [15:0] result
);
    wire [16:0] calculating_bits;
    wire [1:0] operation;
    wire init_signal;

    controller control(
        .start(start),
        .lsb_bits(calculating_bits[1:0]),
        .clk(clk),
        .ready(ready),
        .operation(operation),
        .init_signal(init_signal)
    );

    datapath path(
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .init_signal(init_signal),
        .clk(clk),
        .calculating_bits(calculating_bits)
    );

    always @(posedge ready) begin
        result <= calculating_bits[16:1];
    end
    
endmodule


module datapath(
    input [7:0] operand1,
    input [7:0] operand2,
    input [1:0] operation,
    input init_signal,
    input clk,
    output reg [16:0] calculating_bits
);

    wire [16:0] alu_result;
    alu alu_ins(
        .calculating_bits(calculating_bits),
        .operand2(operand2),
        .operation(operation),
        .result(alu_result)
    );

    always @(posedge clk) begin
        if(init_signal) begin
            calculating_bits[0] <= 0;
            calculating_bits[8:1] <= operand1;
            calculating_bits[16:9] <= 0;
        end
        else begin
            calculating_bits <= alu_result;
        end
    end

endmodule

module alu(
    input [16:0] calculating_bits,
    input [7:0] operand2,
    input [1:0] operation,
    output [16:0] result
);
    wire [16:0] add_res = {calculating_bits[16:9] + operand2, calculating_bits[8:0]};
    wire [16:0] sub_res = {calculating_bits[16:9] - operand2, calculating_bits[8:0]};
    wire [16:0] nop_res = calculating_bits;

    wire [16:0] mux_res = operation == 2'b00 ? nop_res : (operation == 2'b01 ? add_res : sub_res);
    
    // arithmetic shift right
    assign result = {mux_res[16], mux_res[16:1]};

endmodule

module controller
(
    input start,
    input [1:0] lsb_bits,
    input clk,
    output ready,
    output [1:0] operation,     // 0 : nothing, 1: add, 2: sub
    output init_signal
);

    assign operation = lsb_bits[0] == lsb_bits[1] ? 2'b00 : (lsb_bits[1] ? 2'b10 : 2'b01);
    assign ready = counter == 0;
    assign init_signal = counter == 0;

    reg [3:0] counter = 0;
    always @(posedge clk) begin
        if((start & ready) | (~ready)) begin
            if(counter == 4'b1000)
                counter <= 0;
            else 
                counter <= counter + 1;
        end
    end

endmodule