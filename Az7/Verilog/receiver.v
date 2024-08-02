module receiver (
    input clk, reset, rx,
    output reg [6:0] data_out,
    output reg parity_error);

    reg [3:0] bit_counter;
    reg [7:0] rx_shift_reg;
    reg rx_busy, parity_bit;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            bit_counter <= 0;
            rx_shift_reg <= 0;
            data_out <= 0;
            rx_busy <= 0;
            parity_error <= 0;
        end else if (!rx_busy && rx == 0) begin
            rx_busy <= 1;
            bit_counter <= 1;
        end else if (rx_busy) begin
            case (bit_counter)
                4'd1: rx_shift_reg[0] <= rx;
                4'd2: rx_shift_reg[1] <= rx;
                4'd3: rx_shift_reg[2] <= rx;
                4'd4: rx_shift_reg[3] <= rx;
                4'd5: rx_shift_reg[4] <= rx;
                4'd6: rx_shift_reg[5] <= rx;
                4'd7: rx_shift_reg[6] <= rx;
                4'd8: parity_bit <= rx;
                4'd9: begin
                    rx_busy <= 0;
                    data_out <= rx_shift_reg[6:0];
                    parity_error <= (parity_bit != ^rx_shift_reg[6:0]);
                end
            endcase
            bit_counter <= bit_counter + 1;
        end
    end

endmodule
