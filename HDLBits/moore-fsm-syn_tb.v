`timescale 1ns/1ps
module moore_fsm_syn_tb;
    reg clk, reset, in;
    wire out;

    top_module uut(.clk(clk), .reset(reset), .in(in), .out(out));
    always #5 clk = ~clk;

    initial begin
        $display("=== Moore FSM (Synchronous Reset) Testbench ===");
        clk = 0; reset = 1; in = 0;
        @(posedge clk); @(posedge clk);
        reset = 0;
        $display("After reset: out=%b (expect 1, state B)", out);

        in = 1; @(posedge clk); @(posedge clk);
        $display("in=1 in B: out=%b (expect 1, stay B)", out);

        in = 0; @(posedge clk); @(posedge clk);
        $display("in=0 in B: out=%b (expect 0, go A)", out);

        in = 1; @(posedge clk); @(posedge clk);
        $display("in=1 in A: out=%b (expect 1, go B)", out);

        // Synchronous reset
        reset = 1;
        @(posedge clk);
        $display("Sync reset asserted: out=%b (expect 1)", out);
        reset = 0;
        @(posedge clk);
        $display("Sync reset released: out=%b", out);

        $finish;
    end
endmodule