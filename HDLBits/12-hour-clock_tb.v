`timescale 1ns/1ps
module twelve_hour_clock_tb;
    reg clk, reset, ena;
    wire pm;
    wire [7:0] hh, mm, ss;

    top_module uut(.clk(clk), .reset(reset), .ena(ena),
                   .pm(pm), .hh(hh), .mm(mm), .ss(ss));
    always #5 clk = ~clk;

    task show;
        begin
            $display("time=%0t  %02d:%02d:%02d %s",
                     $time, hh, mm, ss, pm ? "PM" : "AM");
        end
    endtask

    initial begin
        $display("=== 12-Hour Clock Testbench ===");
        clk = 0; reset = 1; ena = 0;
        @(posedge clk); @(posedge clk);
        reset = 0;
        show();  // 12:00:00 AM

        // Tick a few seconds
        ena = 1;
        repeat (5) @(posedge clk);
        show();

        // Force 11:59:58 AM and run rollover to 12:00:00 PM
        force uut.hh = 8'h11;
        force uut.mm = 8'h59;
        force uut.ss = 8'h58;
        force uut.pm = 1'b0;
        @(posedge clk); show();
        @(posedge clk); show();  // 11:59:59
        @(posedge clk); show();  // 12:00:00 PM
        release uut.hh; release uut.mm; release uut.ss; release uut.pm;

        // Force 11:59:58 PM -> 12:00:00 AM
        force uut.hh = 8'h11;
        force uut.mm = 8'h59;
        force uut.ss = 8'h58;
        force uut.pm = 1'b1;
        @(posedge clk); show();
        @(posedge clk); show();
        @(posedge clk); show();  // 12:00:00 AM
        release uut.hh; release uut.mm; release uut.ss; release uut.pm;

        // ena=0 must hold
        ena = 0;
        repeat (3) @(posedge clk);
        show();

        // Sync reset while running
        ena = 1; reset = 1;
        @(posedge clk);
        reset = 0;
        show();

        $finish;
    end
endmodule