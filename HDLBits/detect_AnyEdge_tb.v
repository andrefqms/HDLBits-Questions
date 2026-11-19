`timescale 1ns/1ps
module detect_AnyEdge_tb;
    reg clk;
    reg  [7:0] in;
    wire [7:0] anyedge;

    top_module uut(.clk(clk), .in(in), .anyedge(anyedge));
    always #5 clk = ~clk;

    initial begin
        $display("=== Detect Any Edge Testbench ===");
        clk = 0; in = 8'h00;
        @(posedge clk); @(posedge clk);
        $display("in=%02h anyedge=%02h (initial)", in, anyedge);

        in = 8'b00000001; @(posedge clk); #1;
        $display("in=%02h anyedge=%02h (bit 0 rise)", in, anyedge);

        in = 8'b00000011; @(posedge clk); #1;
        $display("in=%02h anyedge=%02h (bit 1 rise)", in, anyedge);

        in = 8'b10000011; @(posedge clk); #1;
        $display("in=%02h anyedge=%02h (bit 7 rise)", in, anyedge);

        in = 8'b10000011; @(posedge clk); #1;
        $display("in=%02h anyedge=%02h (no change)", in, anyedge);

        in = 8'b01111100; @(posedge clk); #1;
        $display("in=%02h anyedge=%02h (many bits changed)", in, anyedge);

        in = 8'b11111111; @(posedge clk); #1;
        $display("in=%02h anyedge=%02h (all bits rise)", in, anyedge);

        in = 8'b00000000; @(posedge clk); #1;
        $display("in=%02h anyedge=%02h (all bits fall)", in, anyedge);

        $finish;
    end
endmodule