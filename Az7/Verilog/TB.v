module TB;

    reg clk, reset, tx_start;
    reg [6:0] tx_data;
    wire tx, tx_busy, rx_parity_error;
    wire [6:0] rx_data;

    UART uart (
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .rx(tx),
        .tx(tx),
        .tx_busy(tx_busy),
        .rx_data(rx_data),
        .rx_parity_error(rx_parity_error)
    );

    always #5
        clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        tx_data = 7'b0;
        tx_start = 1'b0;

        #20;
        reset = 1'b1;

        #20;
        tx_data = 7'b000111;
        tx_start = 1'b1;
        #20;
        tx_start = 1'b0;

        wait(~tx_busy);

        #100;

        if ((rx_data == tx_data) && !rx_parity_error) begin
            $display("Test passed: Data received correctly");
        end else begin
            $display("Test failed: Data mismatch or parity error");
        end

        #50;
        $finish;
    end

    initial begin
        $monitor("%3.t: reset=%b, tx_start=%b, tx_data=%b, tx=%b, rx_data=%b, rx_parity_error=%b",
        $time, reset, tx_start, tx_data, tx, rx_data, rx_parity_error);
    end

endmodule
