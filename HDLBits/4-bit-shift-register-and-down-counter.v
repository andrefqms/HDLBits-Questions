/*
On load, capture parallel_in and 
initialize the count from it. On each shift, 
shift the word left and decrement the count until zero. Reset clears both registers.
*/

module top_module (
    input wire clk,
    input wire reset,
    input wire load,
    input wire shift,
    input wire [3:0] parallel_in,
    output wire serial_out,
    output wire [3:0] count
);
    reg [3:0] data = {4{1'b0}};
    reg [3:0] remaining = {4{1'b0}};
    assign serial_out = data[3 ];
    assign count = (remaining);
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            data <= {4{1'b0}};
            remaining <= {4{1'b0}};
        end
        else if (load == 1'b1) begin
            data <= parallel_in;
            remaining <= (parallel_in);
        end
        else if (shift == 1'b1) begin
            data <= {data [ 2 : 0 ], 1'b0};
            if (remaining != 0) begin
                remaining <= remaining - 1;
            end
        end
    end
endmodule
