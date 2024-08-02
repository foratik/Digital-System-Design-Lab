module transmitter (
    input clk, reset, start,
    input [6:0] data_in,
    output reg tx, busy
);

    reg [3:0] bit_counter;
    reg [7:0] tx_shift_reg;
    reg parity_bit, tx_busy;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            bit_counter <= 0;
            tx_shift_reg <= 0;
            parity_bit <= 0;
            tx <= 1;
            busy <= 0;
            tx_busy <= 0;
        end else if (start && !tx_busy) begin
            tx_shift_reg <= {1'b0, data_in};
            parity_bit <= ^data_in;
            tx_busy <= 1;
            busy <= 1;
            bit_counter <= 0;
        end else if (tx_busy) begin
            case (bit_counter)
                4'd0: tx <= 0;
                4'd1: tx <= tx_shift_reg[0];
                4'd2: tx <= tx_shift_reg[1];
                4'd3: tx <= tx_shift_reg[2];
                4'd4: tx <= tx_shift_reg[3];
                4'd5: tx <= tx_shift_reg[4];
                4'd6: tx <= tx_shift_reg[5];
                4'd7: tx <= tx_shift_reg[6];
                4'd8: tx <= parity_bit;
                4'd9: tx <= 1;
                default: begin
                    tx <= 1;
                    tx_busy <= 0;
                    busy <= 0;
                end
            endcase
            bit_counter <= bit_counter + 1;
        end
    end

endmodule
