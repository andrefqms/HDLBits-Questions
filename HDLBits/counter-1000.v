/*
Count clock cycles from 
zero through 999 and assert tick for one cycle 
as the count wraps. Synchronous reset clears the counter.
*/


module top_module (
    input wire clk,
    input wire reset,
    output wire tick
);
    reg [9:0] count = {10{1'b0}};
    reg pulse = 1'b0;
    assign tick = pulse;
    always @(posedge clk) begin
        pulse <= 1'b0;
        if (reset == 1'b1) begin
            count <= {10{1'b0}};
        end
        else if (count == 999) begin
            count <= {10{1'b0}};
            pulse <= 1'b1;
        end
        else begin
            count <= count + 1;
        end
    end
endmodule