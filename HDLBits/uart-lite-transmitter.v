/*
Build the transmit shift-out logic of a UART, 
given an externally generated one-cycle tick pulse that arrives 
once per baud period (the baud-rate generator itself is out of scope â€” you are only given its output pulse).
A UART frame is: one start bit (0), 8 data bits 
(LSB first), then one stop bit (1). The line idles high between frames.

*/

module top_module (
    input clk,
    input reset,
    input tick,
    input start,
    input [7:0] data,
    output tx,
    output busy
);
    // state: 0 = idle, 1 = start bit, 2..9 = data bits 0..7, 10 = stop bit
    reg [3:0] state;
    reg [7:0] latched_data;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'd0;
            latched_data <= 8'd0;
        end else if (state == 4'd0) begin
            if (start) begin
                latched_data <= data;
                state <= 4'd1;
            end
        end else begin
            if (tick) begin
                if (state == 4'd10)
                    state <= 4'd0;
                else
                    state <= state + 4'd1;
            end
        end
    end

    assign busy = (state != 4'd0);

    assign tx = (state == 4'd0)  ? 1'b1 :
                (state == 4'd1)  ? 1'b0 :
                (state == 4'd10) ? 1'b1 :
                                   latched_data[state - 4'd2];
endmodule
