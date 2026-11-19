`timescale 1ns/1ps
module jk_Flip_Flop_FSM_tb;
    reg clk, areset, j, k;
    wire out;

    top_module uut(.clk(clk), .areset(areset), .j(j), .k(k), .out(out));
    always #5 clk = ~clk;

    initial begin
        $display("=== JK Flip-Flop FSM Testbench ===");
        clk = 0; areset = 1; j = 0; k = 0;
        #7 areset = 0;
        @(posedge clk); @(posedge clk);
        $display("After reset:      out=%b (expect 0/OFF)", out);

        j = 1; k = 0; @(posedge clk); @(posedge clk);
        $display("J=1 K=0 (set):    out=%b (expect 1/ON)", out);

        j = 0; k = 0; @(posedge clk); @(posedge clk);
        $display("J=0 K=0 (hold):   out=%b (expect 1/ON)", out);

        j = 0; k = 1; @(posedge clk); @(posedge clk);
        $display("J=0 K=1 (reset):  out=%b (expect 0/OFF)", out);

        j = 1; k = 1; @(posedge clk); @(posedge clk);
        $display("J=1 K=1 (toggle): out=%b (expect 1/ON)", out);

        j = 1; k = 1; @(posedge clk); @(posedge clk);
        $display("J=1 K=1 (toggle): out=%b (expect 0/OFF)", out);

        j = 0; k = 1; @(posedge clk); @(posedge clk);
        $display("J=0 K=1 (reset):  out=%b (expect 0/OFF)", out);

        $finish;
    end
endmodule