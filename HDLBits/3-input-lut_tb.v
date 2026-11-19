`timescale 1ns/1ps
module three_input_lut_tb;
    reg clk, enable, S, A, B, C;
    wire Z;

    top_module uut(.clk(clk), .enable(enable), .S(S),
                   .A(A), .B(B), .C(C), .Z(Z));
    always #5 clk = ~clk;

    integer i;
    initial begin
        $display("=== 3-Input LUT / Shift Register Testbench ===");
        clk = 0; enable = 0; S = 0; A = 0; B = 0; C = 0;

        // Shift in pattern 10101101 (MSB first)
        enable = 1;
        S = 1; @(posedge clk);
        S = 0; @(posedge clk);
        S = 1; @(posedge clk);
        S = 0; @(posedge clk);
        S = 1; @(posedge clk);
        S = 1; @(posedge clk);
        S = 0; @(posedge clk);
        S = 1; @(posedge clk);
        enable = 0;
        @(posedge clk);

        // Walk through all 8 addresses
        for (i = 0; i < 8; i = i + 1) begin
            {A, B, C} = i[2:0];
            #5;
            $display("ABC=%03b -> Z=%b", {A, B, C}, Z);
        end

        // Check that enable=0 freezes Q
        {A,B,C} = 3'b000;
        enable = 0; S = 1;
        @(posedge clk);
        #5 $display("enable=0, S=1: Z=%b (should be old Q[0])", Z);

        // enable=1 shifts
        enable = 1;
        @(posedge clk);
        #5 $display("enable=1, S=1: Z=%b (should shift)", Z);

        $finish;
    end
endmodule