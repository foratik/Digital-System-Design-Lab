module UART (
    input clk, reset, tx_start, rx,
    input [6:0] tx_data,
    output tx, tx_busy, rx_parity_error,
    output wire [6:0] rx_data);

    transmitter transmitter (
        .clk(clk),
        .reset(reset),
        .data_in(tx_data),
        .start(tx_start),
        .tx(tx),
        .busy(tx_busy)
    );

    receiver receiver (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(rx_data),
        .parity_error(rx_parity_error)
    );

endmodule