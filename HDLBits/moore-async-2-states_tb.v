`timescale 1ns/1ps
module moore_async_2_states_tb;
    reg clk, areset, in;
    wire out;

    top_module uut(.clk(clk), .areset(areset), .in(in), .out(out));
    always #5 clk = ~clk;

    initial begin
        $display("=== Moore FSM (Asynchronous Reset) Testbench ===");
        clk = 0; areset = 1; in = 0;
        #7 areset = 0;
        $display("After async reset: out=%b (expect 1, state B)", out);

        in = 1; @(posedge clk); @(posedge clk);
        $display("in=1 in B: out=%b (expect 1)", out);

        in = 0; @(posedge clk); @(posedge clk);
        $display("in=0 in B: out=%b (expect 0, A)", out);

        in = 1; @(posedge clk); @(posedge clk);
        $display("in=1 in A: out=%b (expect 1, B)", out);

        // Async reset in the middle of a clock period
        in = 0; #2;
        areset = 1; #3;
        $display("Async reset mid-cycle: out=%b (expect 1 immediately)", out);
        areset = 0;

        $finish;
    end
endmodule