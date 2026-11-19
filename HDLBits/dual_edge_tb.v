`timescale 1ns/1ps
module dual_edge_tb;
    reg clk, d;
    wire q;

    top_module uut(.clk(clk), .d(d), .q(q));
    always #5 clk = ~clk;

    initial begin
        $display("=== Dual Edge Detector Testbench ===");
        clk = 0; d = 0;
        #6;  // just after first posedge
        $display("t=%0t clk=%b d=%b q=%b", $time, clk, d, q);

        d = 1; #5;
        $display("t=%0t clk=%b d=%b q=%b (after negedge)", $time, clk, d, q);

        #5;
        $display("t=%0t clk=%b d=%b q=%b (after posedge)", $time, clk, d, q);

        d = 0; #5;
        $display("t=%0t clk=%b d=%b q=%b (after negedge)", $time, clk, d, q);

        #5;
        $display("t=%0t clk=%b d=%b q=%b (after posedge)", $time, clk, d, q);

        // Rapid toggle to stress both edges
        repeat (10) begin
            #3 d = ~d;
            #3 $display("t=%0t clk=%b d=%b q=%b", $time, clk, d, q);
        end

        $finish;
    end
endmodule