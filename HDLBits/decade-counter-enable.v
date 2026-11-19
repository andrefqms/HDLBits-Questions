module top_module (
    input wire clk,
    input wire reset,
    input wire enable,
    output wire [3:0] count
);
    reg [3:0] value = {4{1'b0}};
    assign count = (value);
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            value <= {4{1'b0}};
        end
        else if (enable == 1'b1) begin
            if (value == 9) begin
                value <= {4{1'b0}};
            end
            else begin
                value <= value + 1;
            end
        end
    end
endmodule
