`timescale 1ns/1ps
// NOTE: 4-digital-decimal-counter.v is TRUNCATED in the supplied source.
// The testbench below expects the standard HDLBits 4-digit BCD counter:
//   input clk, reset; output [3:1] ena; output [15:0] q
// where q = {thousands, hundreds, tens, ones}
module four_digital_decimal_counter_tb;
    reg clk, reset;
    wire [3:1] ena;
    wire [15:0] q;

    top_module uut(.clk(clk), .reset(reset), .ena(ena), .q(q));
    always #5 clk = ~clk;

    integer i;
    initial begin
        $display("=== 4-Digit Decimal Counter Testbench ===");
        $display("WARNING: source module is incomplete — fix it before running.");
        clk = 0; reset = 1;
        @(posedge clk); @(posedge clk);
        reset = 0;
        $display("After reset: q=%04d ena=%b", q, ena);

        // Count through 25 cycles, watch ena signals
        for (i = 0; i < 25; i = i + 1) begin
            @(posedge clk);
            #1 $display("q=%04d ena=%b", q, ena);
        end

        // Force rollover 9998 -> 9999 -> 0000
        force uut.thousands = 4'd9;
        force uut.hundreds  = 4'd9;
        force uut.tens      = 4'd9;
        force uut.ones      = 4'd8;
        @(posedge clk); #1 $display("After force 9998 -> %04d", q);
        @(posedge clk); #1 $display("Next          -> %04d (expect 9999)", q);
        @(posedge clk); #1 $display("Next          -> %04d (expect 0000)", q);
        release uut.thousands; release uut.hundreds;
        release uut.tens;       release uut.ones;

        // Reset again
        reset = 1; @(posedge clk); reset = 0;
        $display("After reset: q=%04d", q);
        $finish;
    end
endmodule