/*
Start the circuit when s is asserted while reset state A is active. Then examine w in non-overlapping groups of three clock cycles. 
Set z during the cycle after a group contains exactly two 1s; otherwise keep z low. Continue processing groups until reset.
*/

module top_module (
    input wire clk,
    input wire reset,
    input wire s,
    input wire w,
    output wire z
);
    reg active = 1'b0;
    reg pos = 0;
    reg ones = 0;
    reg z_reg = 1'b0;
    assign z = z_reg;
    integer total;
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            active <= 1'b0;
            pos <= 0;
            ones <= 0;
            z_reg <= 1'b0;
        end
        else if (active == 1'b0) begin
            z_reg <= 1'b0;
            if (s == 1'b1) begin
                active <= 1'b1;
                pos <= 0;
                ones <= 0;
            end
        end
        else begin
            z_reg <= 1'b0;
            total = ones;
            if (w == 1'b1) begin
                total = total + 1;
            end
            if (pos == 2) begin
                if (total == 2) begin
                    z_reg <= 1'b1;
                end
                pos <= 0;
                ones <= 0;
            end
            else begin
                pos <= pos + 1;
                ones <= total;
            end
        end
    end
endmodule
