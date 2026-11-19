`timescale 1ns/1ps
module n_bit_shift_register_tb;
    reg  [3:0] SW;
    reg  [3:0] KEY;
    wire [3:0] LEDR;

    // KEY[0]=clk, KEY[1]=E, KEY[2]=L, KEY[3]=w
    top_module uut(.SW(SW), .KEY(KEY), .LEDR(LEDR));

    task clk_pulse;
        begin
            KEY[0] = 1; #10; KEY[0] = 0; #10;
        end
    endtask

    initial begin
        $display("=== N-bit Shift Register Testbench ===");
        SW = 4'b1010;
        KEY = 4'b0000;

        // Load
        KEY[2] = 1;        // L=1
        clk_pulse;
        $display("Load SW=1010: LEDR=%b (expect 1010)", LEDR);

        // Shift with w=0
        KEY[2] = 0; KEY[1] = 1; KEY[3] = 0;
        clk_pulse;
        $display("Shift w=0: LEDR=%b (expect 0100)", LEDR);

        // Shift with w=1
        KEY[3] = 1;
        clk_pulse;
        $display("Shift w=1: LEDR=%b (expect 1001)", LEDR);

        // Hold
        KEY[1] = 0; KEY[3] = 0;
        clk_pulse;
        $display("Hold: LEDR=%b (expect 1001)", LEDR);

        // Load new value
        SW = 4'b0101; KEY[2] = 1;
        clk_pulse;
        $display("Load SW=0101: LEDR=%b (expect 0101)", LEDR);

        $finish;
    end
endmodule